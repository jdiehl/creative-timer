//
//  MarkerLayer.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 30.08.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class MarkerView: UIView {
  
  private lazy var markerLayer = CAShapeLayer().addTo(layer)
  private lazy var textLayer = makeTextLayer().addTo(layer)
  
  convenience init() {
    self.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
  }
  
  override func layoutSubviews() {
    let lineHeight = textLayer.font!.lineHeight!
    textLayer.frame = CGRect(x: bounds.minX, y: bounds.midY - lineHeight / 2, width: bounds.width, height: lineHeight)
    markerLayer.path = CGPath(ellipseIn: bounds, transform: nil)
  }
  
  func set(label: String) {
    textLayer.string = label
  }
  
  func set(tint: Tint) {
    markerLayer.fillColor = tint.foregroundColor.cgColor
    textLayer.foregroundColor = tint.backgroundColor.cgColor
  }
  
  // MARK: - Private Methods
  
  private func makeTextLayer() -> CATextLayer {
    let textLayer = CATextLayer(font: UIFont.systemFont(ofSize: 24, weight: .medium))
    textLayer.alignmentMode = .center
    return textLayer
  }

}
