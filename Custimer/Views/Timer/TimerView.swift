//
//  TimerView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 27.09.20.
//

import SwiftUI

struct TimerView: View {
  @EnvironmentObject var state: AppState
  
  var body: some View {
    ZStack {
      Color.background(appearance: state.appearance)
        .ignoresSafeArea()

      VStack {
        TimerHeaderView(timer: state.timer)
          .padding()
        
        Spacer()
                                                         
        TimerProgressView(timer: state.timer)
          .frame(maxWidth: 600)
          .padding()
        
        Spacer()
        
        TimerProgramView(timer: state.timer)
          .padding()
        
        Spacer()
        
        TimerControlsView(timer: state.timer)
          .padding()
      }

      FlashView()
    }
  }
}

struct TimerView_Previews: PreviewProvider {
  static var previews: some View {
    TimerView()
      .environmentObject(AppState.mock())
  }
}
