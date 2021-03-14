//
//  SearchViewModelCoordinatorDelegate.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation
import UIKit

protocol SearchViewModelCoordinatorDelegate: class {
    
    func showSuitableView()
    
    func showDetail(artistInfo: ArtistInfo)
}
