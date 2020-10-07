//
//  ProgramManager.swift
//  Timer
//
//  Created by Jonathan Diehl on 12.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import Foundation

class ProgramService {
  static let shared = ProgramService()
  
  private var programsURL: URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("programs.json")
  }
  
  private var defaultProgramsURL: URL {
    Bundle.main.url(forResource: "defaultPrograms", withExtension: "json")!
  }
  
  func load() throws -> [Program] {
    do {
      return try load(url: programsURL)
    } catch {
      return try load(url: defaultProgramsURL)
    }
  }
  
  func save(programs: [Program]) throws {
    let data = try JSONEncoder().encode(programs)
    try data.write(to: programsURL)
  }
  
  private func load(url: URL) throws -> [Program] {
    let data = try Data(contentsOf: url)
    return try JSONDecoder().decode([Program].self, from: data)
  }
  
}
