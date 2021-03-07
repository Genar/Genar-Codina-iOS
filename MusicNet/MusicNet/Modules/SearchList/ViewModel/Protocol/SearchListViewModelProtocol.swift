//
//  SearchViewModelProtocol.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation
import CoreData

protocol SearchListViewModelProtocol {
    
    var showArtists: (() -> ())? { get set }
    
    var artists: [ArtistModel] { get set }
    
    var tokenEntity: TokenEntity? { get set }
    
    /// To perform an action when the user selects an item of the table
    var coordinatorDelegate: SearchViewModelCoordinatorDelegate? { get set }
    
    var warningsInfo: WarningsInfo { get set }
    
    func getArtists(withUsername username: String)
    
    func setAccessToken(token: TokenEntity)
    
    func getArtistItem(at index : Int) -> ArtistModel
    
    func numberOfRowsInSection(section: Int) -> Int
    
    func clear()
    
    func showSuitableView()
    
    func showDetail(artistInfo: ArtistInfo)
    
    func isConnectionOn() -> Bool
    
    func viewDidLoad()
    
    func showTokenInfo()
}
