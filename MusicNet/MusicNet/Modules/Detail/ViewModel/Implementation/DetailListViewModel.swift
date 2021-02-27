//
//  DetailListViewModel.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 25/2/21.
//

import Foundation

class DetailListViewModel: DetailListViewModelProtocol {

    weak var coordinatorDelegate: DetailViewModelCoordinatorDelegate?

    let repository: RepositoryProtocol
    
    var albums: [AlbumItem]?
    
    var showAlbums: (() -> ())?
    
    var artistId: String? = nil
    
    init(repository: RepositoryProtocol) {
        
        self.repository = repository
    }
    
    func viewDidLoad() {
        
        self.albums = []
        guard let artistId = self.artistId else { return }
        self.repository.getAlbums(withArtistId: artistId) { (albumsEntity) in
            self.albums = albumsEntity.items
            self.showAlbums?()
        }
    }

    
    func numberOfRowsInSection(section: Int) -> Int {
        
        if let albums = albums {
            return albums.count
        } else {
            return 0
        }
    }
    
    func getAlbumItem(at index: Int) -> AlbumItem? {

        return self.albums?[index]
    }
}

