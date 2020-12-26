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

class SoundService {
  static let shared = SoundService()
  
  enum Sound: String {
    case tick = "TickSound"
    case finish = "FinishSound"
  }
  
  private var players: [Sound: AVAudioPlayer] = [
    .tick: loadPlayer(sound: .tick),
    .finish: loadPlayer(sound: .finish)
  ]
  
  func play(sound: Sound) {
    let player = players[sound]!
    player.play()
  }
}
