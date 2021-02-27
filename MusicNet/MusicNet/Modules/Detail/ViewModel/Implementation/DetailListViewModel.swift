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
    
    var albums: [AlbumItem] = []
    
    var showAlbums: (() -> ())?
    
    var artistId: String? = nil
    
    init(repository: RepositoryProtocol) {
        
        self.repository = repository
    }
    
    func viewDidLoad() {
        
        self.albums = []
        guard let artistId = self.artistId else { return }
        self.repository.getAlbums(withArtistId: artistId) { [weak self] (albumsEntity) in
            guard let self = self else { return }
            self.albums = albumsEntity.items ?? []
            self.showAlbums?()
        }
    }

    
    func numberOfRowsInSection(section: Int) -> Int {
        
        return self.albums.count
    }
    
    func getAlbumItem(at index: Int) -> AlbumItem? {

        return self.albums[index]
    }
}

