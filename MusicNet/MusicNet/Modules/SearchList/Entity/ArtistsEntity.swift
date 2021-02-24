//
//  ArtistEntity.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation

// MARK: - ArtistEntity
public struct ArtistsEntity: Codable {
    let artists: Artists?
}

// MARK: - Artists
public struct Artists: Codable {
    
    let href: String?
    let items: [Artist]?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
}

// MARK: - Artist
public struct Artist: Codable {
    
    let externalUrls: ExternalUrls?
    let followers: Followers?
    let genres: [String]?
    let href: String?
    let id: String?
    let images: [Image]?
    let name: String?
    let popularity: Int?
    let type: TypeEnum?
    let uri: String?

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case followers, genres, href, id, images, name, popularity, type, uri
    }
}

// MARK: - ExternalUrls
public struct ExternalUrls: Codable {
    let spotify: String?
}

// MARK: - Followers
public struct Followers: Codable {
    let href: String?
    let total: Int?
}

// MARK: - Image
public struct Image: Codable {
    let height: Int?
    let url: String?
    let width: Int?
}

public enum TypeEnum: String, Codable {
    case artist = "artist"
}
