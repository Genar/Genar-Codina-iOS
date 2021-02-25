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
    
    // To be used when performing drag and drop
    var albumsDictionary: [String: AlbumItem]?
    
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
            self.buildDictionaryDataSource()
            self.showAlbums?()
        }
    }

//    func getAlbumName(at index: Int) -> String {
//        
//        return self.albums?[index].name ?? ""
//    }
    
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
    
    func insert(id: String, at: Int) {
        
        self.albums?.insert(<#T##newElement: AlbumItem##AlbumItem#>, at: <#T##Int#>)
        
    }
    
    private func buildDictionaryDataSource() {
        
        self.albumsDictionary = self.albums?.reduce([String: AlbumItem]()) { (id, album) -> [String : AlbumItem] in
            var dict = id
            if let albumId = album.id {
                dict[albumId] = album
                return dict
            } else {
                return [:]
            }
        }
    }
}

