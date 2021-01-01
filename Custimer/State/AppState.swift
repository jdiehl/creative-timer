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
  
  let timer: TimerState
  
  var appearance: Appearance { return self.timer.program.appearance }
  
  // MARK: - Program Management

  func select(program: Program) {
    DefaultsService.shared.activeProgram = program.id
    timer.program = program
  }
  
  func save() {
    try! ProgramService.shared.save(programs: programs)
  }
  
  func update(program: Program) {
    guard let index = programs.firstIndex(where: { $0.id == program.id }) else { return }
    programs[index] = program
    
    // update selected program if needed
    if timer.program.id == program.id {
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
    if !programs.contains(where: { $0.id == timer.program.id }) {
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
  
  // MARK: - Init
  
  init(programs: [Program], program: Program, index: ProgramIndex = ProgramIndex.atStart()) {
    self.programs = programs
    timer = TimerState(program: program, index: index)
  }

  convenience init() {
    let programs = try! ProgramService.shared.load()
    let id = DefaultsService.shared.activeProgram
    let program = (id != nil ? programs.first { $0.id == id } : nil) ?? programs[0]
    self.init(programs: programs, program: program)
  }

}
