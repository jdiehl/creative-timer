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
  var appearance: Appearance
  
  var body: some View {
    HStack {
      MarkerView(label: "\(index+1)", appearance: Appearance(theme: appearance.theme, style: .automatic))
      VStack(alignment: .leading) {
        Text(String.time(step.length))
          .font(.subheadline)

        if step.title != "" {
          Text(step.title)
            .font(.headline)
        }
      }
      Spacer()
    }
    .background(Color(UIColor.systemBackground))
  }
}

struct StepCell_Previews: PreviewProvider {
  static var previews: some View {
    StepCell(index: 1, step: Program.Step(), appearance: Appearance())
      .previewLayout(.fixed(width: 375.0, height: 44.0  ))
  }
}
