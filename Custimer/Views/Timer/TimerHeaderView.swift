//
//  TimerHeaderView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 27.09.20.
//

import SwiftUI

struct TimerHeaderView: View {
  @EnvironmentObject private var state: AppState

  var stepTitle: String {
    if state.index.state == .pause {
      let next = state.program.steps[state.index.step + 1]
      return "Next: \(next.title)"
    } else {
      return state.step!.title
    }
  }
  
  var programTitle: String {
    return state.program.title
  }

  var body: some View {
    VStack {
      Text(stepTitle)
        .lineLimit(1)
        .font(.title)
        .foregroundColor(Color.foreground(appearance: state.appearance))
        .padding(.bottom, 4)
      
      Text(programTitle)
        .lineLimit(1)
        .font(.subheadline)
        .foregroundColor(Color.foreground(appearance: state.appearance))
    }
  }
  
}

struct TimerHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    TimerHeaderView()
      .previewLayout(.fixed(width: 375, height: 100 ))
      .environmentObject(AppState.mock())
  }
}
