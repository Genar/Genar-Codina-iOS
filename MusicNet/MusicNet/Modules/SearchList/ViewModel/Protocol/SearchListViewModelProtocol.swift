//
//  SearchViewModelProtocol.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation

protocol SearchListViewModelProtocol {
    
    // To perform an action when the user selects an item of the table
    var coordinatorDelegate: SearchViewModelCoordinatorDelegate? { get set }
    
    func getArtists(withUsername username: String)
}
