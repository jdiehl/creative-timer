//
//  EditProgramView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 10.10.20.
//

import SwiftUI

struct EditProgramView: View {
  @State var program: Program

  var body: some View {
    VStack {
      List {
        Section(header: Text("Title")) {
          TextField("Title", text: $program.title)
        }
        
        Section(header: Text("Apperance")) {
          AppearanceCell(appearance: $program.appearance)
        }

        Section(header: Text("Steps")) {
          ForEach(0..<program.steps.count, id: \.self) { i in
            let step = program.steps[i]
            StepCell(index: i, step: step)
          }
          .onDelete { program.steps.remove(atOffsets: $0) }
          .onMove { program.steps.move(fromOffsets: $0, toOffset: $1) }
          .onTapGesture {
            print("Tap")
          }
        }
      }
      .environment(\.editMode, .constant(EditMode.active))
      
      Spacer()
      
      Button(action: {
        let step = Program.Step()
        program.steps.append(step)
      }) {
        Image(systemName: "plus.circle.fill")
          .foregroundColor(.green)
        Text("Add Step")
      }

    }
    .navigationTitle(program.title)
  }
}

struct EditProgramView_Previews: PreviewProvider {
  static var previews: some View {
    EditProgramView(program: Program())
  }
}
