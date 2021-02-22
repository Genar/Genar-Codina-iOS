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
    
    weak var coordinator: SearchProtocol?

    @IBOutlet weak var userName: BoundTextField!
    
    var user = User(name: Observable("Genar Codina"))
    
    var viewModel: SearchListViewModelProtocol!
    
    var artists: ArtistEntity?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupBindings()
        
//        userName.bind(to: user.name)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.user.name.value = "Bon Minyo"
//        }
        
        if let coordinator = self.coordinator {
            if !coordinator.isTokenOk() {
                coordinator.showSpotifyLogin()
            } else {
                viewModel?.getArtists(withUsername: "", completion: { (artistEntity) in
                    self.artists = artistEntity
                })
            }
        }
    }
    
    private func setupBindings(){
        
        self.viewModel.showArtists = { [weak self] (artists) in
            guard let self = self else { return }
            print(artists)
            //self.tableView.reloadData()
        }
    }
    
    @IBAction func showDetail(_ sender: Any) {
        
        let detailIdx: Int = 1
        coordinator?.showDetail(itemIdx: detailIdx)
    }
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = self.viewModel.getArtistName(at: indexPath.row)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.viewModel.didTapOnArtist(of: indexPath.row)
    }
}
