//
//  EditProgramView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 10.10.20.
//

import SwiftUI

struct EditProgramView: View {
  @State var program: Program
  @Environment(\.editMode) var editMode

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
        } else {
          ProgressView(progress: 1, label: "00:00", width: 5, appearance: program.appearance)
            .frame(height: 80)
        }
      }

      Section(header: Text("Steps")) {
        ForEach(0..<program.steps.count, id: \.self) { i in
          NavigationLink(destination: EditStepView(step: $program.steps[i])) {
            StepCell(index: i, step: program.steps[i])
          }
        }
        .onDelete { program.steps.remove(atOffsets: $0) }
        .onMove { program.steps.move(fromOffsets: $0, toOffset: $1) }
      }
    }
    .listStyle(PlainListStyle())
    .navigationTitle(program.title)
    .navigationBarItems(trailing: EditButton())
  }
}

struct EditProgramView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      EditProgramView(program: Program())
    }
  }
}
