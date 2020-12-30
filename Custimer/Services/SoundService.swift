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
  player.prepareToPlay()
  return player
}

class SoundService: NSObject, AVAudioPlayerDelegate, AVSpeechSynthesizerDelegate {
  static let shared = SoundService()
  
  var soundEnabled = true
  var speechEnabled = true
  var isPlaying: Bool { return synth.isSpeaking || players[.tick]!.isPlaying || players[.finish]!.isPlaying }

  private let session = AVAudioSession.sharedInstance()
  private let synth = AVSpeechSynthesizer()
  private var onComplete: (() -> Void)? = nil
  private var active = false
  private var activeShouldBe: Bool? = nil

  enum Sound: String {
    case tick = "TickSound"
    case finish = "FinishSound"
  }
  
  private var players: [Sound: AVAudioPlayer] = [
    .tick: loadPlayer(sound: .tick),
    .finish: loadPlayer(sound: .finish)
  ]

  override init() {
    super.init()
    players[.tick]!.delegate = self
    players[.finish]!.delegate = self
    synth.delegate = self
  }
  
  func setup() {
    try? session.setCategory(.playback, options: [.duckOthers, .mixWithOthers])
    try? session.setActive(false)
  }
  
  func set(active: Bool?) {
    guard soundEnabled || speechEnabled else { return }
    guard let active = active else { return }
    guard self.active != active else { return }
    
    // ensure that no sound output is active
    if !active && isPlaying {
      activeShouldBe = active
      return
    }

    // disable sound session
    do {
      try session.setActive(active)
      self.active = active
      self.activeShouldBe = nil
    } catch {
      // nothing
    }
  }

  func play(sound: Sound, onComplete: (() -> Void)? = nil) {
    guard soundEnabled else {
      onComplete?()
      return
    }
    abort()
    self.onComplete = onComplete
    let player = players[sound]!
    player.play()
  }
  
  func announce(text: String) {
    guard speechEnabled else { return }
    abort()
    let utterance = AVSpeechUtterance(string: text)
    synth.speak(utterance)
  }
    
  // MARK : - Private Methods
  
  private func abort() {
    if synth.isSpeaking { synth.stopSpeaking(at: .immediate) }
  }
  
  // MARK: - AVAudioPlayerDelegate
  
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    set(active: activeShouldBe)
    onComplete?()
    onComplete = nil
  }
  
  // MARK: - AVSpeechSynthesizerDelegate

  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    set(active: activeShouldBe)
  }
  
}
