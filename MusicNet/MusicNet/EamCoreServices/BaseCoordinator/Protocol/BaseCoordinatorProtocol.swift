//
//  BaseCoordinator.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 20/2/21.
//

import UIKit

/// BaseCoordinatorProtocol is an "AnyObject" because coordinators
/// have to be classes so that they can be shared in different places.
protocol BaseCoordinatorProtocol: AnyObject {
    
    /// Child coordinators is a way to make your code easier to follow.
    var childCoordinators: [BaseCoordinatorProtocol] { get set }
    
    var navigationController: UINavigationController { get set }

    func start()
}
