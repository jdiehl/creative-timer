//
//  ColorView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 10.10.20.
//

import SwiftUI

struct ThemeView: View {
  var theme: Appearance.Theme
  var selected: Bool
  
  private var appearance: Appearance { Appearance(theme: theme, style: .automatic) }
  
  var body: some View {
    let size: CGFloat = selected ? 20 : 10
    RoundedRectangle(cornerRadius: 5)
      .fill(Color.foreground(appearance: appearance))
      .frame(width: size, height: size, alignment: .center)
      .animation(.easeInOut, value: selected)
  }
}

struct ThemeView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ForEach(Appearance.allThemes, id: \.self) { theme in
        ThemeView(theme: theme, selected: false)
      }
    }
    .previewLayout(.fixed(width: 20, height: 20))
  }
}
