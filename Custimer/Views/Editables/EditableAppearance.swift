//
//  EditableAppearance.swift
//  Custimer
//
//  Created by Jonathan Diehl on 31.12.20.
//

import SwiftUI

struct EditableAppearance: View {
  @Binding var appearance: Appearance
  @Environment(\.editMode) var editMode

  var body: some View {
    if self.editMode?.wrappedValue == .active {
      AppearanceCell(appearance: $appearance)
        .frame(height: 70.0)
    } else {
      ProgressCell(appearance: appearance)
        .frame(maxHeight: 70.0)
    }
  }
}

struct EditableAppearance_Previews: PreviewProvider {
  static var previews: some View {
    EditableAppearance(appearance: .constant(Appearance()))
    
  }
}
