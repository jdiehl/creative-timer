//
//  FlashView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 10.10.20.
//

import SwiftUI
import Combine

struct FlashView: View {
  @EnvironmentObject var state: AppState
  var duration = 0.2
  
  @State private var opacity = 0.0
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    Color.foreground(appearance: state.appearance)
      .opacity(opacity)
      .ignoresSafeArea()
      .onAppear { onAppear() }
  }
  
  private func onAppear() {
    cancellable = state.$index.sink { index in
      guard state.running else { return }
      if index.state == .finished { flash(count: 5) }
      else if state.index.step != index.step && index.stepTime == 0 { flash() }
    }
  }
  
  private func flash(count: Int = 1) {
    for i in 0..<count {
      let time = DispatchTime.now() + Double(i) * duration
      DispatchQueue.main.asyncAfter(deadline: time) {
        withAnimation(.easeOut(duration: duration / 2)) { self.opacity = 1 }
      }
      DispatchQueue.main.asyncAfter(deadline: time + duration / 2) {
        withAnimation(.easeIn(duration: duration / 2)) { self.opacity = 0 }
      }
    }
  }
}

struct FlashView_Previews: PreviewProvider {
  static var previews: some View {
    FlashView()
      .environmentObject(AppState.mock())
  }
}
