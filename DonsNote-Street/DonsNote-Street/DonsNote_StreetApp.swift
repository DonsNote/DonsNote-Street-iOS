//
//  DonsNote_StreetApp.swift
//  DonsNote-Street
//
//  Created by Don on 7/30/25.
//

import SwiftUI

@main
struct DonsNote_StreetApp: App {
    
    @AppStorage("isLogin") var isLogin: Bool = false
    
    var body: some Scene {
        
        WindowGroup {
            
            if isLogin {
                UserPageView()
            }
            
            else {
                LoginMethodSelectionView()
            }
        }
    }
}
