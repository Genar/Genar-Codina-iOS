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

//    @IBOutlet weak var userName: BoundTextField!
    
//    var user = User(name: Observable("Genar Codina"))
    
    var viewModel: SearchListViewModelProtocol!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupBindings()
        
        setupTableViewDelegates()
        
        setupSearchBar()
        
//        userName.bind(to: user.name)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.user.name.value = "Bon Minyo"
//        }
        
        if let coordinator = self.coordinator {
            coordinator.showSuitableView()
        }
    }
    
    private func setupBindings(){
        
        self.viewModel.showArtists = { [weak self] (artistsEntity) in
            guard let self = self else { return }
            self.viewModel.artistEntity = artistsEntity
            print(artistsEntity)
            self.tableView.reloadData()
        }
    }
    
    private func setupTableViewDelegates() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func setupSearchBar() {
        
        let searchPlaceholderText = "artist_items_search_placeholder"//.localized()
        
        self.searchBar.placeholder = searchPlaceholderText
        
        self.searchBar.delegate = self
    }
    
//    @IBAction func showDetail(_ sender: Any) {
//
//        let detailIdx: Int = 1
//        coordinator?.showDetail(itemIdx: detailIdx)
//    }
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "cellArtist") {
//            cell.textLabel?.text = self.viewModel.getArtistName(at: indexPath.row)
//        return cell
//        } else {
//            return UITableViewCell()
//        }
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cellArtist", for: indexPath) as? ArtistItemTableViewCell {
            if let artistItem: Artist = viewModel.artistEntity?.artists?.items?[indexPath.row] {
                cell.render(artistItem: artistItem)
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.viewModel.didTapOnArtist(of: indexPath.row)
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
        
        if var inputText: String = searchBar.text {
            let isTextEmpty: Bool = inputText.count == 0
            let isTextAllWhiteSpaces: Bool = inputText.trimmingCharacters(in: CharacterSet.whitespaces).count == 0
            if ( !isTextEmpty || !isTextAllWhiteSpaces) {
                inputText = inputText.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
                self.view.endEditing(true)
                viewModel?.getArtists(withUsername: inputText)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        tableView.reloadData()
    }
}
