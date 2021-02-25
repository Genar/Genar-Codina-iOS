//
//  SearchListViewModel.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation

class SearchListViewModel: SearchListViewModelProtocol {

    weak var coordinatorDelegate: SearchViewModelCoordinatorDelegate?

    let repository: RepositoryProtocol
    
    var artists: [Artist]?
    
    var showArtists: (() -> ())?
    
    init(repository: RepositoryProtocol) {
        
        self.repository = repository
    }
    
    var tokenEntity: TokenEntity? = nil {
        didSet {
            guard let token = tokenEntity else { return }
            let hasTokenExpired = token.hasTokenExpired()
            if hasTokenExpired {
                print("---Show error")
            } else {
                print("---access_token:\(token.accessToken)")
                self.setAccessToken(accessToken: token.accessToken)
            }
        }
    }
    
    func getArtists(withUsername username: String) {

        self.repository.getArtists(withUsername: username) { (artistEntity) in
            if let artists = artistEntity.artists?.items {
                self.artists = artists
                self.showArtists?()
            }
        }
    }
    
    func setAccessToken(accessToken: String) {
        
        self.repository.setAccessToken(accessToken: accessToken)
    }
    
    func getArtistItem(at index: Int) -> Artist? {

        return self.artists?[index]
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        if let artists = self.artists {
            return artists.count
        } else {
            return 0
        }
    }
    
    func clear() {
        
        self.artists = []
        self.showArtists?()
    }
}
