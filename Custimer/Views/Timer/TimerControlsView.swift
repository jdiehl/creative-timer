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
      IconButton(systemName: "backward.end.fill") { timer.reset() }

      Spacer()

      if timer.running {
        IconButton(systemName: "pause.fill") { timer.stop() }
      } else {
        IconButton(systemName: "play.fill") { timer.start() }
      }
      
      Spacer()

      IconButton(systemName: "eject.fill") {
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
