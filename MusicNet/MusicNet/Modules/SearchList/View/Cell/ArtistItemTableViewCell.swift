//
//  ArtistItemTableViewCell.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 23/2/21.
//

import UIKit
import CoreData

enum ArtistItemStrings {
    
    static let genreNotDefinedKey = "genre_not_defined"
    
    static let popularityKey = "popularity_key"
    
    static let artistKey = "Artist"
}

class ArtistItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistGenreLabel: UILabel!
    @IBOutlet weak var artistPopularityLabel: UILabel!
    
    var viewModel: SearchListViewModelProtocol?
    
    let kParallaxDisplacement: Int = 15
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func render(indexPath: IndexPath) -> Void {
        
        if let viewModel = self.viewModel {
            let artistItem: ArtistModel = viewModel.artists[indexPath.row]

            artistNameLabel.text =  artistItem.name
            if let genre = artistItem.genre {
                artistGenreLabel.text = genre
            } else {
                artistGenreLabel.text = ArtistItemStrings.genreNotDefinedKey.localized
            }
            artistPopularityLabel.text = ArtistItemStrings.popularityKey.localized + " " +
                String(format: "%d", artistItem.popularity)
            
            self.artistImageView.image = UIImage(named: ArtistItemStrings.artistKey)
            
            if  viewModel.isConnectionOn() {
                renderFromNetwork(indexPath: indexPath)
            } else {
                renderFromDB(artistItem: artistItem)
            }
            self.addParallaxToView(view: self.artistImageView, parallaxDisplacement: 5)
        }
    }
    
    private func renderFromDB(artistItem: ArtistModel) {
        
        if let imageData = artistItem.image {
            DispatchQueue.main.async {
                guard let image = UIImage(data: imageData) else { return }
                let imagePng = image.pngData()
                self.artistImageView.image = UIImage(data: imagePng!)
            }
        }
    }
    
    private func renderFromNetwork(indexPath: IndexPath) {
        
        if var viewModel = self.viewModel {
            let artistItem: ArtistModel = viewModel.artists[indexPath.row]
            if let imageUrl = artistItem.imageUrl {
                NetworkUtils.downloadImage(from: imageUrl) { [weak self ](data, response, error) in
                    guard let data = data, let _ = response, error == nil else { return }
                    guard let self = self else { return }
                    guard let image = UIImage(data: data) else { return }
                    let imagePng = image.pngData()
                    viewModel.artists[indexPath.row].image = imagePng
                    self.artistImageView.image = UIImage(data: imagePng!)
                }
            }
        }
    }
    
    private func addParallaxToView(view: UIView, parallaxDisplacement: Int) {

        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -parallaxDisplacement
        horizontal.maximumRelativeValue = parallaxDisplacement

        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -parallaxDisplacement
        vertical.maximumRelativeValue = parallaxDisplacement

        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        view.addMotionEffect(group)
    }
}
