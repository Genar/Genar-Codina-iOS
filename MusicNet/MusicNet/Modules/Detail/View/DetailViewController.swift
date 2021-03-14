//
//  DetailViewController.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 20/2/21.
//

import UIKit

protocol RangeDatesProtocol {
    
    func setRangeDates(start: Date, end: Date)
}

enum DetailViewStrings {
    
    static let albumsKey = "albums_key"
    static let datesRangeKey = "dates_range_key"
    static let fromKey = "from_key"
    static let toKey = "to_key"
}

class DetailViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var artistImageView: UIImageView!
    
    @IBOutlet weak var dateFromLabel: UILabel!
    
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    
    @IBOutlet weak var dateToLabel: UILabel!
    
    @IBOutlet weak var datesRangeButton: UIButton!
    
    @IBOutlet weak var albumsLabel: UILabel!
    
    var viewModel: DetailListViewModelProtocol!
    
    var artistInfo: ArtistInfo!
    
    var startDate: Date?
    
    var endDate: Date?
    
    let collectionViewCell = "AlbumCollectionViewCell"

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupBindings()
        
        setupCollectionViewDelegates()
        
        setupUIHeader()
        
        setupUILabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.viewModel.viewWillAppear()
    }
    
    private func setupBindings() {
        
        self.viewModel.showAlbums = { [weak self] in
            guard let self = self else { return }
            self.albumsCollectionView.reloadData()
        }
        
        self.viewModel.showDates = { [weak self] (startDate, endDate) in
            self?.dateFromLabel.text = startDate
            self?.dateToLabel.text = endDate
        }
    }
    
    private func setupUILabels() {
        
        self.datesRangeButton.setTitle(DetailViewStrings.datesRangeKey.localized, for: .normal)
        self.dateFromLabel.text = DetailViewStrings.fromKey.localized
        self.dateToLabel.text = DetailViewStrings.toKey.localized
    }
    
    private func setupCollectionViewDelegates() {
        
        self.albumsCollectionView.dataSource = self
    }
    
    private func setupUIHeader() {
        
        self.artistLabel.text = self.viewModel?.artistInfo?.name
        if let pngData = viewModel?.artistInfo?.image {
            let artistImage = UIImage(data: pngData)
            self.artistImageView.image = artistImage
        }
    }
    
    @IBAction func onDateRangeClicked(_ sender: UIButton) {
        
        self.viewModel.showDatePicker()
    }
}

extension DetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCell,
                                                         for: indexPath) as? AlbumsCollectionViewCell,
           let albumItem: AlbumModel = viewModel.getAlbumItem(at: indexPath.row) {
            let isConnectionOn = viewModel.isConnectionOn()
            cell.render(album: albumItem, hasToRenderFromDB: !isConnectionOn)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
