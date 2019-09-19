//
//  userDefaults + extension.swift
//  IMusic SwiftUI
//
//  Created by Миронов Влад on 19.09.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import Foundation

extension UserDefaults {
    static let favouriteTrackKey = "favouriteTrackKey"
    
    func savedTracks() -> [SearchViewModel.Cell] {
        let defaults = UserDefaults.standard
        
        guard let savedTracks = defaults.object(forKey: UserDefaults.favouriteTrackKey) as? Data else {return []}
        guard let decodedTracks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTracks) as? [SearchViewModel.Cell] else { return []}
        return decodedTracks
    }
}
