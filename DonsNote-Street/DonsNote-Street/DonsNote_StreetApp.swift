//
//  DonsNote_StreetApp.swift
//  DonsNote-Street
//
//  Created by Don on 7/30/25.
//

import SwiftUI

@main
struct DonsNote_StreetApp: App {
    
    let islogin: Bool = UserDefaults.standard.bool(forKey: "islogin")
    
    var body: some Scene {
        
        WindowGroup {
            
            if islogin {
                UserPageView()
            }
            
            else {
                LoginMethodSelectionView()
            }
        }
    }
}
