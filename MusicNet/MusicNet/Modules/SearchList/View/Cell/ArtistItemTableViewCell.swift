//
//  ArtistItemTableViewCell.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 23/2/21.
//

import UIKit

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
    
    func render(artistItem: Artist) -> Void {

        artistNameLabel.text =  artistItem.name
        if let genres = artistItem.genres, genres.count > 0 {
            artistGenreLabel.text = genres[0]
        } else {
            artistGenreLabel.text = "genre_not_defined".localized
        }
        artistPopularityLabel.text = String(format: "Popularity: %d", artistItem.popularity ?? "")
        
        self.artistImageView.image = UIImage(named: "Artist")

        if let images = artistItem.images, images.count > 0,
           let urlImageStr = images[0].url {
            if let urlImage = URL(string: urlImageStr) {
                NetworkUtils.downloadImage(from: urlImage) { [weak self ](data, response, error) in
                    
                    guard let data = data, let _ = response, error == nil else { return }
                    guard let self = self else { return }
                    guard let image = UIImage(data: data) else { return }
                    let imagePng = image.pngData()
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
