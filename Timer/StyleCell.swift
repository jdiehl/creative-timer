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
  
  let size = CGSize(width: 92, height: 44)

  override func awakeFromNib() {
    setup()
    setNeedsLayout()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    updateStyle()
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
    let gap = (frame.size.width - 32 - size.width * CGFloat(Tint.allStyles.count)) / CGFloat(Tint.allStyles.count - 1)
    let x = 16 + CGFloat(index) * (size.width + gap) + size.width - 23
    let y = CGFloat(8 + size.height - 23)
    selectedView.frame.origin = CGPoint(x: x, y: y)
  }
  
  private func makeStyleView(style: Tint.Style) -> StyleView {
    let view = StyleView()
    view.style = style
    view.widthAnchor.constraint(equalToConstant: size.width).isActive = true
    view.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    return view
  }

}
