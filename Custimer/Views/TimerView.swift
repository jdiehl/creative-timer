//
//  TimerView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 27.09.20.
//

import SwiftUI

struct TimerView: View {
  @EnvironmentObject private var state: TimerState
  @State private var flashing = false
  
  var body: some View {
    ZStack {
      backgroundColor
        .ignoresSafeArea()
        .animation(.easeOut)

      VStack {
        TimerHeaderView()
          .padding()
        
        Spacer()
                                                         
        TimerProgressView()
          .frame(maxWidth: 600)
          .padding()
        
        Spacer()
        
        TimerProgramView()
          .padding()
        
        Spacer()
        
        TimerControlsView()
          .padding()
      }
    }
  }
  
  var backgroundColor: Color {
    state.index.state == .finished ? Color.foreground(appearance: state.program.appearance) : Color.background(appearance: state.program.appearance)
  }
}

struct TimerView_Previews: PreviewProvider {
  static var previews: some View {
    TimerView()
      .environmentObject(TimerState.mock())
  }
}
