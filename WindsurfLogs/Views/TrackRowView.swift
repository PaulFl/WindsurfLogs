//
//  TrackRowView.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 11/02/2022.
//

import SwiftUI

struct TrackRowView: View {
    let track: Track
    
    var body: some View {
        HStack {
            Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                .font(.largeTitle)
                .foregroundColor(.accentColor)
            VStack {
                Text(track.startDate.formatted())
                Text(track.endDate.formatted())
                Text(String(track.maxSpeed.speedKPH))
            }
        }
    }
}

struct TrackRowView_Previews: PreviewProvider {
    static var previews: some View {
        TrackRowView(track: sampleTrack1)
            .previewLayout(.sizeThatFits)
    }
}
