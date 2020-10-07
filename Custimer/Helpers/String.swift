//
//  String.swift
//  Custimer
//
//  Created by Jonathan Diehl on 27.09.20.
//

import Foundation

extension String {
  static func time(_ time: Int) -> String {
    let minutes = time / 60
    let seconds = time - minutes * 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
}
