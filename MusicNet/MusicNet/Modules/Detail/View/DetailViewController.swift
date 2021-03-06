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
    
    let dateFormatIn = "yyyy-MM-dd' 'HH:mm:ssZ"
    
    let dateFormatOut = "MMM dd yyyy"
    
    let dateFormat = "%02d-%02d-%02d"
    
    let dummyTimeSuffix = "00:00:00-00"
    
    let localeIdentifier = "en_US_POSIX"
    
    let collectionViewCell = "AlbumCollectionViewCell"

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupBindings()
        
        setupCollectionViewDelegates()
        
        setupUIHeader()
        
        setupUILabels()
        
        self.viewModel.viewDidLoad()
    }
    
    private func setupBindings() {
        
        self.viewModel.showAlbums = { [weak self] in
            guard let self = self else { return }
            self.albumsCollectionView.reloadData()
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
        
        // TODO: Use MVVM-C to handle this new module for picking the start and end dates.
        let vc = DatePickerViewController.instantiate()
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.navigationController?.present(vc, animated: true, completion: {
        })
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
            cell.render(album: albumItem, hasToRenderFromDB: !viewModel.isConnectionOn())
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension DetailViewController: RangeDatesProtocol {
    
    func setRangeDates(start: Date, end: Date) {
        
        self.startDate = start
        self.endDate = end
    
        self.viewModel.setDatesRange(startDate: start, endDate: end)
        self.setLabelTexts()
        self.albumsCollectionView.reloadData()
    }
    
    private func setLabelTexts() {
        
        if let startDate = self.startDate,
           let endDate = self.endDate {
            let componentsStart = Calendar.current.dateComponents([.year, .month, .day], from: startDate)
            if let dayStart = componentsStart.day, let monthStart = componentsStart.month, let yearStart = componentsStart.year {
                let dataStr = String(format: dateFormat, yearStart, monthStart, dayStart)
                let dataStartIn = dataStr + " " + dummyTimeSuffix
                let dataStartOut = convertDateFormat(inputDate: dataStartIn, formatIn: dateFormatIn, formatOut: dateFormatOut, localeId: localeIdentifier)
                self.dateFromLabel.text = DetailViewStrings.fromKey.localized + " " + dataStartOut
            }
            let componentsEnd = Calendar.current.dateComponents([.year, .month, .day], from: endDate)
            if let dayEnd = componentsEnd.day, let monthEnd = componentsEnd.month, let yearEnd = componentsEnd.year {
                let dataFin = String(format: dateFormat, yearEnd, monthEnd, dayEnd)
                let dataEndIn = dataFin + " " + dummyTimeSuffix
                let dataEndOut = convertDateFormat(inputDate: dataEndIn, formatIn: dateFormatIn, formatOut: dateFormatOut, localeId: localeIdentifier)
                self.dateToLabel.text = DetailViewStrings.toKey.localized + " " + dataEndOut
            }
        }
    }
    
    private func convertDateFormat(inputDate: String, formatIn: String, formatOut: String, localeId: String) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: localeId)
        dateFormatter.dateFormat = formatIn
        let date = dateFormatter.date(from:inputDate)!
        
        let formatDate = DateFormatter()
        formatDate.dateFormat = formatOut
        let drawDate = formatDate.string(from: date)
        
        return drawDate
    }
}
