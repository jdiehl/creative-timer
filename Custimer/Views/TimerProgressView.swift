//
//  TimerProgressView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 27.09.20.
//

import SwiftUI

struct TimerProgressView: View {
  @EnvironmentObject private var state: TimerState
  
  private var wasRunning: Bool?
  private var prevStepProgress: Double?
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        ProgressView(progress: state.index.stepProgress, foregroundColor: Color.foreground(appearance: state.appearance), backgroundColor: Color.gray(appearance: state.appearance))

        Text(String.time(state.index.stepTime))
          .font(.system(size: 100, weight: .thin))
          .foregroundColor(Color.foreground(appearance: state.appearance))
      }
      .gesture(dragGesture(geometry: geometry))
    }
    .aspectRatio(1, contentMode: .fit)
  }
  
  private func dragGesture(geometry: GeometryProxy) -> some Gesture {
    return DragGesture(minimumDistance: 0)
      .onChanged { value in
        let stepProgress = geometry.size.center.progress(target: value.location)
        let stepTime = Int(Double(state.step.length) * stepProgress)
        state.index = ProgramIndex.at(program: state.program, step: state.index.step, stepTime: stepTime)
      }
  }
  
}

struct TimerProgressView_Previews: PreviewProvider {
  static var previews: some View {
    TimerProgressView()
      .previewLayout(.fixed(width: 375, height: 375 ))
      .environmentObject(TimerState.mock())
  }
}
