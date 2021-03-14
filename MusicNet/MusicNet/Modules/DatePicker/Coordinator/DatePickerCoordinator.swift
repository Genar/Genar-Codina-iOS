//
//  DatesPickerCoordinator.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 14/3/21.
//

import UIKit
import Foundation

class DatePickerCoordinator: BaseCoordinatorProtocol {
 
    /// Parent coordinator
    weak var parentCoordinator: DetailCoordinator?
    
    /// Coordinator can have child coordinators
    var childCoordinators: [BaseCoordinatorProtocol] = [BaseCoordinatorProtocol]()
    
    /// Navigation controller to push view controllers
    var navigationController: UINavigationController
    
    lazy var viewModel: DatePickerViewModelProtocol! = {
        
        let viewModel = DatePickerViewModel()
        viewModel.coordinatorDelegate = self
        
        return viewModel
    }()
    
    /// Inits the coordinator
    /// - Parameter navigationController: navigation controller
    init(navigationController: UINavigationController) {
        
        self.navigationController = navigationController
    }
    
    /// Pushes the view controller
    func start() {
        
        let vc = DatePickerViewController.instantiate()
        
        // Setup the view model and presentation style
        viewModel.coordinatorDelegate = self
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        vc.viewModel = viewModel
        viewModel.delegate = parentCoordinator?.viewModel as? RangeDatesProtocol
        
        self.navigationController.present(vc, animated: true, completion: {})
    }
}

/// Navigation to previous screen
extension DatePickerCoordinator: DatePickerViewModelCoordinatorDelegate {
    
    func dismiss() {
        
        self.navigationController.dismiss(animated: true) {
        }
    }
}
