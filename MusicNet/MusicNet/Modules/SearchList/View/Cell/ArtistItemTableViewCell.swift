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

        // Configure the view for the selected state
    }
    
    func render(artistItem: Artist) -> Void {

        artistNameLabel.text =  artistItem.name
        if let genres = artistItem.genres, genres.count > 0 {
            artistGenreLabel.text = genres[0]
        }
        artistPopularityLabel.text = String(format: "%d", artistItem.popularity ?? "")

        if let images = artistItem.images, images.count > 0,
           let urlImageStr = images[0].url{
            if let urlImage = URL(string: urlImageStr) {
                downloadImage(from: urlImage)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                if let self = self {
                    self.artistImageView.image = UIImage(data: data)
                }
            }
        }
    }
}
