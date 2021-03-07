//
//  RepositoryProtocol.swift
//  MusicNet
//
//  Created by Genar Codina Reverter on 22/2/21.
//

import Foundation
import Network

protocol RepositoryProtocol {
    
    // MARK: - Properties
    var tokenEntity: TokenEntity? { get set }
    
    // MARK: - Web services
    
    func setAccessToken(token: TokenEntity)
    
    func getArtists(withUsername username: String, completion: ((ArtistsEntity) -> ())? )
    
    func getAlbums(withArtistId artistId: String, completion: ((AlbumsEntity) -> ())? )
    
    // MARK: - Reachability
    
    func isNetworkOn() -> Bool
    
    func startNetworkMonitoring(pathUpdateHandler: ((NWPath) -> Void)?)
}
