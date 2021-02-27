//
//  SearchViewModelProtocol.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation
import CoreData

protocol SearchListViewModelProtocol {
    
    var showArtists: (() -> ())? { get set }
    
    //var artists: [Artist]? { get set }
    
    var artists: [ArtistModelUrl] { get set }
    
    //var artistsManagedObject: [NSManagedObject] { get set }
    
    var tokenEntity: TokenEntity? { get set }
    
    /// To perform an action when the user selects an item of the table
    var coordinatorDelegate: SearchViewModelCoordinatorDelegate? { get set }
    
    func getArtists(withUsername username: String)
    
    func setAccessToken(accessToken: String)
    
    func getArtistItem(at index : Int) -> ArtistModelUrl
    
    func numberOfRowsInSection(section: Int) -> Int
    
    func clear()
    
    func saveImageInDB(data: Data?)
    
    func isConnectionOn() -> Bool
}
