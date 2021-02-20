//
//  SearchCoordinator.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 20/2/21.
//

import UIKit

class SearchCoordinator: NSObject, BaseCoordinatorProtocol {
    
    /// Parent coordinator can have child coordinators
    var childCoordinators = [BaseCoordinatorProtocol]()
    
    /// Navigation controller to push view controllers
    var navigationController: UINavigationController

    /// Inits the coordinator
    /// - Parameter navigationController: navigation controller
    init(navigationController: UINavigationController) {
        
        self.navigationController = navigationController
    }
    
    /// Pushes the view controller
    func start() {
        
        let vc = SearchViewController.instantiate()
        vc.coordinator = self
        // Navigation controller will inform this main coordinator when a view controller is shown,
        // by making this main coordinator its delegate.
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func didFinishChild(_ child: BaseCoordinatorProtocol?) {

        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

extension SearchCoordinator: SearchProtocol {
 
    /// Navigates to the detail view
    func showDetail(itemIdx: Int) {
        
        let childCoordinator = DetailCoordinator(navigationController: navigationController)
        childCoordinator.parentCoordinator = self
        childCoordinator.detailIdx = itemIdx
        childCoordinators.append(childCoordinator)
        childCoordinator.start()
    }
}

/// It is the main coordinator and to detect interactions with the navigation controller (i.e. back navigation)
/// it has to inherit from UINavigationControllerDelegate (and consequently from NSObject)
extension SearchCoordinator: UINavigationControllerDelegate {
    
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
            didFinishChild(detailViewController.coordinator as? (BaseCoordinatorProtocol & DetailProtocol) )
        }
    }
}
