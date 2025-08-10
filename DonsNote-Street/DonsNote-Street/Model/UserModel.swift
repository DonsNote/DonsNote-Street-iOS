//
//  UserModel.swift
//  DonsNote-Street
//
//  Created by Don on 8/5/25.
//

import Foundation

struct UserDTO: Codable {
    
    let id: Int
    let name: String
    let info: String
    let userImgURL: String
    let email: String
    let createdAt: Date
    let artist: ArtistDTO?
    
}

struct User {
    
    let id: Int
    let name: String
    let info: String
    let imgURL: String
    let artist: Artist?
    
}

extension User {
    
    init(from dto: UserDTO) {
        self.id = dto.id
        self.name = dto.name
        self.info = dto.info
        self.imgURL = dto.userImgURL
        self.artist = dto.artist.map { Artist(from: $0) }
        
    }
}
