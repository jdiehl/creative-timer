//
//  ProgressCell.swift
//  Custimer
//
//  Created by Jonathan Diehl on 21.12.20.
//

import SwiftUI

struct ProgressCell: View {
  var appearance: Appearance

  var body: some View {
    HStack {
      ProgressView(progress: 1, label: "00:00", width: 5, appearance: appearance)
      Spacer()
    }
  }
}

struct ProgressCell_Previews: PreviewProvider {
  static var previews: some View {
    ProgressCell(appearance: Appearance())
      .previewLayout(.fixed(width: 375.0, height: 80))
  }
}
