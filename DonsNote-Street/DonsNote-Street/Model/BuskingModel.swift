//
//  BuskingModel.swift
//  DonsNote-Street
//
//  Created by Don on 8/5/25.
//

import Foundation

struct BuskingDTO: Codable {
    
    let id: Int
    let buskingName: String
    let buskingInfo: String
    let startTime: String
    let endTime: String
    let latitude: Double
    let longitude: Double
    
}

struct Busking {
    
    let id: Int
    let name: String
    let timeRange: String
    let location: (Double, Double)
    
}

extension Busking {
    
    init(from dto: BuskingDTO) {
        
        self.id = dto.id
        self.name = dto.buskingName
        self.timeRange = "\(dto.startTime.prefix(10)) ~ \(dto.endTime.prefix(10))"
        self.location = (dto.latitude, dto.longitude)
        
    }
}
