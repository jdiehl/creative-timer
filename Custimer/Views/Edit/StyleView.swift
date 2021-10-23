//
//  AppearanceView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 10.10.20.
//

import SwiftUI

struct StyleView: View {
  var appearance: Appearance
  var selected: Bool
  
  var overlay: some View {
    RoundedRectangle(cornerRadius: 5)
      .stroke(lineWidth: selected ? 5 : 1)
      .foregroundColor(appearance.style == .colored ? Color.black : Color.foreground(appearance: appearance))
      .animation(.easeInOut, value: selected)
  }

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 5)
        .fill(Color.background(appearance: appearance))
        .animation(.easeInOut, value: selected)
        .overlay(overlay)
      Text(appearance.style.rawValue)
        .font(.caption)
        .foregroundColor(Color.foreground(appearance: appearance))
    }
  }
}

struct StyleView_Previews: PreviewProvider {
  static var previews: some View {
    StyleView(appearance: Appearance(), selected: true)
      .previewLayout(.fixed(width: 80, height: 30))
      
  }
}
