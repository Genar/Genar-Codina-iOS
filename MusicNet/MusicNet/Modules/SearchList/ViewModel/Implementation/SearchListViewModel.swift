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
    
    var artistEntity: ArtistEntity?
    
    var showArtists: ((ArtistEntity)->())?
    
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
                self.getArtists(withUsername: "") { (artistEntity) in
                    self.artistEntity = artistEntity
                    self.showArtists?(artistEntity)
                }
            }
        }
    }
    
    func getArtists(withUsername username: String, completion: @escaping (ArtistEntity) -> Void) {
        
        self.repository.getArtists(withUsername: username, completion: completion)
    }
    
    func setAccessToken(accessToken: String) {
        
        self.repository.setAccessToken(accessToken: accessToken)
    }
    
    func didTapOnArtist(of index: Int) {
        
        //self.coordinatorDelegate?.didTapOnRow(with: self.data![index])
    }
    
    func getArtistName(at index: Int) -> String {
        
        return self.artistEntity?.artists?.items?[index].name ?? ""
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        return (self.artistEntity != nil) ? (self.artistEntity?.artists?.items?.count)! : 0
    }
}
