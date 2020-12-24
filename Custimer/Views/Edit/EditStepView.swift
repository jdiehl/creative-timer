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
  
  // necessary since TextField with value/formatter does not update
  // https://stackoverflow.com/questions/56799456/swiftui-textfield-with-formatter-not-working
  var lengthProxy: Binding<String> {
    Binding<String>(
      get: { String(self.step.length) },
      set: {
        guard let value = Int($0) else { return }
        self.step.length = value
      }
    )
  }
  
  var body: some View {
    List {
      TextField("Title", text: $step.title)
      TextField("Length", text: lengthProxy)
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
