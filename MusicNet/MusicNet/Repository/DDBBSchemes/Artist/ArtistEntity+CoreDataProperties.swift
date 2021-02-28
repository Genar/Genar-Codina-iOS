//
//  ArtistEntity+CoreDataProperties.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 28/2/21.
//
//

import Foundation
import CoreData


extension ArtistEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArtistEntity> {
        return NSFetchRequest<ArtistEntity>(entityName: "ArtistEntity")
    }

    @NSManaged public var genre: String?
    @NSManaged public var id: String?
    @NSManaged public var image: Data?
    @NSManaged public var imageUrl: URL?
    @NSManaged public var name: String?
    @NSManaged public var popularity: Int16
    @NSManaged public var albums: NSOrderedSet?

}

// MARK: Generated accessors for albums
extension ArtistEntity {

    @objc(insertObject:inAlbumsAtIndex:)
    @NSManaged public func insertIntoAlbums(_ value: AlbumEntity, at idx: Int)

    @objc(removeObjectFromAlbumsAtIndex:)
    @NSManaged public func removeFromAlbums(at idx: Int)

    @objc(insertAlbums:atIndexes:)
    @NSManaged public func insertIntoAlbums(_ values: [AlbumEntity], at indexes: NSIndexSet)

    @objc(removeAlbumsAtIndexes:)
    @NSManaged public func removeFromAlbums(at indexes: NSIndexSet)

    @objc(replaceObjectInAlbumsAtIndex:withObject:)
    @NSManaged public func replaceAlbums(at idx: Int, with value: AlbumEntity)

    @objc(replaceAlbumsAtIndexes:withAlbums:)
    @NSManaged public func replaceAlbums(at indexes: NSIndexSet, with values: [AlbumEntity])

    @objc(addAlbumsObject:)
    @NSManaged public func addToAlbums(_ value: AlbumEntity)

    @objc(removeAlbumsObject:)
    @NSManaged public func removeFromAlbums(_ value: AlbumEntity)

    @objc(addAlbums:)
    @NSManaged public func addToAlbums(_ values: NSOrderedSet)

    @objc(removeAlbums:)
    @NSManaged public func removeFromAlbums(_ values: NSOrderedSet)

}
