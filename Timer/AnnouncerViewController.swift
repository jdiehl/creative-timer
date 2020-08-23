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
    view.backgroundColor = runner.program.tint.backgroundColor
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
    announce(runner.step.title)
  }
  
  private func onFinished() {
    flash(times: 5) { success in
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
  
  private func flash(times: Int = 1, then: ((Bool) -> Void)? = nil) {
    UIView.animateKeyframes(withDuration: TimeInterval(times) * 0.3, delay: 0, options: .calculationModeCubic, animations: {
      let length = 1 / Double(2 * times)
      for i in 0..<times {
        let t = Double(i) / Double(times)
        UIView.addKeyframe(withRelativeStartTime: t, relativeDuration: length) { self.view.alpha = 1 }
        UIView.addKeyframe(withRelativeStartTime: t + length, relativeDuration: length) { self.view.alpha = 0 }
      }
    }, completion: then)
  }
  
}
