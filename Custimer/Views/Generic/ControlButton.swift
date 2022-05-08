//
//  IconButton.swift
//  Custimer
//
//  Created by Jonathan Diehl on 21.12.20.
//

import SwiftUI

struct ControlButton: View {
  var systemName: String
  var appearance: Appearance = Appearance()
  var action: () -> Void = {}
  var width = 44.0
  var height = 44.0
  
  @State private var tapped = false
  
  var foregroundColor: Color { return tapped ? Color.foreground(appearance: appearance) : Color.background(appearance: appearance) }
  var backgroundColor: Color { return tapped ? Color.background(appearance: appearance) : Color.foreground(appearance: appearance) }

  var body: some View {
    ZStack {
      Circle()
        .strokeBorder(foregroundColor)
        .background(Circle().foregroundColor(backgroundColor))
        .frame(width: width, height: height)
      Image(systemName: systemName)
        .renderingMode(.template)
        .foregroundColor(foregroundColor)
    }
    .gesture(
      DragGesture(minimumDistance: 0)
        .onChanged({ _ in tapped = true })
        .onEnded({ _ in
          tapped = false
          action()
        })
      )
  }
}

struct ControlButton_Previews: PreviewProvider {
  static var previews: some View {
    ControlButton(systemName: "play.fill")
      .previewLayout(.fixed(width: 100.0, height: 100.0))
  }
}
