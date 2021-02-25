//
//  DetailViewModelCoordinatorDelegate.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 25/2/21.
//

import Foundation
import UIKit

protocol DetailViewModelCoordinatorDelegate: class {

    func didSelect(place: AlbumItem, from controller: UIViewController)
}
