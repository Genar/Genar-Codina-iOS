//
//  DetailListViewModel.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 25/2/21.
//

import Foundation
import CoreData

fileprivate enum DetailConstants {
    
    static let kAlbumEntity: String = "AlbumEntity"
    
    static let kMusicNet: String = "MusicNet"
    
    static let kId: String = "id"
    
    static let kName: String = "name"
    
    static let kIdEquals: String = "id == %@"
}

class DetailListViewModel: DetailListViewModelProtocol {    

    weak var coordinatorDelegate: DetailViewModelCoordinatorDelegate?

    let repository: RepositoryProtocol
    
    var albums: [AlbumModel] = []
    
    var showAlbums: (() -> ())?
    
    var artistId: String? = nil
    
    private lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: SearchConstants.kMusicNet)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
    private lazy var managedContext = { persistentContainer.viewContext }()
    
    init(repository: RepositoryProtocol) {
        
        self.repository = repository
    }
    
    func viewDidLoad() {
        
        self.albums = []
        guard let artistId = self.artistId else { return }
        let isConnectionOk = isConnectionOn()
        if isConnectionOk {
            getAlbumsFromWebService(withArtistId: artistId)
        } else {
            getAlbumsFromDB(withArtistId: artistId)
        }
    }

    
    func numberOfRowsInSection(section: Int) -> Int {
        
        return self.albums.count
    }
    
    func getAlbumItem(at index: Int) -> AlbumModel? {

        return self.albums[index]
    }
    
    func isConnectionOn() -> Bool {
        
        return repository.isNetworkOn()
    }
    
    private func convertAlbumsFromWebService(albums: AlbumsEntity) {
        
        let albumssModelUrl: [AlbumModel] = albums.items?.map({ album -> AlbumModel in
            let id = album.id
            let name = album.name
            var imageUrl: URL?
            if let albumImages = album.images, albumImages.count > 0,
               let urlImage = albumImages[0].url {
                imageUrl = URL(string: urlImage)
            } else { imageUrl = nil }
            var releaseDate: String?
            if let albumReleaseDate = album.releaseDate { releaseDate = albumReleaseDate
            } else { releaseDate = nil }
            return AlbumModel(id: id!, name: name!, image: nil, imageUrl: imageUrl, releaseDate: releaseDate)
        }) ?? []
        
        self.albums = albumssModelUrl
        self.albums.sort()
    }
    
    private func saveInDB(album: AlbumModel) {
        
        let albumEntity = NSEntityDescription.insertNewObject(forEntityName: DetailConstants.kAlbumEntity,
                                                              into: managedContext) as! AlbumEntity
        
        albumEntity.id = album.id
        albumEntity.name = album.name
        albumEntity.imageUrl = album.imageUrl
        if let urlImage = album.imageUrl {
            NetworkUtils.downloadImage(from: urlImage) { [weak self ](data, response, error) in
                guard let data = data, let _ = response, error == nil else { return }
                guard let self = self else { return }
                albumEntity.image = data
                do {
                    try self.managedContext.save()
                    
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    private func getAlbumsFromWebService(withArtistId artistId: String) {
        
        self.repository.getAlbums(withArtistId: artistId) { [weak self ](albumEntity) in
            guard let self = self else { return }
            self.convertAlbumsFromWebService(albums: albumEntity)
            for album in self.albums {
                self.saveInDB(album: album)
            }
            self.showAlbums?()
        }
    }
    
    private func getAlbumsFromDB(withArtistId artistId: String) {
        
        filterAlbumFromManagedObject(artisId: artistId)
        self.showAlbums?()
    }
    
    private func filterAlbumFromManagedObject(artisId: String) {
        
        let fetchRequest: NSFetchRequest<AlbumEntity> = AlbumEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: DetailConstants.kIdEquals, "\(artisId)")
        let sortDescriptorName = NSSortDescriptor.init(key: DetailConstants.kName, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorName]
        
        var albumsWithImage: [AlbumModel] = []
        if let albums = try? self.persistentContainer.viewContext.fetch(fetchRequest) {
            albumsWithImage = albums.map { (album) -> AlbumModel in
                let id = album.id
                let name = album.name
                let imageData = album.image
                let imageUrlStr = album.imageUrl
                let releaseDate = album.releaseDate
                return AlbumModel(id: id!, name: name!, image: imageData, imageUrl: imageUrlStr, releaseDate: releaseDate)
            }
        }
        self.albums = albumsWithImage
    }
}
