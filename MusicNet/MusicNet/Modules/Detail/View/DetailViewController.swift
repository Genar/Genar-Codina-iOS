//
//  DetailViewController.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 20/2/21.
//

import UIKit

class DetailViewController: UIViewController, Storyboarded {
    
    weak var coordinator: DetailProtocol?
    
    var viewModel: DetailListViewModelProtocol!
    
    var artistId: String!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupBindings()
        
        print("---ArtistId:\(coordinator?.artistId ?? "")")
        self.viewModel.viewDidLoad()
    }
    
    private func setupBindings() {
        
        self.viewModel.showAlbums = { [weak self] (albumsEntity) in
            guard let self = self else { return }
            self.viewModel.albums = albumsEntity.items
            print(self.viewModel.albums)
            //self.tableView.reloadData()
        }
    }
}
