//
//  ShowProgramView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 10.10.20.
//

import SwiftUI
import Combine

struct EditStepView: View {
  @Binding var step: Program.Step
  
  var body: some View {
    List {
      EditableText(label: "Title", text: $step.title)
      EditableTime(label: "Length", time: $step.length)
    }
    .environment(\.editMode, .constant(.active))
    .listStyle(PlainListStyle())
    .navigationTitle(step.title)
  }
}

struct EditStepView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      EditStepView(step: .constant(Program.Step(title: "Step", length: 30)))
    }
  }
}
