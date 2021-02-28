//
//  AlbumModel.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 27/2/21.
//

import Foundation

public struct AlbumModel: Comparable {
    
    let id: String
    let name: String
    let image: Data?
    let imageUrl: URL?
    let releaseDate: String?
    let artistId: String?
    
    public static func < (lhs: AlbumModel, rhs: AlbumModel) -> Bool {
        
        return lhs.name < rhs.name
    }
    
}

