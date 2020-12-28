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
  private let soundService = SoundService.shared
  
  // MARK: - Program Management

  func select(program: Program) {
    DefaultsService.shared.activeProgram = program.id
    self.program = program
    reset()
  }
  
  func save() {
    try! ProgramService.shared.save(programs: programs)
  }
  
  func update(program: Program) {
    guard let index = programs.firstIndex(where: { $0.id == program.id }) else { return }
    programs[index] = program
    
    // update selected program if needed
    if self.program.id == program.id {
      select(program: program)
    }
    
    // save
    save()
  }
  
  func remove(atOffsets: IndexSet) {
    guard programs.count > atOffsets.count else { return }
    programs.remove(atOffsets: atOffsets)
    save()

    // update selected program if needed
    if !programs.contains(where: { $0.id == program.id }) {
      select(program: programs[0])
    }
  }
  
  func move(fromOffsets: IndexSet, toOffset: Int) {
    programs.move(fromOffsets: fromOffsets, toOffset: toOffset)
    save()
  }
  
  func insert() {
    let program = Program()
    programs.append(program)
  }
  
  // MARK: - Timer Management

  func start() {
    guard !running else { return }
    if self.index.state == .finished { self.reset() }
    running = true
    IdleTimerService.shared.disable()
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      self.index = ProgramIndex.at(program: self.program, time: self.index.time + 1)
      if self.index.state == .finished { self.stop() }
      if let sound = self.program.sound(at: self.index) {
        self.soundService.play(sound: sound) {
          if let announce = self.program.announce(at: self.index) { self.soundService.announce(text: announce) }
        }
      }
    }
  }
  
  func stop() {
    guard running else { return }
    running = false
    IdleTimerService.shared.enable()
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
    self.programs = programs
    let id = DefaultsService.shared.activeProgram
    program = (id != nil ? programs.first { $0.id == id } : nil) ?? programs[0]
  }


}
