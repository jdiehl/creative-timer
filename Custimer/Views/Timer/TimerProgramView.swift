//
//  TimerProgramView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 27.09.20.
//

import SwiftUI

struct TimerProgramView: View {
  @ObservedObject var timer: TimerState
  @State private var wasRunning: Bool?

  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      HStack {
        Text(String.time(timer.index.time))
          .foregroundColor(Color.foreground(appearance: timer.appearance))
        Spacer()
        Text("-" + String.time(timer.program.totalLength - timer.index.time))
          .foregroundColor(Color.foreground(appearance: timer.appearance))
      }
      
      GeometryReader { geometry in
        ProgramView(program: timer.program, index: timer.index)
          .gesture(dragGesture(geometry: geometry))
      }
      .frame(height: 40)
    }
  }

  private func dragGesture(geometry: GeometryProxy) -> some Gesture {
    return DragGesture(minimumDistance: 0)
      .onChanged { value in
        if wasRunning == nil {
          wasRunning = timer.running
          timer.stop()
        }
        let progress = Double((value.location.x - 20) / (geometry.size.width - 40))
        let index = ProgramIndex.at(program: timer.program, progress: progress)
        timer.set(index: ProgramIndex.at(program: timer.program, step: index.step, stepTime: 0))
      }
      .onEnded { _ in
        if wasRunning == true { timer.start() }
        wasRunning = nil
      }
  }
}

struct TimerProgramView_Previews: PreviewProvider {
  static var previews: some View {
    TimerProgramView(timer: TimerState.mock())
      .previewLayout(.fixed(width: 375, height: 60 ))
      .environmentObject(AppState.mock())
  }
}
