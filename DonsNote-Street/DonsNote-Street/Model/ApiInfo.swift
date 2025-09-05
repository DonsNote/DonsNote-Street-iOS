//
//  ApiInfo.swift
//  DonsNote-Street
//
//  Created by Don on 8/2/25.
//

import Foundation

struct ApiInfo {
    
    static var baseUrl: String {
        #if DEBUG
        return "http://localhost:5000"
        #else
        return "https://api.donsnote.com"
        #endif
    }
    
    enum Environment {
        case development
        case production
        
        static var current: Environment {
            #if DEBUG
            return .development
            #else
            return .production
            #endif
        }
    }
}
