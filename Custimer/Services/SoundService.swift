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

class SoundService: NSObject, AVAudioPlayerDelegate {
  static let shared = SoundService()
  
  private let synth = AVSpeechSynthesizer()
  private var onComplete: (() -> Void)? = nil
  
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
  }
  
  func play(sound: Sound, onComplete: (() -> Void)? = nil) {
    self.onComplete = onComplete
    let player = players[sound]!
    player.play()
  }
  
  func announce(text: String) {
    let utterance = AVSpeechUtterance(string: text)
    synth.speak(utterance)
  }
  // MARK: - AVAudioPlayerDelegate
  
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    onComplete?()
    onComplete = nil
  }
  
}
