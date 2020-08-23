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
  private(set) var program: Program
  
  // the index (step, time))
  private(set) var index: Program.Index {
    didSet {
      if index.step != oldValue.step { emit(.stepChanged) }
      emit(.tick)
    }
  }

  // running state
  private(set) var running = false

  // the step
  var step: Program.Step { program.steps[index.step] }

  // private timer instance
  private var timer: SecondsTimer?
  
  private let programManager = ProgramManager.shared
  
  override init() {
    self.program = programManager.activeProgram
    self.index = program.indexFor(time: 0)
    super.init()
    programManager.on(.activeProgramChanged) {
      self.set(program: self.programManager.activeProgram)
    }
  }
  
  func set(program: Program) {
    self.program = program
    reset()
    emit(.programChanged)
  }
  
  // set the index
  func set(index: Program.Index) {
    stop()
    self.index = index
    emit(.set)
  }

  // set the index step and time
  func set(step: Int, time: Int) {
    set(index: program.indexFor(step: step, stepTime: time))
  }
  
  // set the progress
  func set(progress: Float) {
    set(step: index.step, time: Int(progress * Float(step.length)))
  }
  
  // reset the runner
  func reset() {
    set(step: 0, time: 0)
  }

  // start the runner
  func start() {
    guard !running else { return }
    running = true
    timer = SecondsTimer(startTime: index.time) { self.onTick($0) }
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
    index = program.indexFor(time: passedTime)
    emit(.tick)
    if index.finished {
      stop()
      emit(.finished)
    }
  }
  
}
