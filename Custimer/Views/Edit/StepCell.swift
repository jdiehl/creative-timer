//
//  StepCell.swift
//  Custimer
//
//  Created by Jonathan Diehl on 10.10.20.
//

import SwiftUI

struct StepCell: View {
  var index: Int
  var step: Program.Step
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Step \(index)")
        Spacer()
        Text(String.time(step.length))
      }
      .font(.subheadline)

      if step.title != "" {
        Text(step.title)
          .font(.headline)
      }
    }
  }
}

struct StepCell_Previews: PreviewProvider {
  static var previews: some View {
    StepCell(index: 1, step: Program.Step())
  }
}
