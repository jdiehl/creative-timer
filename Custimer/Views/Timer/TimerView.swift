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
          .padding(.horizontal)
        
        Spacer()
        
        TimerProgramView(timer: state.timer)
          .padding([.leading, .top, .trailing])

        Spacer()
        
        TimerControlsView(timer: state.timer)
          .padding()
      }

      FlashView(timer: state.timer)
    }
  }
}

struct TimerView_Previews: PreviewProvider {
  static var previews: some View {
    TimerView()
      .environmentObject(AppState.mock())
    TimerView()
      .environmentObject(AppState.mock())
      .previewLayout(.fixed(width: 2436 / 3.0, height: 1125 / 3.0))

  }
}
