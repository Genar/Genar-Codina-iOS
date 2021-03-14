//
//  DetailViewModelCoordinatorDelegate.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 25/2/21.
//

import Foundation
import UIKit

protocol DetailViewModelCoordinatorDelegate: class {

    
    /// Action to be performed if an album item is selected
    /// - Parameters:
    ///   - place: album item
    ///   - controller: view controller
    func didSelect(album: AlbumItem, from controller: UIViewController)
}
