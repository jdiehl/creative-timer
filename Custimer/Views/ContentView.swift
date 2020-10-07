//
//  ContentView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 23.09.20.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var state: TimerState

  var body: some View {
    TimerView()
      .sheet(isPresented: $state.showPrograms) {
        ProgramModal()
          .environmentObject(state)
      }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(TimerState.mock())
  }
}
