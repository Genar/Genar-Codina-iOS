//
//  Repository.swift
//  MusicNet
//
//  Created by Genar Codina Reverter on 22/2/21.
//

import Foundation

class Repository: RepositoryProtocol {
    
    let requestService: RequestServiceProtocol
    
    init(requestService: RequestServiceProtocol) {
        
        self.requestService = requestService
    }
    
    // MARK: - Web services calls
    
    func setAccessToken(accessToken: String) {
        
        self.requestService.setAccessToken(accessToken: accessToken)
    }
    
    func getArtists(withUsername username: String, completion: @escaping  (ArtistEntity) -> Void) {
        
        let testUrl = "https://api.spotify.com/v1/search?q=michael%20jackson&type=artist"
        guard let url = URL(string: testUrl) else { return }
        _ = requestService.request(url) { [weak self] (result: Result<ArtistEntity>) in
            switch result {
            case .success(let artists):
                completion(artists)
            print("---artists:\(artists)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
