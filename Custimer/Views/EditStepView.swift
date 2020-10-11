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
      if editMode?.wrappedValue == .active {
        TextField("Title", text: $step.title)
      } else {
        Text(step.title)
      }

      if editMode?.wrappedValue == .active {
        Text(String.time(step.length))
//        TextField(text: $step.length)
      } else {
        Text(String.time(step.length))
      }
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
