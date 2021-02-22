//
//  RepositoryProtocol.swift
//  MusicNet
//
//  Created by Genar Codina Reverter on 22/2/21.
//

import Foundation

protocol RepositoryProtocol {
    
    // MARK: - Web services
    
    func setAccessToken(accessToken: String)
    
    func getArtists(withUsername username: String, completion: @escaping  (ArtistEntity) -> Void)
}
