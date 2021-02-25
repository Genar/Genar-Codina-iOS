//
//  DetailListViewModelProtocol.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 25/2/21.
//

import Foundation

protocol DetailListViewModelProtocol {
    
    var artistId: String? { get set }
    
    var albums: [AlbumItem]? { get set }
    
    var showAlbums: ((AlbumsEntity) -> ())? { get set }
    
    var coordinatorDelegate: DetailViewModelCoordinatorDelegate? { get set }

    //func getAlbums(withArtistId artistId: String, completion: ((AlbumsEntity) -> ())?)
    func viewDidLoad()
}
