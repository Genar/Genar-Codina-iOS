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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        userName.bind(to: user.name)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.user.name.value = "Bon Minyo"
//        }
        
        coordinator?.setAccessTokenIfNecessary()
        
        viewModel?.getArtists(withUsername: "Michael Jackson")
    }
    
    @IBAction func showDetail(_ sender: Any) {
        
        let detailIdx: Int = 1
        coordinator?.showDetail(itemIdx: detailIdx)
    }
}
