//
//  ThemeCell.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 16.08.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class ThemeCell: UITableViewCell {
  
  var theme: Tint.Theme? { didSet { update() }}
  var didChange: ((Tint.Theme) -> Void)?

  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var selectedView: UIImageView!

  override func awakeFromNib() {
    setup()
    update()
  }
  
  private func setup() {
    for theme in Tint.allThemes {
      let view = makeThemeView(theme: theme)
      view.onClick = {
        self.theme = theme
        self.didChange?(theme)
      }
      stackView.addArrangedSubview(view)
    }
  }
  
  private func update() {
    guard let theme = theme else { return }
    let index = Tint.allThemes.firstIndex(of: theme)!
    selectedView.frame.origin = CGPoint(x: 16 + 24 + 3 + index * 48, y: 8 + 24 + 3)
  }
  
  private func makeThemeView(theme: Tint.Theme) -> ThemeView {
    let view = ThemeView()
    view.theme = theme
    view.heightAnchor.constraint(equalToConstant: 44).isActive = true
    view.widthAnchor.constraint(equalToConstant: 44).isActive = true
    return view
  }

}
