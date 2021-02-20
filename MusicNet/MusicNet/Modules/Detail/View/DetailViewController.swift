//
//  DetailViewController.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 20/2/21.
//

import UIKit

class DetailViewController: UIViewController, Storyboarded {
    
    weak var coordinator: DetailProtocol?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(coordinator?.detailIdx ?? 0)
    }
}
