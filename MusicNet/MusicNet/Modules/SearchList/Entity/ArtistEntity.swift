//
//  ArtistEntity.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation

// MARK: - ArtistEntity
public struct ArtistEntity: Codable {
    let artists: Artists?
}

// MARK: - Artists
public struct Artists: Codable {
    
    let href: String?
    let items: [Item]?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: JSONNull?
    let total: Int?
}

// MARK: - Item
public struct Item: Codable {
    
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
    let href: JSONNull?
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

// MARK: - Encode/decode helpers

public class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
