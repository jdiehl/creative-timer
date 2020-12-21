//
//  ShowProgramView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 10.10.20.
//

import SwiftUI

struct EditStepView: View {
  @Binding var step: Program.Step
  @Environment(\.editMode) var editMode

  var body: some View {
    List {
      TextField("Title", text: $step.title)
      // TODO: length is not updated
      TextField("Length", value: $step.length, formatter: NumberFormatter())
        .keyboardType(.numberPad)
    }
    .listStyle(PlainListStyle())
    .navigationTitle(step.title)
    .navigationBarItems(trailing: EditButton())
  }
}

struct EditStepView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      EditStepView(step: .constant(Program.Step()))
    }
  }
}
