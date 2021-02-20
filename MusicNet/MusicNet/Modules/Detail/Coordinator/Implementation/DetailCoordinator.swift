//
//  DetailCoordinator.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 20/2/21.
//

import UIKit

class DetailCoordinator: BaseCoordinatorProtocol, DetailProtocol {
    
    /// Parent coordinator
    weak var parentCoordinator: SearchCoordinator?
    
    /// Coordinator can have child coordinators
    var childCoordinators: [BaseCoordinatorProtocol] = [BaseCoordinatorProtocol]()
    
    /// Navigation controller to push view controllers
    var navigationController: UINavigationController
    
    /// Info to pass between coordinators
    var detailIdx: Int = 0
    
    /// Inits the coordinator
    /// - Parameter navigationController: navigation controller
    init(navigationController: UINavigationController) {
        
        self.navigationController = navigationController
    }
    
    /// Pushes the view controller
    func start() {
        
        let vc = DetailViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
