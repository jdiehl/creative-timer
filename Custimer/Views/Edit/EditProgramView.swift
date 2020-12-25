//
//  EditProgramView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 10.10.20.
//

import SwiftUI

// TODO: changes are not saved
struct EditProgramView: View {
  @EnvironmentObject var state: AppState
  @Binding var program: Program
  @State var editMode = EditMode.inactive

  @State private var stepSelection: Int? = nil
  
  var body: some View {
    List {
      Section(header: Text("Title")) {
        if editMode == .active {
          TextField("Title", text: $program.title)
        } else {
          Text(program.title)
        }
      }
      
      Section(header: Text("Apperance")) {
        if editMode == .active {
          AppearanceCell(appearance: $program.appearance)
            .frame(height: 70.0)
        } else {
          ProgressCell(appearance: program.appearance)
            .frame(maxHeight: 70.0)
        }
      }

      Section(header: Text("Steps")) {
        ForEach(0..<program.steps.count, id: \.self) { i in
          NavigationLink(destination: EditStepView(step: $program.steps[i]), tag: i, selection: $stepSelection) {
            StepCell(index: i, step: program.steps[i])
          }
          .onTapGesture { stepSelection = i }
        }
        .onDelete { program.steps.remove(atOffsets: $0) }
        .onMove { program.steps.move(fromOffsets: $0, toOffset: $1) }
      }
    }
    .listStyle(PlainListStyle())
    .navigationTitle(program.title)
    .navigationBarItems(trailing: EditButton())
    .toolbar {
      ToolbarItemGroup(placement: .bottomBar) {
        Spacer()
        TextButton(text: "Select") { select() }
          .disabled(editMode == .active)
      }
    }
    .onDisappear { update() }
    .environment(\.editMode, $editMode)
  }
  
  private func select() {
    state.select(program: program)
    state.showPrograms = false
  }
  
  private func update() {
    state.update(program: program)
  }
}

struct EditProgramView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NavigationView {
        EditProgramView(program: .constant(Program()))
          .environmentObject(AppState.mock())
      }
    }
  }
}
