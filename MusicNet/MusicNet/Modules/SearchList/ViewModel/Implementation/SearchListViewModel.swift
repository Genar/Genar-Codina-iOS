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
    
    var artists: [ArtistModelUrl] = []
    
    var artistsImage: [ArtistModelImage] = []
    
    var showArtists: (() -> ())?
    
    private lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "MusicNet")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
    private lazy var managedContext = { persistentContainer.viewContext }()
    private lazy var entity = { NSEntityDescription.entity(forEntityName: "ArtistEntity", in: self.managedContext)! }()
    private lazy var artistManagedObject = { NSManagedObject(entity: entity, insertInto: managedContext) }()
    
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
        
        let isConnectionOk = isConnectionOn()
        if isConnectionOk {
            getArtistFromWebService(withUserName: username)
        } else {
            getArtistFromDB(withUserName: username)
        }
    }
    
    func setAccessToken(accessToken: String) {
        
        self.repository.setAccessToken(accessToken: accessToken)
    }
    
    func getArtistItem(at index: Int) -> ArtistModelUrl {

        return self.artists[index]
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        return artists.count
    }
    
    func clear() {
        
        self.artists = []
        self.showArtists?()
    }
    
    func saveImageInDB(data: Data?) {
        
        artistManagedObject.setValue(data, forKeyPath: "image")
    }
    
    func isConnectionOn() -> Bool {
        
        return true
    }
    
    // MARK: - Private methods
    
    private func saveInDB(artist: ArtistModelUrl) {
        
        artistManagedObject.setValue(artist.id, forKeyPath: "id")
        artistManagedObject.setValue(artist.name, forKeyPath: "name")
        if let genre = artist.genre {
            artistManagedObject.setValue(genre, forKeyPath: "genre")
        }
        artistManagedObject.setValue(artist.popularity, forKeyPath: "popularity")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func convertArtistsFromManagedObject(artistsManagedObject: [NSManagedObject]) {
        
        let artists: [ArtistModelImage] = artistsManagedObject.map { (managedObject) -> ArtistModelImage in
            let id = managedObject.value(forKeyPath: "id") as? String
            let name = managedObject.value(forKeyPath: "name") as? String
            let popularity = managedObject.value(forKeyPath: "popularity") as? Int
            let genre = managedObject.value(forKeyPath: "genre") as? String
            let imageData = managedObject.value(forKeyPath: "image") as? Data
            return ArtistModelImage(id: id!, name: name!, popularity: popularity ?? 0, genre: genre, image: imageData)
        }
        self.artistsImage = artists
    }
    
    private func convertArtistsFromWebService(artists: ArtistsEntity) {
        
        let artistsModelUrl: [ArtistModelUrl] = artists.artists?.items?.map({ artist -> ArtistModelUrl in
            let id = artist.id
            let name = artist.name
            var genre: String?
            var imageUrl: String?
            if let artistGenres = artist.genres, artistGenres.count > 0 { genre = artistGenres[0]
            } else { genre = nil }
            if let artistImages = artist.images, artistImages.count > 0 { imageUrl = artistImages[0].url
            } else { imageUrl = nil }
            let popularity = artist.popularity
            
            return ArtistModelUrl(id: id!, name: name!, popularity: popularity ?? 0, genre: genre, image: imageUrl)
        }) ?? []
        
        self.artists = artistsModelUrl
        
//        let artists: [ArtistModelUrl] = artists.map { (artist) -> ArtistModelUrl in
//            let id = artist.id
//            let name = artist.name
//            let popularity = artist.popularity
//            let genre = artist.genre
//            let imageUrl = artist.image
//                return ArtistModelUrl(id: id, name: name, popularity: popularity ?? 0, genre: genre, image: imageData)
//        }
//        self.artists = artists
    }
    
    private func getArtistFromWebService(withUserName username: String) {
        
        self.repository.getArtists(withUsername: username) { [weak self ](artistEntity) in
            guard let self = self else { return }
            self.convertArtistsFromWebService(artists: artistEntity)
            for artist in self.artists {
                self.saveInDB(artist: artist)
            }
            self.showArtists?()
        }
    }
    
    private func getArtistFromDB(withUserName username: String) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ArtistEntity")
        do {
            let artistsManagedObject: [NSManagedObject] = try managedContext.fetch(fetchRequest)
            convertArtistsFromManagedObject(artistsManagedObject: artistsManagedObject)
            self.showArtists?()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
