//
//  DetailViewController.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 20/2/21.
//

import UIKit

class DetailViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var albumsSearchBar: UISearchBar!
    
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    
    weak var coordinator: DetailProtocol?
    
    var viewModel: DetailListViewModelProtocol!
    
    var artistId: String!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupBindings()
        
        setupSearchBar()
        
        setupCollectionViewDelegates()
        
        print("---ArtistId:\(coordinator?.artistId ?? "")")
        self.viewModel.viewDidLoad()
    }
    
    private func setupBindings() {
        
        self.viewModel.showAlbums = { [weak self] in
            guard let self = self else { return }
            self.albumsCollectionView.reloadData()
        }
    }
    
    private func setupSearchBar() {
        
        let albumNameText: String = "album_items_name".localized
        let albumPublicationDateText: String = "album_items_publication_date".localized
        let searchPlaceholderText = "album_items_search_placeholder".localized()
        
        self.albumsSearchBar.scopeButtonTitles = [albumNameText, albumPublicationDateText]
        self.albumsSearchBar.placeholder = searchPlaceholderText
        
        self.albumsSearchBar.delegate = self
    }
    
    private func setupCollectionViewDelegates() {
        
        self.albumsCollectionView.delegate = self
        self.albumsCollectionView.dataSource = self
    }
}

extension DetailViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            self.view.endEditing(true)
            self.artistId = ""
            self.albumsCollectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if var inputText: String = searchBar.text {
            let isTextEmpty: Bool = inputText.count == 0
            let isTextAllWhiteSpaces: Bool = inputText.trimmingCharacters(in: CharacterSet.whitespaces).count == 0
                if ( !isTextEmpty || !isTextAllWhiteSpaces) {
                    inputText = inputText.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
                    self.view.endEditing(true)
                    
                    viewModel?.viewDidLoad()
                }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        //self.sortItems()
        //self.albumsCollectionView.reloadData()
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
