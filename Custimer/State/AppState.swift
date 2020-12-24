//
//  MainState.swift
//  Custimer
//
//  Created by Jonathan Diehl on 23.12.20.
//

import Foundation
import Combine

class AppState: ObservableObject {
  
  // MARK: - Programs

  @Published var showPrograms = false
  @Published var programs: [Program] = []
  
  // MARK: - Timer
  
  @Published var program: Program
  @Published var index = ProgramIndex.atStart()
  @Published var running = false

  var appearance: Appearance { return self.program.appearance }
  var step: Program.Step? { return self.program.step(at: self.index) }

  private var timer: Timer?

  func select(program: Program) {
    let index = programs.firstIndex(of: program)!
    DefaultsService.shared.activeProgram = index
    self.program = program
    reset()
  }
  
  func save(program: Program) {
    if let index = programs.firstIndex(of: program) {
      programs[index] = program
    } else {
      programs.append(program)
    }
    try! ProgramService.shared.save(programs: programs)
  }


  func start() {
    guard !running else { return }
    if self.index.state == .finished { self.reset() }
    running = true
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      self.index = ProgramIndex.at(program: self.program, time: self.index.time + 1)
      if self.index.state == .finished { self.stop() }
    }
  }
  
  func stop() {
    guard running else { return }
    running = false
    timer!.invalidate()
    timer = nil
  }
  
  func reset() {
    stop()
    index = ProgramIndex.atStart()
  }
  
  
  // MARK: - Init

  init() {
    let programs = try! ProgramService.shared.load()
    let i = DefaultsService.shared.activeProgram
    self.programs = programs
    program = programs[i]
  }


}
