//
//  ContentView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 23.09.20.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    TimerView()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(TimerState.mock())
  }
}
