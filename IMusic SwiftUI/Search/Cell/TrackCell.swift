//
//  TrackCell.swift
//  IMusic SwiftUI
//
//  Created by Миронов Влад on 14.09.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit
import SDWebImage
protocol TrackCellViewModel {
    var iconUrlString: String? {get}
    var trackName: String {get}
    var artistName: String {get}
    var collectionName: String {get}

}
class TrackCell: UITableViewCell {
    static let reuseID = "trackCell"
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var addFavouriteTrackButton: UIButton!
    
    var cell: SearchViewModel.Cell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackImageView.image = nil
    }
    
    @IBAction func addTrackPressed(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        
        guard let cell = cell else {return}
        
        var listOfTracks = defaults.savedTracks()
        listOfTracks.append(cell)
        addFavouriteTrackButton.isHidden = true
        
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks, requiringSecureCoding: false) {
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
        
//        if let savedTrack = defaults.object(forKey: "tracks") as? Data {
//            if let decodedTracks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTrack) as? [SearchViewModel.Cell] {
//                decodedTracks.map { (track)  in
//                    print(track.collectionName)
//                }
//            }
//        }
    }
    
    func set(viewModel: SearchViewModel.Cell){
        self.cell = viewModel

        let savedTracks = UserDefaults.standard.savedTracks()
        let hasFavourite = savedTracks.firstIndex(where: {
            $0.trackName == self.cell?.trackName && $0.artistName == self.cell?.artistName
        }) != nil
        
        if hasFavourite {
            addFavouriteTrackButton.isHidden = true
        } else {
            addFavouriteTrackButton.isHidden = false
        }
        
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        if let imageUrlString = viewModel.iconUrlString, let image = URL(string: imageUrlString) {
            trackImageView.sd_setImage(with: image)
        } else {
            trackImageView.image = #imageLiteral(resourceName: "ios10-apple-music-library-5nav-icon")
        }
    }
}
