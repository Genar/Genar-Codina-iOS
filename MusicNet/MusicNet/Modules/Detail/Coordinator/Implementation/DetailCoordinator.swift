//
//  DetailCoordinator.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 20/2/21.
//

import UIKit

class DetailCoordinator: BaseCoordinatorProtocol, DetailProtocol {
 
    /// Parent coordinator
    weak var parentCoordinator: MainCoordinator?
    
    /// Coordinator can have child coordinators
    var childCoordinators: [BaseCoordinatorProtocol] = [BaseCoordinatorProtocol]()
    
    /// Navigation controller to push view controllers
    var navigationController: UINavigationController
    
    /// Repository for the view model
    var repository: RepositoryProtocol
    
    /// Info to pass between coordinators
    var artistInfo: ArtistInfo = ArtistInfo(id: "", name: "", image: nil)
    
    lazy var viewModel: DetailListViewModelProtocol! = {
        let viewModel = DetailListViewModel(repository: self.repository)
        viewModel.coordinatorDelegate = self
        viewModel.artistInfo = self.artistInfo
        
        return viewModel
    }()
    
    /// Inits the coordinator
    /// - Parameter navigationController: navigation controller
    init(navigationController: UINavigationController,
         repository: RepositoryProtocol) {
        
        self.navigationController = navigationController
        self.repository = repository
    }
    
    /// Pushes the view controller
    func start() {
        
        let vc = DetailViewController.instantiate()
        
        // Setup the view model
        viewModel.coordinatorDelegate = self
        vc.viewModel = viewModel
        viewModel.artistInfo? = artistInfo
        
        navigationController.pushViewController(vc, animated: true)
    }
}

/// Navigation to next screen
extension DetailCoordinator: DetailViewModelCoordinatorDelegate {
    
    func showDatePicker() {
        
        let childCoordinator = DatePickerCoordinator(navigationController: navigationController)
        childCoordinator.parentCoordinator = self
        childCoordinators.append(childCoordinator)
        childCoordinator.start()
    }
    
    func didSelect(album: AlbumItem, from controller: UIViewController) {
        
        // TO DO: To be implemented if we want to perform
        // an action after clicking an album item
    }
}
