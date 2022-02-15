//
//  ContentView.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 11/02/2022.
//

import SwiftUI

struct ContentView: View {
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
#endif
    
    var body: some View {
#if os(iOS)
        if horizontalSizeClass == .compact {
            TabNavigationView()
        } else {
            SidebarNavigationView()
        }
#else
        SidebarNavigationView()
#endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
