//
//  ArtistItemTableViewCell.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 23/2/21.
//

import UIKit
import CoreData

class ArtistItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistGenreLabel: UILabel!
    @IBOutlet weak var artistPopularityLabel: UILabel!
    
    let kParallaxDisplacement: Int = 15
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func render(artistItem: ArtistModel, hasToRenderFromDB: Bool) -> Void {

        artistNameLabel.text =  artistItem.name
        if let genre = artistItem.genre {
            artistGenreLabel.text = genre
        } else {
            artistGenreLabel.text = "genre_not_defined".localized
        }
        artistPopularityLabel.text = String(format: "Popularity: %d", artistItem.popularity)
        
        self.artistImageView.image = UIImage(named: "Artist")
        
        if hasToRenderFromDB {
            renderFromDB(artistItem: artistItem)
        } else {
            renderFromNetwork(artistItem: artistItem)
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
    
    private func renderFromNetwork(artistItem: ArtistModel) {
        
        if let imageUrl = artistItem.imageUrl {
            NetworkUtils.downloadImage(from: imageUrl) { [weak self ](data, response, error) in
                guard let data = data, let _ = response, error == nil else { return }
                guard let self = self else { return }
                guard let image = UIImage(data: data) else { return }
                let imagePng = image.pngData()
                self.artistImageView.image = UIImage(data: imagePng!)
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
