//
//  AboutView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 27.12.20.
//

import SwiftUI

struct AboutView: View {
  var body: some View {
    VStack(alignment: .leading) {
      Text("Customer is an App from Jonathan Diehl.")
        .padding(.vertical)
      
      HStack {
        Text("Sound effects obtained from https://www.zapsplat.com")
      }
      .padding(.vertical)
      
      Spacer()
    }
    .navigationTitle("About Custimer")
    .toolbar {
      ToolbarItemGroup(placement: .bottomBar) {
        Link("Privacy Policy", destination: URL(string: "https://didie.space/timer/privacy.html")!)
        Spacer()
        Link("Report Bug", destination: URL(string: "mailto:jonathan.diehl@gmail.com?subject=Custimer%20Bug%20Report")!)
      }
    }
  }
}

struct AboutView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      AboutView()
    }
  }
}
