//
//  ProgramModal.swift
//  Custimer
//
//  Created by Jonathan Diehl on 07.10.20.
//

import SwiftUI

struct ProgramModal: View {
  @EnvironmentObject var state: AppState
  @Environment(\.editMode) var editMode

  var body: some View {
    NavigationView {
      List {
        ForEach(0..<state.programs.count, id: \.self) { i in
          NavigationLink(destination: EditProgramView(program: $state.programs[i])) {
            ProgramCell(program: state.programs[i])
          }
        }
        .onDelete { state.remove(atOffsets: $0) }
        .onMove { state.move(fromOffsets: $0, toOffset: $1) }
      }
      .listStyle(PlainListStyle())
      .navigationTitle("Timers")
      .navigationBarItems(
        leading: IconButton(systemName: "multiply") { dismiss() },
        trailing: EditButton()
      )
    }
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
