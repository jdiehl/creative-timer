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
    let finished: Bool
  }

  var title: String
  var tint: Tint
  var steps: [Step]
  
  var totalLength: Int { steps.reduce(0) { $0 + $1.length } }
  
  init(title: String, tint: Tint, steps: [Step]) {
    self.title = title
    self.tint = tint
    self.steps = steps
  }
  
  init() {
    let tint = Tint(theme: .crimson, style: .automatic)
    let step = Program.Step(title: "1", length: 30)
    self.init(title: "New Timer", tint: tint, steps: [step])
  }
  
  init?(json: JSON) {
    guard let title = json["title"].string else { return nil }
    guard let tint = Tint(withString: json["tint"].string ?? "") else { return nil }
    guard let jsonSteps = json["steps"].array else { return nil }
    let steps = jsonSteps.map { obj in Step(title: obj["title"].string ?? "", length: obj["length"].int ?? 30) }
    self.init(title: title, tint: tint, steps: steps)
  }
  
  func toJSON() -> JSON {
    var obj = JSON()
    obj["tint"].string = tint.toString()
    obj["title"].string = title
    obj["steps"].arrayObject = steps.map { ["title": $0.title, "length": $0.length] }
    return obj
  }
  
  func indexFor(time: Int) -> Index {
    let progress = Float(time) / Float(totalLength)
    var t = time
    for (i, step) in steps.enumerated() {
      if t < step.length {
        let stepProgress = Float(t) / Float(step.length)
        return Index(time: time, progress: progress, step: i, stepTime: t, stepProgress: stepProgress, finished: false)
      }
      t -= step.length
    }
    return Index(time: totalLength, progress: 1, step: steps.count - 1, stepTime: steps.last!.length, stepProgress: 1, finished: true)
  }
  
  func indexFor(step: Int, stepTime: Int) -> Index {
    var time = stepTime
    for i in 0..<step {
      time += steps[i].length
    }
    return indexFor(time: time)
  }
  
}
