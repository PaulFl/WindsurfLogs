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
                MapListView(mapRegion: sampleCoordinateRegion)
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }
            
            NavigationView {
                OverallStatsView()
            }
            .tabItem {
                Label("Stats", systemImage: "number")
            }
        }
    }
}

struct TabNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TabNavigationView()
    }
}
