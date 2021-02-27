//
//  SearchViewController.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 20/2/21.
//

import SafariServices
import UIKit

struct User {
    
    var name: Observable<String>
}

class SearchViewController: UIViewController, Storyboarded {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    weak var coordinator: SearchProtocol?
    
    var viewModel: SearchListViewModelProtocol!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupBindings()
        
        setupTableViewDelegates()
        
        setupSearchBar()
        
        if let coordinator = self.coordinator {
            coordinator.showSuitableView()
        }
    }
    
    private func setupBindings() {
        
        self.viewModel.showArtists = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    private func setupTableViewDelegates() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func setupSearchBar() {
        
        let searchPlaceholderText = "artist_items_search_placeholder".localized
        
        self.searchBar.placeholder = searchPlaceholderText
        
        self.searchBar.delegate = self
    }
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cellArtist", for: indexPath) as? ArtistItemTableViewCell {
            let artistItem: ArtistModel = viewModel.artists[indexPath.row]
            cell.render(artistItem: artistItem, hasToRenderFromDB: !viewModel.isConnectionOn())
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let artist = self.viewModel.artists[indexPath.row]
        let artistId = artist.id
        coordinator?.showDetail(artistId: artistId)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            self.view.endEditing(true)
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let inputText: String = searchBar.text {
            let isTextEmpty: Bool = inputText.count == 0
            let isTextAllWhiteSpaces: Bool = inputText.trimmingCharacters(in: CharacterSet.whitespaces).count == 0
            if ( !isTextEmpty || !isTextAllWhiteSpaces) {
                self.view.endEditing(true)
                viewModel?.getArtists(withUsername: inputText)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.viewModel.clear()
        self.view.endEditing(true)
    }
}
