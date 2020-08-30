//
//  Program.swift
//  Timer
//
//  Created by Jonathan Diehl on 11.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ProgramError: Error {
    case overtime
}

struct Program {
  
  enum Direction: String {
    case up = "up"
    case down = "down"
  }
  
  enum IndexState {
    case step
    case pause
    case finished
  }
  
  struct Step {
    var title: String
    var length: Int
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
  var tint: Tint
  var steps: [Step]
  var direction: Direction
  var pause: Int

  // computed
  var totalLength: Int
  
  // designated initializer
  init(title: String, tint: Tint, steps: [Step], direction: Direction, pause: Int) {
    self.title = title
    self.tint = tint
    self.steps = steps
    self.direction = direction
    self.pause = pause
    totalLength = pause * (steps.count - 1) + steps.reduce(0) { $0 + $1.length }
  }
  
  // convenience init: use defaults
  init() {
    let tint = Tint(theme: .crimson, style: .automatic)
    let step = Program.Step(title: "1", length: 30)
    self.init(title: "New Timer", tint: tint, steps: [step], direction: .down, pause: 0)
  }
  
  // load from JSON
  init?(json: JSON) {
    guard let title = json["title"].string else { return nil }
    guard let tint = Tint(withString: json["tint"].string ?? "") else { return nil }
    guard let jsonSteps = json["steps"].array else { return nil }
    let direction = Direction(rawValue: json["direction"].string ?? "down") ?? .down
    let pause = json["pause"].int ?? 0
    let steps = jsonSteps.map { obj in Step(title: obj["title"].string ?? "", length: obj["length"].int ?? 30) }
    self.init(title: title, tint: tint, steps: steps, direction: direction, pause: pause)
  }
  
  // store to JSON
  func toJSON() -> JSON {
    var obj = JSON()
    obj["tint"].string = tint.toString()
    obj["title"].string = title
    obj["steps"].arrayObject = steps.map { ["title": $0.title, "length": $0.length] }
    obj["direction"].string = direction.rawValue
    obj["pause"].int = pause
    return obj
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
