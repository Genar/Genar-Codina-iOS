//
//  SearchViewModelCoordinatorDelegate.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation
import UIKit

protocol SearchViewModelCoordinatorDelegate: class {

    func didSelect(place: Artists, from controller: UIViewController)
    
    func showSuitableView()
    
    func showDetail(artistId: String)
}
