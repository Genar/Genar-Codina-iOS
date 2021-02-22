//
//  SearchViewModelProtocol.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation

protocol SearchListViewModelProtocol {
    
    var showArtists: ((ArtistEntity)->())? { get set }
    
    var tokenEntity: TokenEntity? { get set }
    
    /// To perform an action when the user selects an item of the table
    var coordinatorDelegate: SearchViewModelCoordinatorDelegate? { get set }
    
    func getArtists(withUsername username: String, completion: @escaping  (ArtistEntity) -> Void)
    
    func setAccessToken(accessToken: String)
    
    func didTapOnArtist(of index : Int)
    
    func getArtistName(at index : Int)->String
    
    func numberOfRowsInSection(section: Int) -> Int
}
