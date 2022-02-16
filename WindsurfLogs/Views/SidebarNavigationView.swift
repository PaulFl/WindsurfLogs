//
//  SidebarNavigationView.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 15/02/2022.
//

import SwiftUI

struct SidebarNavigationView: View {
    var body: some View {
        NavigationView {
            sidebarList
            Text("Tracks")
                .foregroundColor(.secondary)
            Text("No track selected")
                .foregroundColor(.secondary)
        }
    }
    
    var sidebarList: some View {
        List {
            Section("Tracks") {
                NavigationLink(destination: TracksListView()) {
                    Label("List", systemImage: "list.bullet")
                }
//                .isDetailLink(false)
                NavigationLink(destination: MapListView(mapRegion: sampleCoordinateRegion)) {
                    Label("Map", systemImage: "map")
                }
//                .isDetailLink(false)
            }
            Section("Stats") {
                NavigationLink(destination: OverallStatsView()) {
                    Label("Overall", systemImage: "chart.xyaxis.line")
                }
                .isDetailLink(false)
            }
        }
    }
}

extension UISplitViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        if style == .tripleColumn {
            preferredSplitBehavior = .automatic
//        preferredPrimaryColumnWidthFraction = 0.5
//        preferredSupplementaryColumnWidthFraction = 0.5
        preferredDisplayMode = .twoDisplaceSecondary
        }
    }
}

struct SidebarNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarNavigationView()
    }
}
