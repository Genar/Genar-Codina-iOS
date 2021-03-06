//
//  SearchCoordinator.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 20/2/21.
//

import UIKit

class MainCoordinator: NSObject, BaseCoordinatorProtocol {
    
    /// Keychain key for accessToken
    private let spotifyAccessTokenKey: String = "spotify_access_token_key"

    /// Parent coordinator can have child coordinators
    var childCoordinators = [BaseCoordinatorProtocol]()
    
    /// Navigation controller to push view controllers
    var navigationController: UINavigationController
    
    /// Repository for the view model
    var repository: RepositoryProtocol
    
    /// Coordinator which deals with the view to request credentials
    var authorizeCoordinator: AuthorizeCoordinator?
    
    lazy var viewModel: SearchListViewModelProtocol! = {
        let viewModel = SearchListViewModel(repository: self.repository)
        viewModel.coordinatorDelegate = self
        return viewModel
    }()
    
    /// Inits the coordinator
    /// - Parameter navigationController: navigation controller
    init(navigationController: UINavigationController,
         repository: RepositoryProtocol) {
        
        self.navigationController = navigationController
        self.repository = repository
    }
    
    var tokenEntity: TokenEntity? = nil {
        didSet {
            guard let token = tokenEntity else { return }
            let hasTokenExpired = token.hasTokenExpired()
            if hasTokenExpired {
                print("---Show error")
            } else {
                print("---access_token:\(token.accessToken)")
            }
        }
    }
    
    /// Push the view controller
    func start() {
        
        let vc = SearchViewController.instantiate()
        
        // Setup the view model
        viewModel.coordinatorDelegate = self
        vc.viewModel = viewModel
        vc.viewModel.coordinatorDelegate = self
        
        // Navigation controller will inform this main coordinator when a view controller is shown,
        // by making this main coordinator its delegate.
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    /// Clean coordinators childs
    func didFinishChild(_ child: BaseCoordinatorProtocol?) {

        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

extension MainCoordinator: SearchViewModelCoordinatorDelegate {
 
    /// Navigates to the detail view
    public func showDetail(artistInfo: ArtistInfo) {
        
        let childCoordinator = DetailCoordinator(navigationController: navigationController,
                                                 repository: repository)
        childCoordinator.parentCoordinator = self
        childCoordinator.artistInfo.id = artistInfo.id
        childCoordinator.artistInfo.name = artistInfo.name
        childCoordinator.artistInfo.image = artistInfo.image
        childCoordinators.append(childCoordinator)
        childCoordinator.start()
    }
    
    func showSuitableView() {
        
        if !self.isTokenOk() {
            self.showSpotifyLogin()
        }
    }
    
    /// Show spotify log in view to get an access token
    private func showSpotifyLogin() {
        
        if !isTokenOk() {
            self.authorizeCoordinator = AuthorizeCoordinator(navigationController: self.navigationController)
            if let authorizeCoordinator = self.authorizeCoordinator {
                authorizeCoordinator.parentCoordinator = self
                childCoordinators.append(authorizeCoordinator)
                authorizeCoordinator.start()
            }
        }
    }
    
    private func isTokenOk() -> Bool {
        
        if let token = tokenEntity, !token.hasTokenExpired() {
            return true
        } else {
            return false
        }
    }
}

/// It is the main coordinator and to detect interactions with the navigation controller (i.e. back navigation)
/// it has to inherit from UINavigationControllerDelegate (and consequently from NSObject)
extension MainCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        // Read the view controller we are moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        // Check whether our view controller array already contains that view controller.
        // If it does it means we are pushing a different view controller on top rather than popping it,
        // so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        // We are still here – it means we are popping the view controller,
        // so we can check whether it is a detail view controller
        if let detailViewController = fromViewController as? DetailViewController {
            // We are popping a detail view controller; end its coordinator
            didFinishChild(detailViewController.viewModel.coordinatorDelegate as? (BaseCoordinatorProtocol & DetailProtocol) )
        }
    }
}
