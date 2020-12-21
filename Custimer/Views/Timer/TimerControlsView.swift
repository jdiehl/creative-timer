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
      IconButton(systemName: "backward.end.fill") { state.reset() }

      Spacer()

      if state.running {
        IconButton(systemName: "pause.fill") { state.stop() }
      } else {
        IconButton(systemName: "play.fill") { state.start() }
      }
      
      Spacer()

      IconButton(systemName: "eject.fill") {
        state.stop()
        state.showPrograms = true
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
