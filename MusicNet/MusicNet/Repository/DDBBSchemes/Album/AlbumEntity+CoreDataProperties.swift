//
//  AlbumEntity+CoreDataProperties.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 28/2/21.
//
//

import Foundation
import CoreData


extension AlbumEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlbumEntity> {
        return NSFetchRequest<AlbumEntity>(entityName: "AlbumEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var image: Data?
    @NSManaged public var imageUrl: URL?
    @NSManaged public var name: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var artistId: String?
    @NSManaged public var artist: ArtistEntity?

}
