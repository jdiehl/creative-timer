//
//  Program.swift
//  Timer
//
//  Created by Jonathan Diehl on 11.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

enum ProgramError: Error {
    case overtime
}

struct Program {
  
  struct Step {
    let title: String
    let length: Int
  }
  
  struct Index: Equatable {
    let step: Int
    let time: Int
  }

  let title: String
  let repetitions: Int
  let steps: [Step]
  
  var totalLength: Int { steps.reduce(0) { $0 + $1.length } }
  
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
