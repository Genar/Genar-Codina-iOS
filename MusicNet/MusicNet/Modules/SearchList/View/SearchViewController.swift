//
//  SearchViewController.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 20/2/21.
//

import UIKit

class SearchViewController: UIViewController, Storyboarded {
    
    weak var coordinator: SearchProtocol?

    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    @IBAction func showDetail(_ sender: Any) {
        
        let detailIdx: Int = 1
        coordinator?.showDetail(itemIdx: detailIdx)
    }
}
