//
//  MarkerView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 10.10.20.
//

import SwiftUI

struct MarkerView: View {
  var label: String
  var appearance: Appearance
  
  var body: some View {
    ZStack {
      Circle()
        .fill(Color.foreground(appearance: appearance))
        .frame(width: 40, height: 40)
      
      Text(label)
        .font(.system(size: 20, weight: .bold))
        .foregroundColor(Color.background(appearance: appearance))
    }
  }
}

struct MarkerView_Previews: PreviewProvider {
  static var previews: some View {
    MarkerView(label: "1", appearance: Appearance())
      .previewLayout(.fixed(width: 40, height: 40))
  }
}
