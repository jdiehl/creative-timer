//
//  TimerView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 27.09.20.
//

import SwiftUI

struct TimerView: View {
  @EnvironmentObject private var state: AppState
  
  var body: some View {
    ZStack {
      Color.background(appearance: state.appearance)
        .ignoresSafeArea()

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
