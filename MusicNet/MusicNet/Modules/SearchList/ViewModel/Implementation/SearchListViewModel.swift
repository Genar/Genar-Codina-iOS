//
//  SearchListViewModel.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import CoreData
import Foundation
import Network

enum SearchConstants {
    
    static let kArtistEntity: String = "ArtistEntity"
    
    static let kMusicNet: String = "MusicNet"
    
    static let kName: String = "name"
    
    static let kNameContains: String = "name CONTAINS[c] %@"
    
    static let kNoInternetConnection: String = "no_internet_connection"
    
    static let kGoToLogIn: String = "go_to_log_in"
    
    static let kLogIn: String = "log_in"
    
    static let kTokenExpired: String = "token_expired"
}

class SearchListViewModel: SearchListViewModelProtocol {
    
    weak var coordinatorDelegate: SearchViewModelCoordinatorDelegate?

    private let repository: RepositoryProtocol
    
    var artists: [ArtistModel] = []
    
    var showArtists: (() -> ())?
    
    var warningsInfo = WarningsInfo(info: Observable(""), showLogin: Observable(SearchConstants.kLogIn.localized))
    
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
        
        managedContext.mergePolicy = NSOverwriteMergePolicy
    }
    
    var tokenEntity: TokenEntity? = nil {
        didSet {
            guard let token = tokenEntity else { return }
            let hasTokenExpired = token.hasTokenExpired()
            if !hasTokenExpired {
                self.setAccessToken(token: token)
            }
            showTokenInfo()
        }
    }
    
    func getArtists(withUsername username: String) {
        
        let isConnectionOk = isConnectionOn()
        if isConnectionOk && !(tokenEntity?.hasTokenExpired() ?? true) {
            getArtistFromWebService(withUserName: username)
        } else {
            getArtistFromDB(withUserName: username)
        }
    }
    
    func setAccessToken(token: TokenEntity) {
        
        self.repository.setAccessToken(token: token)
    }
    
    func getArtistItem(at index: Int) -> ArtistModel {

        return self.artists[index]
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        return artists.count
    }
    
    func clear() {
        
        self.artists = []
        self.showArtists?()
    }
    
    func isConnectionOn() -> Bool {
        
        return self.repository.isNetworkOn()
    }
    
    func showSuitableView() {
        
        let isConnectionOk = isConnectionOn()
        if isConnectionOk {
            if let coordinator = self.coordinatorDelegate {
                coordinator.showSuitableView()
            }
        }
    }
    
    func showDetail(artistInfo: ArtistInfo) {
        
        coordinatorDelegate?.showDetail(artistInfo: artistInfo)
    }
    
    func viewDidLoad() {
        
        let isConnectionOk = isConnectionOn()
        if !isConnectionOk {
            self.showWarningsInfo(info: SearchConstants.kNoInternetConnection.localized, hasToShowLogin: "")
        } else {
            showTokenInfo()
        }
        
        let pathUpdateHandler: ((NWPath) -> Void )? = { [weak self] path in
            guard let self = self else { return }
            if path.status == .satisfied {
                print("----We are connected!")
                if let tokenEntity = self.tokenEntity {
                    if tokenEntity.hasTokenExpired() {
                        self.showWarningsInfo(info: SearchConstants.kTokenExpired.localized, hasToShowLogin: SearchConstants.kLogIn.localized)
                    } else {
                        self.showWarningsInfo(info: "", hasToShowLogin: "")
                    }
                } else {
                    self.showWarningsInfo(info: SearchConstants.kGoToLogIn.localized, hasToShowLogin: SearchConstants.kLogIn.localized)
                }
            } else {
                print("----No internet connection.")
                self.showWarningsInfo(info: SearchConstants.kNoInternetConnection.localized, hasToShowLogin: "")
            }
            print(path.isExpensive)
        }
        repository.startNetworkMonitoring(pathUpdateHandler: pathUpdateHandler)
    }
    
    public func showTokenInfo() {
        
        guard let tokenEntity = self.tokenEntity else {
            self.showWarningsInfo(info: SearchConstants.kGoToLogIn.localized, hasToShowLogin: SearchConstants.kLogIn.localized)
            return
        }

        if tokenEntity.hasTokenExpired() {
            self.showWarningsInfo(info: SearchConstants.kGoToLogIn.localized, hasToShowLogin: SearchConstants.kLogIn.localized)
        } else {
            self.showWarningsInfo(info: "", hasToShowLogin: "")
        }
    }
    // MARK: - Private methods
    
    private func saveInDB(artist: ArtistModel) {
        
        let artistEntity = NSEntityDescription.insertNewObject(forEntityName: SearchConstants.kArtistEntity,
                                                               into: managedContext) as! ArtistEntity
        
        artistEntity.id = artist.id
        artistEntity.name = artist.name
        if let genre = artist.genre {
            artistEntity.genre = genre
        }
        artistEntity.popularity = artist.popularity
        artistEntity.imageUrl = artist.imageUrl
        if let urlImage = artist.imageUrl {
            NetworkUtils.downloadImage(from: urlImage) { [weak self ](data, response, error) in
                guard let data = data, let _ = response, error == nil else { return }
                guard let self = self else { return }
                artistEntity.image = data
                do {
                    try self.managedContext.save()
                    
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    private func filterArtistsFromManagedObject(artistName: String) {
        
        let fetchRequest: NSFetchRequest<ArtistEntity> = ArtistEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: SearchConstants.kNameContains, "\(artistName)")
        let sortDescriptorName = NSSortDescriptor.init(key: SearchConstants.kName, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorName]
        
        var artistsWithImage: [ArtistModel] = []
        if let artists = try? self.persistentContainer.viewContext.fetch(fetchRequest) {
            artistsWithImage = artists.map { (artist) -> ArtistModel in
                let id = artist.id
                let name = artist.name
                let popularity = Int16(artist.popularity)
                let genre = artist.genre
                let imageData = artist.image
                let imageUrlStr = artist.imageUrl
                return ArtistModel(id: id!, name: name!, popularity: popularity, genre: genre, image: imageData, imageUrl: imageUrlStr)
            }
        }
        self.artists = artistsWithImage
    }
    
    private func convertArtistsFromWebService(artists: ArtistsEntity) {
        
        let artistsModelUrl: [ArtistModel] = artists.artists?.items?.map({ artist -> ArtistModel in
            let id = artist.id
            let name = artist.name
            var genre: String?
            var imageUrl: URL?
            if let artistGenres = artist.genres, artistGenres.count > 0 { genre = artistGenres[0]
            } else { genre = nil }
            if let artistImages = artist.images, artistImages.count > 0,
               let urlImage = artistImages[0].url {
                imageUrl = URL(string: urlImage)
            } else { imageUrl = nil }
            let popularity = artist.popularity
            return ArtistModel(id: id!, name: name!, popularity: Int16(popularity ?? 0),
                               genre: genre, image: nil, imageUrl: imageUrl)
        }) ?? []
        
        self.artists = artistsModelUrl
        self.artists.sort()
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
    
    private func getArtistFromDB(withUserName artistName: String) {
        
        filterArtistsFromManagedObject(artistName: artistName)
        self.showArtists?()
    }
    
    private func showWarningsInfo(info: String, hasToShowLogin: String) {
        
        DispatchQueue.main.async {
            self.warningsInfo.info.value = info
            self.warningsInfo.showLogin.value = hasToShowLogin
        }
    }
}
