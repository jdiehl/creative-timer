//
//  ToggleCell.swift
//  Custimer
//
//  Created by Jonathan Diehl on 31.12.20.
//

import SwiftUI

struct EditableBool: View {
  var label: String
  @Binding var isOn: Bool
  @Environment(\.editMode) var editMode

  var body: some View {
    if self.editMode?.wrappedValue == .active {
      Toggle(isOn: $isOn) { Text(label) }
    } else {
      HStack {
        Text(label)
        Spacer()
        Image(systemName: isOn ? "checkmark" : "multiply")
      }
    }
  }
}

struct EditableBool_Previews: PreviewProvider {
  static var previews: some View {
    EditableBool(label: "Toggle", isOn: .constant(true))
  }
}
