//
//  SearchListViewModel.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation
import CoreData

class SearchListViewModel: SearchListViewModelProtocol {

    weak var coordinatorDelegate: SearchViewModelCoordinatorDelegate?

    let repository: RepositoryProtocol
    
    var artists: [Artist]?
    
    var artistsManagedObject: [NSManagedObject] = []
    
    var showArtists: (() -> ())?
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "MusicNet")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
    init(repository: RepositoryProtocol) {
        
        self.repository = repository
    }
    
    var tokenEntity: TokenEntity? = nil {
        didSet {
            guard let token = tokenEntity else { return }
            let hasTokenExpired = token.hasTokenExpired()
            if hasTokenExpired {
                print("---Show error")
            } else {
                print("---access_token:\(token.accessToken)")
                self.setAccessToken(accessToken: token.accessToken)
            }
        }
    }
    
    func getArtists(withUsername username: String) {
        
        var isConnectionOk = true
        if isConnectionOk {
            getArtistFromWebService(withUserName: username)
        } else {
            getArtistFromDB(withUserName: username)
        }
    }
    
    func setAccessToken(accessToken: String) {
        
        self.repository.setAccessToken(accessToken: accessToken)
    }
    
    func getArtistItem(at index: Int) -> Artist? {

        return self.artists?[index]
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        if let artists = self.artists {
            return artists.count
        } else {
            return 0
        }
    }
    
    func clear() {
        
        self.artists = []
        self.showArtists?()
    }
    
    // MARK: - Private methods
    
    private func saveInDB(artist: Artist) {
        
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ArtistEntity", in: managedContext)!
        let artistManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        artistManagedObject.setValue(artist.id, forKeyPath: "id")
        artistManagedObject.setValue(artist.name, forKeyPath: "name")
        if let genres = artist.genres, genres.count > 0 {
            let genre = genres[0]
            artistManagedObject.setValue(genre, forKeyPath: "genre")
        }
        if let images = artist.images, images.count > 0,
           let imageUrl = images[0].url {
            let imageUri = URL(string: imageUrl)
            artistManagedObject.setValue(imageUri, forKeyPath: "image")
        }
        
        artistManagedObject.setValue(artist.popularity, forKeyPath: "popularity")
        do {
            try managedContext.save()
            artistsManagedObject.append(artistManagedObject)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func convertArtists(artistsManagedObject: [NSManagedObject]) {
        
        let artists: [Artist] = artistsManagedObject.map { (managedObject) -> Artist in
            let id = managedObject.value(forKeyPath: "id") as? String
            let name = managedObject.value(forKeyPath: "name") as? String
            let popularity = managedObject.value(forKeyPath: "popularity") as? Int
            let genre = managedObject.value(forKeyPath: "genre") as? String
            if let genre = genre {
                return Artist(externalUrls: nil, followers: nil, genres: [genre], href: nil, id: id, images: nil, name: name, popularity: popularity, type: nil, uri: nil)
            } else {
                return Artist(externalUrls: nil, followers: nil, genres: nil, href: nil, id: id, images: nil, name: name, popularity: popularity, type: nil, uri: nil)
            }
        }
        self.artists = artists
    }
    
    private func getArtistFromWebService(withUserName username: String) {
        
        self.repository.getArtists(withUsername: username) { [weak self ](artistEntity) in
            guard let self = self else { return }
            if let artists = artistEntity.artists?.items {
                self.artists = artists
                for artist in artists {
                    self.saveInDB(artist: artist)
                }
                self.showArtists?()
            }
        }
    }
    
    private func getArtistFromDB(withUserName username: String) {
        
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ArtistEntity")
        do {
            artistsManagedObject = try managedContext.fetch(fetchRequest)
            convertArtists(artistsManagedObject: artistsManagedObject)
            self.showArtists?()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
