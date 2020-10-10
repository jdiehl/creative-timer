//
//  TimerProgramView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 27.09.20.
//

import SwiftUI

struct TimerProgramView: View {
  @EnvironmentObject private var state: TimerState

  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      HStack {
        Text(String.time(state.index.time))
        Spacer()
        Text("-" + String.time(state.program.totalLength - state.index.time))
      }
      
      GeometryReader { geometry in
        ProgramView(program: state.program, index: state.index)
          .gesture(dragGesture(geometry: geometry))
      }
      .frame(height: 40)
    }
  }

  private func dragGesture(geometry: GeometryProxy) -> some Gesture {
    return DragGesture(minimumDistance: 0)
      .onChanged { value in
        let progress = Double((value.location.x - 20) / (geometry.size.width - 40))
        let index = ProgramIndex.at(program: state.program, progress: progress)
        state.index = ProgramIndex.at(program: state.program, step: index.step, stepTime: 0)
      }
  }
}

struct TimerProgramView_Previews: PreviewProvider {
  static var previews: some View {
    TimerProgramView()
      .previewLayout(.fixed(width: 375, height: 60 ))
      .environmentObject(TimerState.mock())
  }
}
