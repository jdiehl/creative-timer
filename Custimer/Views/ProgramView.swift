//
//  ProgramView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 279.20.
//

import SwiftUI

struct ProgramView: View {
  var program: Program
  var index: ProgramIndex?
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        
        // background line
        RoundedRectangle(cornerRadius: 5)
          .fill(Color.gray(appearance: program.appearance))
          .frame(height: 10)
          .padding(20)
        
        // progress line
        RoundedRectangle(cornerRadius: 5)
          .fill(Color.foreground(appearance: program.appearance))
          .frame(width: progressWidth(geometry: geometry), height: 10)
          .animation(.easeOut(duration: 0.2))
          .padding(20)
        
        // steps
        ZStack(alignment: .leading) {
          ForEach((0..<program.steps.count), id: \.self) { step in
            Circle()
              .fill(stepColor(step: step))
              .frame(width: 20, height: 20)
              .padding(.leading, progressWidth(geometry: geometry, step: step))
          }
        }
        .padding(10)
        
        // active step
        if index != nil {
          ZStack {
            Circle()
              .fill(Color.foreground(appearance: program.appearance))
              .frame(width: 40, height: 40)
            
            Text("\(index!.step + 1)")
              .font(.system(size: 20, weight: .bold))
              .foregroundColor(Color.background(appearance: program.appearance))
          }
          .padding(.leading, progressWidth(geometry: geometry))
        }
        
      }
      .frame(height: 40)
    }
    .frame(height: 40)
  }
  
  private func progressWidth(geometry: GeometryProxy, index: ProgramIndex? = nil) -> CGFloat {
    let progress = (index ?? self.index)?.progress ?? 1.0
    return (geometry.size.width - 40) * CGFloat(progress)
  }
  
  private func progressWidth(geometry: GeometryProxy, step: Int) -> CGFloat {
    let index = ProgramIndex.at(program: program, step: step, stepTime: 0)
    return progressWidth(geometry: geometry, index: index)
  }
  
  private func stepColor(step: Int) -> Color {
    let isActive = index != nil ? index!.step >= step : true
    return isActive ? Color.foreground(appearance: program.appearance) : Color.gray(appearance: program.appearance)
  }
  
}

struct ProgramView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      let program = Program(title: "", appearance: Appearance(), direction: .down, pause: 0, steps: [Program.Step(), Program.Step(title: "", length: 60), Program.Step(title: "x")])
      ProgramView(program: program, index: ProgramIndex.at(program: program, time: 0))
      ProgramView(program: program, index: ProgramIndex.at(program: program, time: 30))
      ProgramView(program: program, index: ProgramIndex.at(program: program, time: 75))
      ProgramView(program: program, index: ProgramIndex.at(program: program, time: 90))
      ProgramView(program: program, index: ProgramIndex.at(program: program, time: 120))
      ProgramView(program: program)
    }
    .previewLayout(.fixed(width: 375, height: 40))
  }
}
