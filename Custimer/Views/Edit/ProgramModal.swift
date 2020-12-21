//
//  ProgramModal.swift
//  Custimer
//
//  Created by Jonathan Diehl on 07.10.20.
//

import SwiftUI

struct ProgramModal: View {
  @EnvironmentObject var state: TimerState
  
  var body: some View {
    NavigationView {
      List((0..<state.programs.count), id: \.self) { i in
        let program = state.programs[i]
        NavigationLink(destination: EditProgramView(program: program, selectProgram: { select(i) })) {
          ProgramCell(program: program)
        }
      }
      .listStyle(PlainListStyle())
      .navigationTitle("Timers")
      .navigationBarItems(leading: IconButton(systemName: "multiply") { dismiss() }, trailing: EditButton())
    }
  }
  
  private func dismiss() {
    state.showPrograms = false
  }
  
  private func select(_ i: Int) {
    state.set(programIndex: i)
    dismiss()
  }
}

struct ProgramModal_Previews: PreviewProvider {
  static var previews: some View {
    ProgramModal()
      .environmentObject(TimerState.mock())
  }
}
