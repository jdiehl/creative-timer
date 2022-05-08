//
//  EditableAppearance.swift
//  Custimer
//
//  Created by Jonathan Diehl on 31.12.20.
//

import SwiftUI

struct EditableDirection: View {
  @Binding var direction: Program.Direction
  @Environment(\.editMode) var editMode

  var body: some View {
    if self.editMode?.wrappedValue == .active {
      HStack {
        Spacer()

        Text("Up")
          .fontWeight(direction == .up ? .bold : .regular)
          .foregroundColor(Color.blue)
          .padding(.horizontal)
          .onTapGesture {
            self.direction = .up
          }

        Text("Down")
          .fontWeight(direction == .down ? .bold : .regular)
          .foregroundColor(Color.blue)
          .padding(.horizontal)
          .onTapGesture {
            self.direction = .down
          }
      }
    } else {
      HStack {
        Text("Count Direction:")
        Spacer()
        Text(direction == .down ? "Down" : "Up")
      }
    }
  }
}

struct EditableDirection_Previews: PreviewProvider {
  static var previews: some View {
    EditableDirection(direction: .constant(.down))
  }
}
