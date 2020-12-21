//
//  IconButton.swift
//  Custimer
//
//  Created by Jonathan Diehl on 21.12.20.
//

import SwiftUI

struct TextButton: View {
  var text: String
  var action: () -> Void = {}

  var body: some View {
    Button(action: action) { Text(text) }
  }
}

struct TextButton_Previews: PreviewProvider {
  static var previews: some View {
    TextButton(text: "Done")
      .previewLayout(.fixed(width: 100.0, height: 100.0))
  }
}
