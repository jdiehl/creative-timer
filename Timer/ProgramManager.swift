//
//  ProgramManager.swift
//  Timer
//
//  Created by Jonathan Diehl on 12.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import SwiftyJSON
import Foundation

enum ProgramManagerEvents {
  case activeProgramChanged
}

class ProgramManager: EventEmitter<ProgramManagerEvents> {
  static let shared = ProgramManager()
  
  var activeProgram: Program { programs[active] }
  private(set) var programs: [Program] = []
  
  private var active = 0
  
  private var programsURL: URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("programs.json")
  }
  
  private var defaultProgramsURL: URL {
    Bundle.main.url(forResource: "defaultPrograms", withExtension: "json")!
  }
  
  override init() {
    super.init()
    if !load(url: programsURL) {
      assert(load(url: defaultProgramsURL))
    }
    UserDefaults.standard.register(defaults: ["activeProgram": 0])
    set(active: UserDefaults.standard.integer(forKey: "activeProgram"))
  }
  
  func set(active: Int) {
    guard active < programs.count else { return }
    self.active = active
    UserDefaults.standard.set(active, forKey: "activeProgram")
    emit(.activeProgramChanged)
  }
  
  func set(program: Program, at: Int) {
    programs[at] = program
    save()
    if at == active { emit(.activeProgramChanged) }
  }
  
  func add() {
    programs.append(Program())
    save()
  }
  
  func insert(program: Program, at: Int) {
    programs.insert(program, at: at)
    save()
    if at <= active { set(active: active + 1) }
  }
  
  func remove(at: Int) {
    programs.remove(at: at)
    save()
    if at <= active { set(active: active - 1) }
  }
  
  private func load(url: URL) -> Bool {
    guard let json = try? JSON(data: Data(contentsOf: url)) else { return false }
    programs = json.array!.map { Program(json: $0)! }
    active = 0
    return true
  }
  
  private func save(url: URL? = nil) {
    let jsonPrograms = programs.map { $0.toJSON() }
    try! JSON(jsonPrograms).rawData().write(to: url ?? programsURL)
  }
  
}
