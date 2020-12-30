//
//  SleepView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 08.10.20.
//

import SwiftUI

struct BreathingIconView: View {
  let systemName = "zzz"
  @State private var opacity = 1.0

  var body: some View {
    Image(systemName: systemName)
      .opacity(opacity)
      .onAppear {
        withAnimation(Animation.easeInOut(duration: 1).repeatForever()) {
          opacity = 0.7
        }
      }
  }
}

struct BreathingIconView_Previews: PreviewProvider {
  static var previews: some View {
    BreathingIconView()
  }
}
