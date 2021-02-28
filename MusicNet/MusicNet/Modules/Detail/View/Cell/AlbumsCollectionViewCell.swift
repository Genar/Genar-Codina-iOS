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
    
    func render(album: AlbumModel, hasToRenderFromDB: Bool) {
        
        albumLabel.text =  album.name
        
        self.albumImageView.image = UIImage(named: "Record")
        
        if hasToRenderFromDB {
            renderFromDB(albumItem: album)
        } else {
            renderFromNetwork(albumItem: album)
        }
    }
    
    private func renderFromDB(albumItem: AlbumModel) {
        
        if let imageData = albumItem.image {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard let image = UIImage(data: imageData) else { return }
                let imagePng = image.pngData()
                self.albumImageView.image = UIImage(data: imagePng!)
            }
        }
    }
    
    private func renderFromNetwork(albumItem: AlbumModel) {
        
        if let imageUrl = albumItem.imageUrl {
            NetworkUtils.downloadImage(from: imageUrl) { [weak self ](data, response, error) in
                guard let data = data, let _ = response, error == nil else { return }
                guard let self = self else { return }
                guard let image = UIImage(data: data) else { return }
                let imagePng = image.pngData()
                self.albumImageView.image = UIImage(data: imagePng!)
            }
        }
    }
}
