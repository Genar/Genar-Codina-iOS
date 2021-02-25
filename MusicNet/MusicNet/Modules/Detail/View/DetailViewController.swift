//
//  DetailViewController.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 20/2/21.
//

import UIKit
import MobileCoreServices

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
        
        self.albumsCollectionView.dragDelegate = self
        self.albumsCollectionView.dropDelegate = self
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
            if let albumItem: AlbumItem = viewModel.albums?[indexPath.row] {
                cell.render(album: albumItem)
                return cell
            } else {
                return UICollectionViewCell()
            }
        } else {
            return UICollectionViewCell()
        }
    }
}

extension DetailViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        let albumId = viewModel.getAlbumItem(at: indexPath.row)?.id
        guard let data = albumId?.data(using: .utf8) else { return [] }
        let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)

        return [UIDragItem(itemProvider: itemProvider)]
    }
    

    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        let destinationIndexPath: IndexPath

        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = albumsCollectionView.numberOfSections - 1
            let row = albumsCollectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        // attempt to load strings from the drop coordinator
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            // convert the item provider array to a string array or bail out
            guard let strings = items as? [String] else { return }

            // create an empty array to track rows we've copied
            var indexPaths = [IndexPath]()

            // loop over all the strings we received
            for (index, string) in strings.enumerated() {
                // create an index path for this new row, moving it down depending on how many we've already inserted
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                
                viewModel.insert(string, at: indexPath.row)

                // keep track of this new row
                indexPaths.append(indexPath)
            }

            // insert them all into the table view at once
            self.albumsCollectionView.insertItems(at: indexPaths)
        }
    }
}


















