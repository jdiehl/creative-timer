//
//  ProgramRunner.swift
//  Timer
//
//  Created by Jonathan Diehl on 11.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

enum ProgramRunnerEvents {
  case tick
  case stepChanged
  case started
  case stopped
  case finished
  case programChanged
  case set
}

class ProgramRunner: EventEmitter<ProgramRunnerEvents> {
  
  // singleton instance
  static let shared = ProgramRunner()
  
  // the program to run
  var program: Program? {
    didSet {
      reset()
      emit(.programChanged)
    }
  }
  
  // the index (step, time))
  private(set) var index = Program.Index(step: 0, time: 0) {
    didSet {
      if index.step != oldValue.step {
        emit(.stepChanged)
      }
      emit(.tick)
    }
  }

  // running state
  private(set) var running = false

  // the step
  var step: Program.Step? { program?.steps[index.step] }

  // step progress
  var stepProgress: Float { Float(index.time) / Float(stepLength) }
  var stepTime: Int { index.time }
  var stepTimeRemaining: Int { stepLength - index.time }
  var stepLength: Int { step?.length ?? 1 }
  
  // total progress
  var totalProgress: Float { Float(totalTime) / Float(totalLength) }
  var totalTime: Int { program?.timeForIndex(index) ?? 0 }
  var totalTimeRemaining: Int { totalLength - totalTime }
  var totalLength: Int { program?.totalLength ?? 1 }
  
  // private timer instance
  private var timer: SecondsTimer?
  
  // set the index
  func set(index: Program.Index) {
    stop()
    self.index = index
    emit(.set)
  }

  // set the index step and time
  func set(step: Int, time: Int) {
    set(index: Program.Index(step: step, time: time))
  }
  
  // set the index time (preserves step)
  func set(time: Int) {
    set(index: Program.Index(step: index.step, time: time))
  }
  
  // set the progress
  func set(progress: Float) {
    set(time: Int(progress * Float(stepLength)))
  }
  
  // reset the runner
  func reset() {
    set(step: 0, time: 0)
  }

  // start the runner
  func start() {
    guard !running else { return }
    guard program != nil else { return }
    running = true
    timer = SecondsTimer(startTime: totalTime) { self.onTick($0) }
    emit(.started)
  }
  
  // stop the timer
  func stop() {
    guard running else { return }
    timer?.invalidate()
    timer = nil
    running = false
    emit(.stopped)
  }
  
  private func onTick(_ passedTime: Int) {
    if let index = program!.indexForTime(passedTime) {
      self.index = index
      emit(.tick)
    } else {
      index = Program.Index(step: self.index.step, time: self.stepLength)
      emit(.tick)
      stop()
      emit(.finished)
    }
  }
  
}
