//
//  TabView.swift
//  DonsNote-Street
//
//  Created by Don on 8/5/25.
//

import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        
        TabView {

            UserPageView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("User Page")
                }
            
            MapView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Map")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
    }
}

#Preview {
    MainTabView()
}
