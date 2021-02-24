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
            artistGenreLabel.text = "genre_not_defined"
        }
        artistPopularityLabel.text = String(format: "Popularity: %d", artistItem.popularity ?? "")
        
        self.artistImageView.image = UIImage(named: "Artist") // To avoid problems on scroll

        if let images = artistItem.images, images.count == 3,
           let urlImageStr = images[2].url{
            if let urlImage = URL(string: urlImageStr) {
                downloadImage(from: urlImage)
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func downloadImage(from url: URL) {
        
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                if let self = self {
                    self.artistImageView.image = UIImage(data: data)
                    self.addParallaxToView(vw: self.artistImageView)
                }
            }
        }
    }
    
    private func addParallaxToView(vw: UIView) {
        
        let amount = 100

        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount

        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount

        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        vw.addMotionEffect(group)
    }
}
