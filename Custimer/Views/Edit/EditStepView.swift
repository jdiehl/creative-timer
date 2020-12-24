//
//  ShowProgramView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 10.10.20.
//

import SwiftUI

struct EditStepView: View {
  @Binding var step: Program.Step
  
  var body: some View {
    List {
      TextField("Title", text: $step.title)
      // TODO: length is not updated
      TextField("Length", value: $step.length, formatter: NumberFormatter())
        .keyboardType(.numberPad)
    }
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
