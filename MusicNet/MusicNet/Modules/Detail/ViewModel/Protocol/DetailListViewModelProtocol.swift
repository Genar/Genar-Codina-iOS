//
//  DetailListViewModelProtocol.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 25/2/21.
//

import Foundation

protocol DetailListViewModelProtocol {
    
    var artistId: String? { get set }
    
    var albums: [AlbumModel] { get set }
    
    var showAlbums: (() -> ())? { get set }
    
    var coordinatorDelegate: DetailViewModelCoordinatorDelegate? { get set }

    func viewDidLoad()
    
    func numberOfRowsInSection(section: Int) -> Int
    
    func getAlbumItem(at index: Int) -> AlbumModel?
    
    func isConnectionOn() -> Bool
}
