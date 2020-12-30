//
//  ProgramIndex.swift
//  Custimer
//
//  Created by Jonathan Diehl on 27.09.20.
//

import Foundation

struct ProgramIndex {
  let time: Int
  let progress: Double
  let step: Int
  let stepTime: Int
  let stepProgress: Double
  let state: IndexState
}

// MARK: - Types
extension ProgramIndex {

  enum IndexState {
    case step
    case pause
    case finished
  }

}

// MARK: - Convenience Methods
extension ProgramIndex {
  
  func timeDifference(to: ProgramIndex) -> Int {
    return to.time - time
  }
  
  static func atStart() -> ProgramIndex {
    return ProgramIndex(time: 0, progress: 0, step: 0, stepTime: 0, stepProgress: 0, state: .step)
  }
  
  // return the finished index
  static func endOf(program: Program) -> ProgramIndex {
    return ProgramIndex(time: program.totalLength, progress: 1, step: program.steps.count - 1, stepTime: program.steps.last!.length, stepProgress: 1, state: .finished)
  }

  // get an index for a given time in a given program
  static func at(program: Program, time: Int) -> ProgramIndex {
    let totalLength = program.totalLength
    
    // return the finished index if the time is not less than the total length
    guard time < totalLength else { return ProgramIndex.endOf(program: program) }
      
    // compute total progress (will be needed later
    let progress = Double(time) / Double(totalLength)
    
    // t is reduced by each step (time and pause) to determine the correct step
    var t = time
    for (i, step) in program.steps.enumerated() {
      
      // t is inside this step
      if t < step.length {
        let stepProgress = Double(t) / Double(step.length)
        return ProgramIndex(time: time, progress: progress, step: i, stepTime: t, stepProgress: stepProgress, state: .step)
      }
      t -= step.length

      // do not check for pause on the last step
      if i >= program.steps.count - 1 { break }

      // t is inside the pause after the step
      if t < program.pause {
        let stepProgress = Double(t) / Double(program.pause)
        return ProgramIndex(time: time, progress: progress, step: i, stepTime: t, stepProgress: stepProgress, state: .pause)
      }

      t -= program.pause
    }
    return ProgramIndex.endOf(program: program)
  }
  
  static func at(program: Program, progress: Double) -> ProgramIndex {
    return ProgramIndex.at(program: program, time: Int(Double(program.totalLength) * progress))
  }

  // return the index for a step and stepTime
  static func at(program: Program, step: Int, stepTime: Int) -> ProgramIndex {
    var time = stepTime
    for i in 0..<step {
      time += program.steps[i].length + program.pause
    }
    return ProgramIndex.at(program: program, time: time)
  }

}
