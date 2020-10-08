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
      let width = lineWidth(with: geometry)
      ZStack {
        ProgressView(progress: state.index.stepProgress, width: Double(width), foregroundColor: Color.foreground(appearance: state.appearance), backgroundColor: Color.gray(appearance: state.appearance))

        Text(String.time(state.index.stepTime))
          .font(.system(size: 100, weight: .thin))
          .lineLimit(1)
          .minimumScaleFactor(0.01)
          .foregroundColor(Color.foreground(appearance: state.appearance))
          .padding(width * 1.5)
      }
      .gesture(dragGesture(geometry: geometry))
    }
    .aspectRatio(1, contentMode: .fit)
  }
  
  private func lineWidth(with geometry: GeometryProxy) -> CGFloat {
    return max(min(geometry.size.width / 10, 20), 5)
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
    Group() {
      TimerProgressView()
        .previewLayout(.fixed(width: 50, height: 50))
      TimerProgressView()
        .previewLayout(.fixed(width: 100.0, height: 100.0))
      TimerProgressView()
        .previewLayout(.fixed(width: 375.0, height: 375.0))
    }.environmentObject(TimerState.mock())
  }
}