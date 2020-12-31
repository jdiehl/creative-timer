//
//  ShareSheet.swift
//  Custimer
//
//  Created by Jonathan Diehl on 31.12.20.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
  typealias UIViewControllerType = UIActivityViewController
  
  var sharing: [Any]
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<ShareSheet>) -> UIActivityViewController {
    let vc = UIActivityViewController(activityItems: sharing, applicationActivities: nil)
//    vc.modalPresentationStyle = .pageSheet
    return vc
  }
  
  func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareSheet>) {
    // nothing
  }
}

struct ShareSheet_Previews: PreviewProvider {
  static var previews: some View {
    ShareSheet(sharing: ["Hello"])
  }
}
