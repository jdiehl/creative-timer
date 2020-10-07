//
//  ProgressView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 23.09.20.
//

import SwiftUI

struct ProgressView: View {
  var progress: Double
  var width = 20.0
  var up: Bool = true
  var foregroundColor: Color = .red
  var backgroundColor: Color = Color.black.opacity(0.1)
  
  var body: some View {
    let cgWidth = CGFloat(width)
    ZStack {
      Circle()
        .stroke(lineWidth: cgWidth)
        .foregroundColor(backgroundColor)
      
      Circle()
        .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
        .stroke(style: StrokeStyle(lineWidth: cgWidth, lineCap: .round, lineJoin: .round))
        .foregroundColor(foregroundColor)
        .rotationEffect(Angle(degrees: 270.0))
        .animation(.easeOut(duration: 0.2))
    }
    .padding(cgWidth / 2)
    .aspectRatio(1, contentMode: .fit)
  }
}

struct ProgressView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ProgressView(progress: 0.0)
      ProgressView(progress: 0.2)
      ProgressView(progress: 0.5)
      ProgressView(progress: 1.0)
      ProgressView(progress: 0.3, up: false, foregroundColor: .yellow)
      ProgressView(progress: 0.7, up: false, foregroundColor: .yellow)
    }
    .previewLayout(.fixed(width: 100.0, height: 100.0))
  }
}
