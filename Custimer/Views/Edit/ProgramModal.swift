//
//  ProgramModal.swift
//  Custimer
//
//  Created by Jonathan Diehl on 07.10.20.
//

import SwiftUI

struct ProgramModal: View {
  @EnvironmentObject var state: AppState
  
  var body: some View {
    NavigationView {
      List((0..<state.programs.count), id: \.self) { i in
        let program = state.programs[i]
        NavigationLink(destination: EditProgramView(program: $state.programs[i])) {
          ProgramCell(program: program)
        }
      }
    }
  }
  
  private func insert() {
    
  }
  
  private func dismiss() {
    state.showPrograms = false
  }
  
  private func select(_ i: Int? = nil) {
    if i != nil {
      state.select(programIndex: i!)
    } else {
      state.select(programIndex: state.programs.count - 1)
    }
    dismiss()
  }
}

struct ProgramModal_Previews: PreviewProvider {
  static var previews: some View {
    ProgramModal()
      .environmentObject(AppState.mock())
  }
}
