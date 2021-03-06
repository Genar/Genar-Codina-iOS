//
//  Repository.swift
//  MusicNet
//
//  Created by Genar Codina Reverter on 22/2/21.
//

import Foundation
import Network

class Repository: RepositoryProtocol {

    let baseConfig: BaseConfigProtocol
    let endPoints: EndPointsProtocol
    let requestService: RequestServiceProtocol
    let reachabilityService: ReachabilityServiceProtocol
    
    var tokenEntity: TokenEntity?
    
    init(baseConfig: BaseConfigProtocol,
         endPoints: EndPointsProtocol,
         requestService: RequestServiceProtocol,
         reachabilityService: ReachabilityServiceProtocol) {
        
        self.baseConfig = baseConfig
        self.endPoints = endPoints
        self.requestService = requestService
        self.reachabilityService = reachabilityService
    }
    
    // MARK: - Web services calls
    
    func setAccessToken(token: TokenEntity) {
        
        self.requestService.setAccessToken(token: token)
        self.tokenEntity = token
    }
    
    func getArtists(withUsername username: String, completion: ((ArtistsEntity) -> ())? ) {
        
        let searchUrl = baseConfig.baseUrl + endPoints.search + "?q=" + "\(username)" + "&type=artist"
        let searchUrlWithNoSpace = searchUrl.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: searchUrlWithNoSpace) else { return }
        _ = requestService.request(url) { (result: Result<ArtistsEntity>) in
            switch result {
            case .success(let artists):
                if let completion = completion {
                    completion(artists)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getAlbums(withArtistId artistId: String, completion: ((AlbumsEntity) -> ())?) {
        
        let albumsForArtistEndPoint = baseConfig.baseUrl + String(format: endPoints.albums, artistId)
        guard let url = URL(string: albumsForArtistEndPoint) else { return }
        _ = requestService.request(url) { (result: Result<AlbumsEntity>) in
            switch result {
            case .success(let albums):
                if let completion = completion {
                    completion(albums)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Reacability service calls
    
    func isNetworkOn() -> Bool {
        
        self.reachabilityService.isNetworkReachable()
    }
    
    func startNetworkMonitoring(pathUpdateHandler: ((NWPath) -> Void)?) {
        
        self.reachabilityService.startNetworkMonitoring(pathUpdateHandler: pathUpdateHandler)
    }
}
