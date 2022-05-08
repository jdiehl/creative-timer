//
//  TimerControlsView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 27.09.20.
//

import SwiftUI

struct TimerControlsView: View {
  @EnvironmentObject var state: AppState
  @ObservedObject var timer: TimerState
  
  var body: some View {
    HStack {
      ControlButton(systemName: "backward.end.fill", appearance: state.appearance) { timer.reset() }

      Spacer()

      if timer.running {
        ControlButton(systemName: "pause.fill", appearance: state.appearance) { timer.stop() }
      } else {
        ControlButton(systemName: "play.fill", appearance: state.appearance) { timer.start() }
      }
      
      Spacer()

      ControlButton(systemName: "eject.fill", appearance: state.appearance) {
        timer.stop()
        state.showPrograms = true
      }
    }
    .foregroundColor(Color.foreground(appearance: timer.appearance))
    .frame(width: 250)
}
}

struct TimerControlsView_Previews: PreviewProvider {
  static var previews: some View {
    TimerControlsView(timer: TimerState.mock())
      .previewLayout(.fixed(width: 375, height: 100 ))
      .environmentObject(AppState.mock())
  }
}
