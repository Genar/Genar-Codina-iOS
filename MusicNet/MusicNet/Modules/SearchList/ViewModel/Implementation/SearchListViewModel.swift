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
    
    var showArtists: ((ArtistsEntity) -> ())?
    
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
            self.showArtists?(artistEntity)
        }
    }
    
    func setAccessToken(accessToken: String) {
        
        self.repository.setAccessToken(accessToken: accessToken)
    }
    
    func didTapOnArtist(of index: Int) {
        
        //self.coordinatorDelegate?.didTapOnRow(with: self.data![index])
    }
    
    func getArtistName(at index: Int) -> String {
        
        return self.artists?[index].name ?? ""
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        if let artists = artists {
            return artists.count
        } else {
            return 0
        }
    }
}
