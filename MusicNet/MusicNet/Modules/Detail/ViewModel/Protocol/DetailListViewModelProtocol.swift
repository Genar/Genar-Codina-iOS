//
//  DetailListViewModelProtocol.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 25/2/21.
//

import Foundation

protocol DetailListViewModelProtocol {
    
    var artistInfo: ArtistInfo? { get set }
    
    var albums: [AlbumModel] { get set }
    
    var showAlbums: (() -> ())? { get set }
    
    var showDates: ((_ startDate: String, _ endDate: String) -> ())? { get set }
    
    var coordinatorDelegate: DetailViewModelCoordinatorDelegate? { get set }

    func viewWillAppear()
    
    func numberOfRowsInSection(section: Int) -> Int
    
    func getAlbumItem(at index: Int) -> AlbumModel?
    
    func isConnectionOn() -> Bool
    
    func setDatesRange(startDate: Date, endDate: Date)
    
    func showDatePicker()
}
