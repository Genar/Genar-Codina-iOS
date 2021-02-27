//
//  ArtistEntity+CoreDataProperties.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 27/2/21.
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
    @NSManaged public var name: String?
    @NSManaged public var popularity: Int16
    @NSManaged public var imageUrl: URL?

}
