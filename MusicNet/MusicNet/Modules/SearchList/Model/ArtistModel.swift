//
//  ArtistModel.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 27/2/21.
//

import Foundation

public struct ArtistModelImage {
    
    let id: String
    let name: String
    let popularity: Int
    let genre: String?
    let image: Data?
}

public struct ArtistModelUrl {
    
    let id: String
    let name: String
    let popularity: Int
    let genre: String?
    let image: String?
}
