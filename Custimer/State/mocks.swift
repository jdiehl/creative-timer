//
//  MainState.mock.swift
//  Custimer
//
//  Created by Jonathan Diehl on 23.12.20.
//

import Foundation

#if DEBUG
extension Program {
  static func mock() -> Program {
    let steps = [Program.Step(title: "1", length: 3), Program.Step(title: "2", length: 60), Program.Step(title: "3", length: 30)]
    return Program(title: "Timer Test", appearance: Appearance(), direction: .down, pause: 10, steps: steps)
  }
}

extension AppState {
  class func mock() -> AppState {
    let program = Program.mock()
    let state = AppState(programs: [program], program: program, index: ProgramIndex.at(program: program, time: 39))
    return state
  }
}

extension TimerState {
  class func mock() -> TimerState {
    let program = Program.mock()
    return TimerState(program: program, index: ProgramIndex.at(program: program, time: 39))
  }
}
#endif
