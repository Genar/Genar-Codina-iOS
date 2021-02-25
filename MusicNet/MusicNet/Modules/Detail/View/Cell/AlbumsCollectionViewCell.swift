//
//  AlbumsCollectionViewCell.swift
//  MusicNet
//
//  Created by Genar Codina Reverter on 25/2/21.
//

import UIKit

class AlbumsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumLabel: UILabel!
    
    @IBOutlet weak var albumImageView: UIImageView!
    
    func render(album: AlbumItem) {
        
        albumLabel.text =  album.name
        
        self.albumImageView.image = UIImage(named: "Record")

        if let images = album.images, images.count > 0,
           let urlImageStr = images[0].url {
            if let urlImage = URL(string: urlImageStr) {
                NetworkUtils.downloadImage(from: urlImage) { [weak self ](data, response, error) in
                    guard let data = data, let _ = response, error == nil else { return }
                    guard let self = self else { return }
                    self.albumImageView.image = UIImage(data: data)
                }
            }
        }
    }
}
