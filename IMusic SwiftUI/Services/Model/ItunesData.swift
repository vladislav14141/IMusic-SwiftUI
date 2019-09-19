// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let itunesData = try? newJSONDecoder().decode(ItunesData.self, from: jsonData)

import Foundation

// MARK: - ItunesData
struct ItunesData: Codable {
    let resultCount: Int
    let results: [Track]
}

// MARK: - Result
struct Track: Codable {
    let artistName: String
    let collectionCensoredName: String?
    let trackCensoredName: String
    let artworkUrl100: String?
    let primaryGenreName: String
    let previewUrl: String?
}


