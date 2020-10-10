//
//  ThemeCell.swift
//  Custimer
//
//  Created by Jonathan Diehl on 10.10.20.
//

import SwiftUI

struct AppearanceCell: View {
  @Binding var appearance: Appearance

  var body: some View {
    VStack {
      HStack {
        ForEach(Appearance.allThemes, id: \.self) { theme in
          ThemeView(theme: theme, selected: theme == appearance.theme)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture { appearance.theme = theme }
        }
      }
      .frame(minHeight: 30)

      HStack {
        ForEach(Appearance.allStyles, id: \.self) { style in
          StyleView(appearance: Appearance(theme: appearance.theme, style: style), selected: style == appearance.style)
            .onTapGesture { appearance.style = style }
        }
      }
      .frame(minHeight: 30)
    }
  }
}

struct AppearanceCell_Previews: PreviewProvider {
  static var previews: some View {
    AppearanceCell(appearance: .constant(Appearance()))
      .previewLayout(.fixed(width: 375, height: 80))
  }
}
