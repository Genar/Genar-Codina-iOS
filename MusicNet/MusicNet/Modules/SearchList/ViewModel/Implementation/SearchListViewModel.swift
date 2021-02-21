//
//  SearchListViewModel.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation

class SearchListViewModel: SearchListViewModelProtocol {
    
    weak var coordinatorDelegate: SearchViewModelCoordinatorDelegate?
    
    // In case we need to cancel a task we store it
    var tasks = [URLSessionDataTask]()
    
    func getArtists(withUsername username: String) {
        
        let testUrl = "https://api.spotify.com/v1/search?q=michael%20jackson&type=artist"
        guard let url = URL(string: testUrl) else { return }
        let task = RequestService.shared.request(url) { [weak self] (result: Result<ArtistEntity>) in
            switch result {
            case .success(let artists):
                //self?.artists = repositories.sorted(by: { $0.starCount > $1.starCount })
                //self?.artists.reloadData()
            print(artists)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        tasks.append(task)
    }
}
