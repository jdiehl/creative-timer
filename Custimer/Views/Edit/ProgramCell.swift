//
//  ProgramCell.swift
//  Custimer
//
//  Created by Jonathan Diehl on 07.10.20.
//

import SwiftUI

struct ProgramCell: View {
  var program: Program

  var body: some View {
    VStack(alignment: .leading) {
      Text(program.title)
        .font(.headline)
        .foregroundColor(Color.foreground(appearance: program.appearance))
        .padding([.top, .leading, .trailing])
      ProgramView(program: program)
    }
    .background(Color.background(appearance: program.appearance))
  }
}

struct ProgramCell_Previews: PreviewProvider {
  static var previews: some View {
    ProgramCell(program: Program())
  }
}
