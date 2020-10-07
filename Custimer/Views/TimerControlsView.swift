//
//  TimerControlsView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 27.09.20.
//

import SwiftUI

struct TimerControlsView: View {
  @EnvironmentObject private var state: TimerState
  
  var body: some View {
    HStack {
      Button(action: { state.reset() }) {
        Image(systemName: "backward.end.fill")
      }
      
      Spacer()

      if state.running {
        Button(action: { state.pause() }) {
          Image(systemName: "pause.fill")
        }
      } else {
        Button(action: { state.play() }) {
          Image(systemName: "play.fill")
        }
      }
      
      Spacer()

      Button(action: {
        state.pause()
        // TODO: open settings
      }) {
        Image(systemName: "eject.fill")
      }
    }
    .foregroundColor(Color.foreground(appearance: state.appearance))
    .frame(width: 250)
}
}

struct TimerControlsView_Previews: PreviewProvider {
  static var previews: some View {
    TimerControlsView()
      .previewLayout(.fixed(width: 375, height: 100 ))
      .environmentObject(TimerState.mock())
  }
}
