//
//  Program.swift
//  Timer
//
//  Created by Jonathan Diehl on 11.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import Foundation

enum ProgramError: Error {
    case overtime
}

struct Program : Codable {
  
  enum Direction: String, Codable {
    case up = "up"
    case down = "down"
  }
  
  struct Step: Codable {
    var title: String
    var length: Int
  }
  
  enum IndexState {
    case step
    case pause
    case finished
  }
  
  struct Index {
    let time: Int
    let progress: Float
    let step: Int
    let stepTime: Int
    let stepProgress: Float
    let state: IndexState
  }

  // properties
  var title: String
  var theme: Tint.Theme
  var style: Tint.Style
  var direction: Direction
  var pause: Int
  var steps: [Step]

  // computed
  var totalLength: Int {
    pause * (steps.count - 1) + steps.reduce(0) { $0 + $1.length }
  }
  var tint: Tint {
    return Tint(theme: theme, style: style)
  }
  
  // designated initializer
  init(title: String, tint: Tint, steps: [Step], direction: Direction, pause: Int) {
    self.title = title
    self.theme = tint.theme
    self.style = tint.style
    self.steps = steps
    self.direction = direction
    self.pause = pause
  }
  
  // convenience init: use defaults
  init() {
    let tint = Tint(theme: .crimson, style: .automatic)
    let step = Program.Step(title: "1", length: 30)
    self.init(title: "New Timer", tint: tint, steps: [step], direction: .down, pause: 0)
  }
  
  // compute the index for a given time
  func indexFor(time: Int) -> Index {
    
    // return the finished index if the time is not less than the total length
    guard time < totalLength else { return finishedIndex() }
      
    // compute total progress (will be needed later
    let progress = Float(time) / Float(totalLength)
    
    // t is reduced by each step (time and pause) to determine the correct step
    var t = time
    for (i, step) in steps.enumerated() {
      
      // t is inside this step
      if t < step.length {
        let stepProgress = Float(t) / Float(step.length)
        return Index(time: time, progress: progress, step: i, stepTime: t, stepProgress: stepProgress, state: .step)
      }
      t -= step.length

      // do not check for pause on the last step
      if i >= steps.count - 1 { break }

      // t is inside the pause after the step
      if t < pause {
        let stepProgress = Float(t) / Float(pause)
        return Index(time: time, progress: progress, step: i, stepTime: t, stepProgress: stepProgress, state: .pause)
      }

      t -= pause
    }
    return finishedIndex()
  }
  
  // return the index for a step and stepTime
  func indexFor(step: Int, stepTime: Int) -> Index {
    var time = stepTime
    for i in 0..<step {
      time += steps[i].length + pause
    }
    return indexFor(time: time)
  }
  
  // MARK: - Private Methods
  
  // return the finished index
  private func finishedIndex() -> Index {
    return Index(time: totalLength, progress: 1, step: steps.count - 1, stepTime: steps.last!.length, stepProgress: 1, state: .finished)
  }
  
}
