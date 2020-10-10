//
//  TimerProgressView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 27.09.20.
//

import SwiftUI

struct TimerProgressView: View {
  @EnvironmentObject private var state: TimerState
  @State private var wasRunning: Bool?
  @State private var prevProgress: Double?
  
  var body: some View {
    GeometryReader { geometry in
      let width = max(min(geometry.size.width / 10, 20), 5)
      ZStack {
        ProgressView(progress: state.index.stepProgress, width: width, foregroundColor: Color.foreground(appearance: state.appearance), backgroundColor: Color.gray(appearance: state.appearance))

        Text(String.time(state.index.stepTime))
          .font(.system(size: 100, weight: .thin))
          .lineLimit(1)
          .minimumScaleFactor(0.01)
          .foregroundColor(Color.foreground(appearance: state.appearance))
          .padding(width * 1.5)
        
        if state.index.state == .pause {
          SleepView()
            .font(.system(size: width * 2, weight: .medium))
            .foregroundColor(Color.foreground(appearance: state.appearance))
            .position(x: geometry.size.width / 2, y: geometry.size.height / 4)
        }
      }
      .gesture(dragGesture(geometry: geometry))
    }
    .aspectRatio(1, contentMode: .fit)
  }
  
  private func dragGesture(geometry: GeometryProxy) -> some Gesture {
    return DragGesture(minimumDistance: 0)
      .onChanged { value in
        if wasRunning == nil {
          wasRunning = state.running
          state.stop()
        }
        let stepProgress = geometry.size.center.progress(target: value.location)
        let time = stepTime(for: stepProgress)
        state.index = ProgramIndex.at(program: state.program, step: state.index.step, stepTime: time)
      }
      .onEnded { _ in
        if wasRunning == true { state.start() }
        wasRunning = nil
        prevProgress = nil
      }
  }
  
  private func stepTime(for progress: Double) -> Int {
    // adjust progress to stick to the edges
    var adjustedProgress = progress
    if prevProgress != nil {
      if adjustedProgress > 0.9 && prevProgress! < 0.1 { adjustedProgress = 0 }
      else if adjustedProgress < 0.1 && prevProgress! > 0.9 { adjustedProgress = 1 }
    }
    prevProgress = adjustedProgress
    
    // compute step time for progress
    if state.index.state == .pause {
      return state.step.length + min(Int(Double(state.program.pause) * adjustedProgress), state.program.pause - 1)
    } else {
      return min(Int(Double(state.step.length) * adjustedProgress), state.step.length - 1)
    }
  }
}

struct TimerProgressView_Previews: PreviewProvider {
  static var previews: some View {
    Group() {
      TimerProgressView()
        .previewLayout(.fixed(width: 50, height: 50))
      TimerProgressView()
        .previewLayout(.fixed(width: 100.0, height: 100.0))
      TimerProgressView()
        .previewLayout(.fixed(width: 300, height: 300.0))
    }.environmentObject(TimerState.mock())
  }
}
