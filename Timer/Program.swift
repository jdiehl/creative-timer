//
//  Program.swift
//  Timer
//
//  Created by Jonathan Diehl on 11.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import SwiftyJSON

enum ProgramError: Error {
    case overtime
}

struct Program {
  
  struct Step {
    var title: String
    var length: Int
  }
  
  struct Index: Equatable {
    let step: Int
    let time: Int
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
  
  init?(json: String) {
    let obj = JSON(parseJSON: json)
    guard let title = obj["title"].string else { return nil }
    guard let tint = Tint(withString: obj["tint"].string ?? "") else { return nil }
    guard let jsonSteps = obj["steps"].array else { return nil }
    let steps = jsonSteps.map { obj in Step(title: obj["title"].string ?? "", length: obj["length"].int ?? 30) }
    self.init(title: title, tint: tint, steps: steps)
  }
  
  func toJSON() -> String {
    var obj = JSON()
    obj["tint"].string = tint.toString()
    obj["title"].string = title
    obj["steps"].arrayObject = steps.map { ["title": $0.title, "length": $0.length] }
    return obj.rawString()!
  }
  
  func timeForIndex(_ index: Index) -> Int {
    var time: Int = 0
    for (i, step) in steps.enumerated() {
      if i >= index.step { break }
      time += step.length
    }
    return time + index.time
  }
  
  func indexForTime(_ time: Int) -> Index? {
    var t = time
    for (i, step) in steps.enumerated() {
      if t < step.length { return Index(step: i, time: t) }
      t -= step.length
    }
    return nil
  }
  
}
