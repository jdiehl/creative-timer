//
//  StyleCell.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 17.08.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class StyleCell: UITableViewCell {
  
  var theme: Tint.Theme? { didSet { updateTheme() }}
  var style: Tint.Style? { didSet { updateStyle() }}
  var didChange: ((Tint.Style) -> Void)?

  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var selectedView: UIImageView!

  override func awakeFromNib() {
    setup()
  }
  
  private func setup() {
    for style in Tint.allStyles {
      let view = makeStyleView(style: style)
      view.onClick = {
        self.style = style
        self.didChange?(style)
      }
      stackView.addArrangedSubview(view)
    }
  }
  
  private func updateTheme() {
    guard let theme = theme else { return }
    for view in stackView.arrangedSubviews as! [StyleView] {
      view.theme = theme
    }
  }
  
  private func updateStyle() {
    guard let style = style else { return }
    let index = Tint.allStyles.firstIndex(of: style)!
    selectedView.frame.origin = CGPoint(x: 16 + 72 + 3 + index * 96, y: 8 + 24 + 3)
  }
  
  private func makeStyleView(style: Tint.Style) -> StyleView {
    let view = StyleView()
    view.style = style
    view.heightAnchor.constraint(equalToConstant: 44).isActive = true
    view.widthAnchor.constraint(equalToConstant: 92).isActive = true
    return view
  }

}
