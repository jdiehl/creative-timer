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
      List(0..<state.programs.count, id: \.self) { i in
        NavigationLink(destination: EditProgramView(program: $state.programs[i])) {
          ProgramCell(program: state.programs[i])
        }
      }
      .listStyle(PlainListStyle())
      .navigationTitle("Timers")
      .navigationBarItems(
        leading: IconButton(systemName: "multiply") { dismiss() },
        trailing: EditButton()
      )
    }
  }
  
  private func insert() {
    
  }
  
  private func dismiss() {
    state.showPrograms = false
  }
}

struct ProgramModal_Previews: PreviewProvider {
  static var previews: some View {
    ProgramModal()
      .environmentObject(AppState.mock())
  }
}
