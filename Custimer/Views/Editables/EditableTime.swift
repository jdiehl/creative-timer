//
//  EditableTime.swift
//  Custimer
//
//  Created by Jonathan Diehl on 31.12.20.
//

import SwiftUI

struct EditableTime: View {
  var label: String
  @Binding var time: Int
  @Environment(\.editMode) var editMode

  // necessary since TextField with value/formatter does not update
  // https://stackoverflow.com/questions/56799456/swiftui-textfield-with-formatter-not-working
  var proxy: Binding<String> {
    Binding<String>(
      get: { String(self.time) },
      set: {
        guard let value = Int($0) else { return }
        self.time = value
      }
    )
  }

  var body: some View {
    if self.editMode?.wrappedValue == .active {
      TextField(label, text: proxy)
    } else {
      Text("\(label): \(String.time(time))")
    }
  }
}

struct EditableTime_Previews: PreviewProvider {
  static var previews: some View {
    EditableTime(label: "Time", time: .constant(13))
  }
}
