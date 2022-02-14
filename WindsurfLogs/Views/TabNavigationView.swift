//
//  TabNavigationView.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 14/02/2022.
//

import SwiftUI

struct TabNavigationView: View {
    var body: some View {
        TabView {
            NavigationView {
                TracksListView()
            }
            .tabItem {
                Label("Tracks", systemImage: "list.bullet")
            }
            
            NavigationView {
                TracksListView()
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }
        }
    }
}

struct TabNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TabNavigationView()
    }
}
