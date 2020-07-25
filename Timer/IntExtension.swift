//
//  IntExtension.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 25.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import Foundation

extension Int {

  func toTimeString() -> String {
    let minutes = self / 60
    let seconds = self - minutes * 60
    return String(format: "%02d:%02d", minutes, seconds)
  }

}
