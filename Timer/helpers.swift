//
//  helpers.swift
//  Timer
//
//  Created by Jonathan Diehl on 29.06.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import Foundation

func timeToComponents(_ time: Int) -> (Int, Int) {
  let minutes = time / 60
  let seconds = time - minutes * 60
  return (minutes, seconds)
}

func timeFromComponents(_ minutes: Int, seconds: Int) -> (Int) {
  return minutes * 60 + seconds
}

func formatTime(_ seconds: Int) -> String {
  if (seconds > 60) {
    let minutes = (seconds - 1) / 60 + 1
    return "\(minutes)'"
  }
  return "\(seconds)\""
}

enum PlayPauseState: String {
    case play = "PlayButton"
    case pause = "PauseButton"
}
