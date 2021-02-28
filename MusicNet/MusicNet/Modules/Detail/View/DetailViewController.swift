//
//  DetailViewController.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 20/2/21.
//

import UIKit

class DetailViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var artistImageView: UIImageView!
    
    @IBOutlet weak var dateFromLabel: UILabel!
    
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    
    @IBOutlet weak var dateToLabel: UILabel!
    
    @IBOutlet weak var datesRangeButton: UIButton!
    
    @IBOutlet weak var albumsLabel: UILabel!
    
    weak var coordinator: DetailProtocol?
    
    var viewModel: DetailListViewModelProtocol!
    
    //var artistId: String!
    
    var artistInfo: ArtistInfo!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupBindings()
        
        setupCollectionViewDelegates()
        
        setupUIHeader()
        
        print("---ArtistId:\(coordinator?.artistInfo.id ?? "")")
        self.viewModel.viewDidLoad()
    }
    
    private func setupBindings() {
        
        self.viewModel.showAlbums = { [weak self] in
            guard let self = self else { return }
            self.albumsCollectionView.reloadData()
        }
    }
    
    private func setupCollectionViewDelegates() {
        
        self.albumsCollectionView.dataSource = self
    }
    
    private func setupUIHeader() {
        
        self.artistLabel.text = self.coordinator?.artistInfo.name
        print("---ArtistName:\(coordinator?.artistInfo.name ?? "")")
        if let pngData = coordinator?.artistInfo.image {
            let artistImage = UIImage(data: pngData)
            self.artistImageView.image = artistImage
        }
    }
    
    @IBAction func onDateRangeClicked(_ sender: UIButton) {
        
        // TODO: Use MVVM-C to handle this new module for picking the start and end dates.
        
        let vc = DatePickerViewController.instantiate()
        //vc.coordinator = self
        
        // Setup the view model
        //viewModel.coordinatorDelegate = self
        //vc.viewModel = viewModel
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.navigationController?.present(vc, animated: true, completion: {
            print("Ended VC")
        })
    }
}

extension DetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as? AlbumsCollectionViewCell {
            let albumItem: AlbumModel = viewModel.albums[indexPath.row]
            cell.render(album: albumItem, hasToRenderFromDB: !viewModel.isConnectionOn())
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
