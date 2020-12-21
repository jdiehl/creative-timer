//
//  EditProgramView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 10.10.20.
//

import SwiftUI

// TODO: changes are not saved
struct EditProgramView: View {
  @Environment(\.editMode) var editMode
  @State var program: Program
  var selectProgram: () -> Void
  @State var stepSelection: Int? = nil

  var body: some View {
    List {
      Section(header: Text("Title")) {
        if editMode?.wrappedValue == .active {
          TextField("Title", text: $program.title)
        } else {
          Text(program.title)
        }
      }
      
      Section(header: Text("Apperance")) {
        if editMode?.wrappedValue == .active {
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
    .navigationBarItems(trailing: HStack {
      TextButton(text: "Select") { selectProgram() }
        .padding(.trailing, 10.0)
        .disabled(editMode?.wrappedValue == .active)
      EditButton()
    })
  }
}

struct EditProgramView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NavigationView {
        EditProgramView(program: Program()) {}
      }
      NavigationView {
        EditProgramView(program: Program()) {}
          .environment(\.editMode, Binding.constant(EditMode.active))
      }
    }
  }
}
