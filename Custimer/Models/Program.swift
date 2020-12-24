//
//  Program.swift
//  Timer
//
//  Created by Jonathan Diehl on 11.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import Foundation

struct Program : Codable, Identifiable {
  var id: String = UUID().uuidString
  var title: String = "New Timer"
  var appearance: Appearance = Appearance()
  var direction: Direction = .down
  var pause: Int = 0
  var steps: [Step] = [Program.Step()]
}

// MARK: - Types
extension Program {
  
  enum Direction: String, Codable {
    case up = "up"
    case down = "down"
  }
  
  struct Step: Codable, Hashable {
    var title: String = "1"
    var length: Int = 30
  }

}

// MARK: - Convenience Methods
extension Program {

  var totalLength: Int {
    pause * (steps.count - 1) + steps.reduce(0) { $0 + $1.length }
  }
  
  func step(at: ProgramIndex) -> Step {
    return steps[at.step]
  }

}
