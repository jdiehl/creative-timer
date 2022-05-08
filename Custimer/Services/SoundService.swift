//
//  SoundService.swift
//  Custimer
//
//  Created by Jonathan Diehl on 26.12.20.
//

import UIKit
import Foundation
import AVFoundation

fileprivate func loadPlayer(sound: SoundService.Sound) -> AVAudioPlayer {
  let asset = NSDataAsset(name: sound.rawValue)!
  let player = try! AVAudioPlayer(data: asset.data, fileTypeHint: "m4a")
  return player
}

class SoundService: NSObject, AVAudioPlayerDelegate, AVSpeechSynthesizerDelegate {
  static let shared = SoundService()
  
  var soundEnabled = true
  var speechEnabled = true
  var isPlaying: Bool {
    if synth.isSpeaking { return true }
    for (_, player) in players {
      if player.isPlaying { return true }
    }
    return false
  }

  private let session = AVAudioSession.sharedInstance()
  private let synth = AVSpeechSynthesizer()
  private var onComplete: (() -> Void)? = nil
  private var active = false
  private var activeShouldBe: Bool? = nil

  enum Sound: String {
    case tick = "TickSound"
    case halftime = "HalftimeSound"
    case finish = "FinishSound"
  }
  
  private var players: [Sound: AVAudioPlayer] = [
    .tick: loadPlayer(sound: .tick),
    .halftime: loadPlayer(sound: .halftime),
    .finish: loadPlayer(sound: .finish)
  ]

  override init() {
    super.init()
    for (_, player) in players { player.delegate = self }
    synth.delegate = self
  }
  
  func setup() {
    try? session.setCategory(.ambient, options: [.duckOthers, .mixWithOthers, .interruptSpokenAudioAndMixWithOthers])
    try? session.setActive(false)
  }
  
  func set(active: Bool) {
    guard soundEnabled || speechEnabled else { return }
    
    // if we are playing, delay setting active until we are done
    guard !isPlaying else {
      activeShouldBe = active
      return
    }

    // ensure that a change happens
    guard self.active != active else { return }

    // setup sound session
    do {
      try session.setActive(active, options: .notifyOthersOnDeactivation)
      self.active = active
    } catch {
      // nothing
    }
    
    // prepare sounds
    if (active) {
      for (_, player) in self.players {
        player.prepareToPlay()
      }
    }
  }

  func play(sound: Sound, followedByText text: String?) {
    guard soundEnabled else {
      if let text = text {
        announce(text: text)
      }
      return
    }
    abort()
    if speechEnabled {
      if let text = text {
        self.onComplete = { self.announce(text: text) }
      }
    }
    let player = players[sound]!
    player.play()
  }
  
  func announce(text: String) {
    guard speechEnabled else { return }
    abort()
    let utterance = AVSpeechUtterance(string: text)
    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    synth.speak(utterance)
  }
    
  // MARK : - Private Methods
  
  private func abort() {
    if synth.isSpeaking { synth.stopSpeaking(at: .immediate) }
  }
  
  private func setActiveToShouldBe() {
    guard let activeShouldBe = activeShouldBe else { return }
    set(active: activeShouldBe)
    self.activeShouldBe = nil
  }
  
  // MARK: - AVAudioPlayerDelegate
  
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    if let onComplete = onComplete {
      onComplete()
      self.onComplete = nil
    } else {
      // only update active status if no additional sound is played
      setActiveToShouldBe()
    }
  }
  
  // MARK: - AVSpeechSynthesizerDelegate

  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    setActiveToShouldBe()
  }
  
}
