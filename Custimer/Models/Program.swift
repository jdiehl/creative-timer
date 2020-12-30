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
  var halftime: Bool = false
  var sound: Bool = true
  var speech: Bool = true
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
  
  func shouldPrepareForSounds(at: ProgramIndex) -> Bool {
    if at.time <= 1 { return false }
    if at.stepTime <= 1 { return true }
    if at.state == .pause {
      return at.stepTime >= pause - 1
    } else if halftime {
      let half = steps[at.step].length / 2
      if at.stepTime >= half - 1 && at.stepTime <= half { return true }
    }
    return at.stepTime >= steps[at.step].length - 5
  }
  
  func sound(at: ProgramIndex) -> SoundService.Sound? {
    if at.stepTime == 0 { return .finish }
    if at.state == .finished { return .finish }
    if at.state != .pause {
      if at.stepTime > steps[at.step].length - 4 { return .tick }
      if halftime && at.stepTime == steps[at.step].length / 2 { return .halftime }
    }
    return nil
  }

  func announce(at: ProgramIndex) -> String? {
    guard at.stepTime == 0 else { return nil }
    if at.state == .pause { return "Next: \(self.steps[at.step + 1].title)" }
    return self.step(at: at).title
  }
}
