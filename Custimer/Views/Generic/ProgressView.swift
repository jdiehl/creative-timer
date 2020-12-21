//
//  ProgressView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 23.09.20.
//

import SwiftUI

struct ProgressView: View {
  var progress: Double
  var label: String?
  var width: CGFloat = 20.0
  var up: Bool = true
  var appearance: Appearance = Appearance()
  
  var body: some View {
    ZStack {
      Circle()
        .stroke(lineWidth: width)
        .fill(Color.gray(appearance: appearance))
      
      Circle()
        .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
        .stroke(style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round))
        .fill(Color.foreground(appearance: appearance))
        .rotationEffect(Angle(degrees: 270.0))
        .animation(.easeOut(duration: 0.2))
      
      if label != nil {
        Text(label!)
          .font(.system(size: 100, weight: .thin))
          .lineLimit(1)
          .minimumScaleFactor(0.01)
          .foregroundColor(Color.foreground(appearance: appearance))
          .padding(width * 1.5)
        
      }
    }
    .padding(width / 2)
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
      ProgressView(progress: 0.3, label: "00:00", width: 10, up: false, appearance: Appearance(theme: .earth, style: .automatic))
      ProgressView(progress: 0.7, label: "01:00", width: 10, up: false, appearance: Appearance(theme: .earth, style: .automatic))
    }
    .previewLayout(.fixed(width: 100.0, height: 100.0))
  }
}
