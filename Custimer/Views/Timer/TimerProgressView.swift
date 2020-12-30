//
//  TimerProgressView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 27.09.20.
//

import SwiftUI

struct TimerProgressView: View {
  @ObservedObject var timer: TimerState
  @State private var wasRunning: Bool?
  @State private var prevProgress: Double?
  
  var body: some View {
    GeometryReader { geometry in
      let width = max(min(geometry.size.width / 10, 20), 5)
      ZStack {
        ProgressView(progress: timer.index.stepProgress, label: String.time(timer.index.stepTime), width: width, appearance: timer.appearance)

        if timer.index.state == .pause {
          BreathingIconView()
            .font(.system(size: width * 2, weight: .medium))
            .foregroundColor(Color.foreground(appearance: timer.appearance))
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
          wasRunning = timer.running
          timer.stop()
        }
        let stepProgress = geometry.size.center.progress(target: value.location)
        let time = stepTime(for: stepProgress)
        timer.set(index: ProgramIndex.at(program: timer.program, step: timer.index.step, stepTime: time))
      }
      .onEnded { _ in
        if wasRunning == true { timer.start() }
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
    if timer.index.state == .pause {
      return timer.step!.length + min(Int(Double(timer.program.pause) * adjustedProgress), timer.program.pause - 1)
    } else {
      return min(Int(Double(timer.step!.length) * adjustedProgress), timer.step!.length - 1)
    }
  }
}

struct TimerProgressView_Previews: PreviewProvider {
  static var previews: some View {
    Group() {
      TimerProgressView(timer: TimerState.mock())
        .previewLayout(.fixed(width: 50, height: 50))
      TimerProgressView(timer: TimerState.mock())
        .previewLayout(.fixed(width: 100.0, height: 100.0))
      TimerProgressView(timer: TimerState.mock())
        .previewLayout(.fixed(width: 300, height: 300.0))
    }
  }
}
