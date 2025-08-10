//
//  ArtistModel.swift
//  DonsNote-Street
//
//  Created by Don on 8/5/25.
//

import Foundation

struct ArtistDTO: Codable {
    
    let id: Int
    let artistName: String
    let artistInfo: String
    let artistImgURL: String
    let genre: String
    let youtubeURL: String
    let instarURL: String
    let soundURL: String
    let otherURL: String
    let buskingCount: Int
    let buskings: [BuskingDTO]
    
}

struct Artist {
    
    let id: Int
    let name: String
    let buskingCount: Int
    let genre: String
    let buskings: [Busking]
    
}

extension Artist {
    
    init(from dto: ArtistDTO) {
        
        self.id = dto.id
        self.name = dto.artistName
        self.buskingCount = dto.buskingCount
        self.genre = dto.genre
        self.buskings = dto.buskings.map { Busking(from: $0) }

    }
}
