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
    var title: String = ""
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
  
  mutating func addStep() {
    let length = steps.last?.length ?? 30
    let step = Step(title: "", length: length)
    steps.append(step)
  }

}

// MARK: - Sound Methods

extension Program {
  
  func sound(at: ProgramIndex) -> SoundService.Sound? {
    if at.stepTime == 0 { return .finish }
    if at.state == .finished { return .finish }
    if at.state != .pause {
      if at.stepTime > steps[at.step].length - 4 { return .tick }
    }
    return nil
  }
}
