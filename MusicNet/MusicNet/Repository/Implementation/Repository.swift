//
//  Repository.swift
//  MusicNet
//
//  Created by Genar Codina Reverter on 22/2/21.
//

import Foundation

class Repository: RepositoryProtocol {
    
    let baseConfig: BaseConfigProtocol
    let endPoints: EndPointsProtocol
    let requestService: RequestServiceProtocol
    
    init(baseConfig: BaseConfigProtocol,
         endPoints: EndPointsProtocol,
         requestService: RequestServiceProtocol) {
        
        self.baseConfig = baseConfig
        self.endPoints = endPoints
        self.requestService = requestService
    }
    
    // MARK: - Web services calls
    
    func setAccessToken(accessToken: String) {
        
        self.requestService.setAccessToken(accessToken: accessToken)
    }
    
    func getArtists(withUsername username: String, completion: ((ArtistsEntity) -> ())? ) {
        
        let searchUrl = baseConfig.baseUrl + endPoints.search + "?q=" + "\(username)" + "&type=artist"
        guard let url = URL(string: searchUrl) else { return }
        _ = requestService.request(url) { (result: Result<ArtistsEntity>) in
            switch result {
            case .success(let artists):
                if let completion = completion {
                    completion(artists)
                }
            print("---artists:\(artists)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
