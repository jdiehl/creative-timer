//
//  FlashView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 10.10.20.
//

import SwiftUI
import Combine

struct FlashView: View {
  @ObservedObject var timer: TimerState
  var duration = 0.15
  
  @State private var opacity = 0.0
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    Color.foreground(appearance: timer.appearance)
      .opacity(opacity)
      .ignoresSafeArea()
      .onAppear { onAppear() }
  }
  
  private func onAppear() {
    cancellable = timer.$index.sink { index in
      guard timer.running else { return }
      if index.state == .finished { flash(count: 4) }
      else if timer.index.step != index.step && index.stepTime == 0 { flash() }
    }
  }
  
  private func flash(count: Int = 1) {
    for i in 0..<count {
      let time = DispatchTime.now() + Double(i) * duration
      DispatchQueue.main.asyncAfter(deadline: time) {
        self.opacity = 1
      }
      DispatchQueue.main.asyncAfter(deadline: time + duration / 10) {
        withAnimation(.easeIn(duration: duration * 8 / 10)) { self.opacity = 0 }
      }
    }
  }
}

struct FlashView_Previews: PreviewProvider {
  static var previews: some View {
    FlashView(timer: TimerState.mock())
      .environmentObject(AppState.mock())
  }
}
