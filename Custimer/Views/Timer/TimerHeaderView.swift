//
//  TimerHeaderView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 27.09.20.
//

import SwiftUI

struct TimerHeaderView: View {
  @ObservedObject var timer: TimerState
  
  var stepTitle: String {
    if timer.index.state == .pause {
      let next = timer.program.steps[timer.index.step + 1]
      return next.title == "" ? "" : "Next: \(next.title)"
    } else {
      return timer.step!.title
    }
  }
  
  var programTitle: String {
    return timer.program.title
  }

  var body: some View {
    if stepTitle != "" {
      VStack {
        Text(stepTitle)
          .lineLimit(1)
          .font(.title)
          .foregroundColor(Color.foreground(appearance: timer.appearance))
          .padding(.bottom, 4)
        
        Text(programTitle)
          .lineLimit(1)
          .font(.subheadline)
          .foregroundColor(Color.foreground(appearance: timer.appearance))
      }
    } else {
      Text(programTitle)
        .lineLimit(1)
        .font(.title)
        .foregroundColor(Color.foreground(appearance: timer.appearance))
        .padding()
    }
  }
  
}

struct TimerHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    TimerHeaderView(timer: TimerState.mock())
      .previewLayout(.fixed(width: 375, height: 100 ))
  }
}
