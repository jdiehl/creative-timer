//
//  ToggleCell.swift
//  Custimer
//
//  Created by Jonathan Diehl on 31.12.20.
//

import SwiftUI

struct EditableText: View {
  var label: String
  @Binding var text: String
  @Environment(\.editMode) var editMode

  var body: some View {
    if self.editMode?.wrappedValue == .active {
      TextField(label, text: $text)
    } else {
      Text(text)
    }
  }
}

struct EditableText_Previews: PreviewProvider {
  static var previews: some View {
    EditableText(label: "Text", text: .constant("test"))
  }
}
