//
//  FlashViewController.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 22.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit
import AVFoundation

class AnnouncerViewController: UIViewController {
  
  private let runner = ProgramRunner.shared
  private lazy var synthesizer = AVSpeechSynthesizer()
  
  private var language: String { "en" }

  // MARK: - UIViewController
  
  override func loadView() {
    view = UIView()
    view.alpha = 0
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    runner.on(.programChanged) { self.updateColor() }
    runner.on(.started) { self.onStart() }
    runner.on(.stopped) { self.onStop() }
    runner.on(.stepChanged) { self.onStepChange() }
    runner.on(.finished) { self.onFinished() }
    updateColor()
  }
  
  // MARK: - Private Methods

  private func updateColor() {
    view.backgroundColor = runner.program.tint.foregroundColor
  }

  private func onStart() {
    UIApplication.shared.isIdleTimerDisabled = true
  }
  
  private func onStop() {
    UIApplication.shared.isIdleTimerDisabled = false
  }
  
  private func onStepChange() {
    guard runner.running else { return }
    flash()
    announce(runner.stepTitle)
  }
  
  private func onFinished() {
    flash(times: 7) {
      UIApplication.shared.isIdleTimerDisabled = false
    }
    announce("All done")
  }
  
  private func announce(_ string: String) {
    synthesizer.stopSpeaking(at: .immediate)
    let speech = AVSpeechUtterance(string: string)
    speech.voice = AVSpeechSynthesisVoice(language: language)
    synthesizer.speak(speech)
  }

  private func cancel() {
    view.layer.removeAllAnimations()
    view.alpha = 0
  }
  
  private func flash(times: Int = 1, then: (() -> Void)? = nil) {
    guard times > 0 else { return }
    self.view.alpha = 1
    if times == 1 {
      UIView.animate(withDuration: 0.3, animations: {
        self.view.alpha = 0
      }) { success in then?() }
    } else {
      UIView.animate(withDuration: 0.1, animations: {
        self.view.alpha = 0.5
      }) { success in self.flash(times: times - 1, then: then) }
    }
  }
  
}
