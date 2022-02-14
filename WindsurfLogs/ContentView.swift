//
//  ContentView.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 11/02/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TrackDetailsView(track: sampleTrack1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
