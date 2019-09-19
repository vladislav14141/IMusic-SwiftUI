//
//  SMTime + Extension.swift
//  IMusic SwiftUI
//
//  Created by Миронов Влад on 15.09.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import Foundation
import AVKit
extension CMTime{
    func toDisplayString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else {return ""}
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeForString = String(format: "%02D:%02D", minutes, seconds)
        return timeForString
    }
}
