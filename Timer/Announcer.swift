//
//  Announcer.swift
//  Timer
//
//  Created by Jonathan Diehl on 21.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import Foundation
import AVFoundation

class Announcer {
  static let shared = Announcer()
  
  lazy var synthesizer = AVSpeechSynthesizer()
  
  func announce(step: Program.Step) {
//    synthesizer.stopSpeaking(at: .immediate)
//    let speech = AVSpeechUtterance(string: step.title)
//    speech.voice = AVSpeechSynthesisVoice(language: "de")
//    synthesizer.speak(speech)
  }
}
