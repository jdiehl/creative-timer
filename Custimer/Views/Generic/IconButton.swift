//
//  IconButton.swift
//  Custimer
//
//  Created by Jonathan Diehl on 21.12.20.
//

import SwiftUI

struct IconButton: View {
  var systemName: String
  var action: () -> Void = {}

  var body: some View {
    Button(action: action) { Image(systemName: systemName) }
  }
}

struct IconButton_Previews: PreviewProvider {
  static var previews: some View {
    IconButton(systemName: "multiply")
      .previewLayout(.fixed(width: 100.0, height: 100.0))
  }
}
