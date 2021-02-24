//
//  AlbumsEntity.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 24/2/21.
//

import Foundation

// MARK: - AlbumsEntity
struct AlbumsEntity: Codable {
    let href: String?
    let items: [AlbumItem]?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
}

// MARK: - Item
struct AlbumItem: Codable {
    let albumGroup, albumType: String?
    let artists: [ArtistItem]?
    let externalUrls: ExternalUrls?
    let href: String?
    let id: String?
    let images: [ImageAlbum]?
    let name, releaseDate, releaseDatePrecision: String?
    let totalTracks: Int?
    let type, uri: String?

    enum CodingKeys: String, CodingKey {
        case albumGroup = "album_group"
        case albumType = "album_type"
        case artists
        case externalUrls = "external_urls"
        case href, id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case type, uri
    }
}

// MARK: - Artist
struct ArtistItem: Codable {
    let externalUrls: ExternalAlbumsUrls?
    let href: String?
    let id, name, type, uri: String?

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, name, type, uri
    }
}

// MARK: - ExternalUrls
struct ExternalAlbumsUrls: Codable {
    let spotify: String?
}

// MARK: - Image
struct ImageAlbum: Codable {
    let height: Int?
    let url: String?
    let width: Int?
}
