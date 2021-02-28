//
//  ArtistModel.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 27/2/21.
//

import Foundation

public struct ArtistModel: Comparable {
    
    let id: String
    let name: String
    let popularity: Int16
    let genre: String?
    var image: Data?
    let imageUrl: URL?
    
    public static func < (lhs: ArtistModel, rhs: ArtistModel) -> Bool {
        
        return lhs.name < rhs.name
    }
    
}
