//
//  TimerState.swift
//  Custimer
//
//  Created by Jonathan Diehl on 27.09.20.
//

import Foundation

class TimerState: ObservableObject {
  
  @Published var programs: [Program]
  @Published var program: Program
  @Published var index: ProgramIndex!
  @Published var running = false
  @Published var showPrograms = false

  private var timer: Timer?

  convenience init() {
    let programs = try! ProgramService.shared.load()
    let programIndex = DefaultsService.shared.activeProgram
    let program = programIndex < programs.count ? programs[programIndex] : programs[0]
    let index = ProgramIndex.at(program: program, time: 0)
    self.init(programs: programs, program: program, index: index)
  }
  
  init(programs: [Program], program: Program, index: ProgramIndex) {
    self.programs = programs
    self.program = program
    self.index = index
  }
  
  func set(programIndex: Int) {
    program = programs[programIndex]
    DefaultsService.shared.activeProgram = programIndex
    reset()
  }
  
  // MARK: - Convenience Accessors
  var appearance: Appearance { return self.program.appearance }
  var step: Program.Step { return self.program.step(at: self.index) }

  // MARK: - Controls
  
  func play() {
    guard !running else { return }
    if self.index.state == .finished { self.reset() }
    running = true
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      self.index = ProgramIndex.at(program: self.program, time: self.index.time + 1)
      if self.index.state == .finished { self.pause() }
    }
  }
  
  func pause() {
    guard running else { return }
    running = false
    timer!.invalidate()
    timer = nil
  }
  
  func reset() {
    pause()
    index = ProgramIndex.at(program: program, time: 0)
  }

}

extension TimerState {
  
  #if DEBUG
  class func mock() -> TimerState {
    let appearance = Appearance(theme: .crimson, style: .automatic)
    let steps = [Program.Step(title: "1", length: 3), Program.Step(title: "2", length: 60), Program.Step(title: "3", length: 30)]
    let program = Program(title: "Timer Test", appearance: appearance, direction: .down, pause: 10, steps: steps)
    let index = ProgramIndex.at(program: program, time: 39)
    return TimerState(programs: [program], program: program, index: index)
  }
  #endif
  
}
