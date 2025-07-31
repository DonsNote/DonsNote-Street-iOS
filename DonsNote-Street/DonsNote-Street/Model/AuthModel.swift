//
//  AuthModel.swift
//  DonsNote-Street
//
//  Created by Don on 7/31/25.
//

import Foundation

struct AuthModel: Codable {
    var provider:   String = "apple"
    var uid:        String = ""
    var authCode:   String = ""
    var userId:     String = ""
    var password:   String = ""
    var email:      String = ""
}
