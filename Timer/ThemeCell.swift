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
  
  private let size = CGSize(width: 44, height: 44)

  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var selectedView: UIImageView!

  override func awakeFromNib() {
    setup()
    setNeedsLayout()
  }
  
  override func layoutSubviews() {
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
    let gap = (frame.size.width - 32 - size.width * CGFloat(Tint.allThemes.count)) / CGFloat(Tint.allThemes.count - 1)
    let x = 16 + CGFloat(index) * (size.width + gap) + size.width - 23
    let y = CGFloat(8 + size.height - 23)
    selectedView.frame.origin = CGPoint(x: x, y: y)
  }
  
  private func makeThemeView(theme: Tint.Theme) -> ThemeView {
    let view = ThemeView()
    view.theme = theme
    view.widthAnchor.constraint(equalToConstant: size.width).isActive = true
    view.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    return view
  }

}
