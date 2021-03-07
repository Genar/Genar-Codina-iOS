//
//  SearchViewController.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 20/2/21.
//

import SafariServices
import UIKit

enum SearchViewStrings {
    
    static let artistItemsSearchPlaceholderKey = "artist_items_search_placeholder"
    
    static let cellArtistKey = "cellArtist"
}

class SearchViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var warningLabel: BoundLabel!
    
    @IBOutlet weak var actionButton: BoundButton!
    
    var viewModel: SearchListViewModelProtocol!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupBindings()
        
        setupTableViewDelegates()
        
        setupSearchBar()
        
        viewModel.showSuitableView()
        
        viewModel.viewDidLoad()
    }
    
    @IBAction func onButtonPressed(_ sender: UIButton) {
        
        self.viewModel.showSuitableView()
    }
    
    private func setupBindings() {
        
        self.viewModel.showArtists = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        
        self.warningLabel.bind(to: self.viewModel.warningsInfo.info)
        self.actionButton.bind(to: self.viewModel.warningsInfo.showLogin)
    }
    
    private func setupTableViewDelegates() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func setupSearchBar() {
        
        let searchPlaceholderText = SearchViewStrings.artistItemsSearchPlaceholderKey.localized
        
        self.searchBar.placeholder = searchPlaceholderText
        
        self.searchBar.delegate = self
    }
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewStrings.cellArtistKey, for: indexPath) as? ArtistItemTableViewCell {
            cell.viewModel = viewModel
            cell.render(indexPath: indexPath)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let artist = self.viewModel.artists[indexPath.row]
        let artistInfo = ArtistInfo(id: artist.id, name: artist.name, image: artist.image)
        viewModel.showDetail(artistInfo: artistInfo)
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
