//
//  ProgressView.swift
//  Timer
//
//  Created by Jonathan Diehl on 15.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

@objc protocol ProgressViewDelegate: AnyObject {
  func willChangeProgress()
  func updateProgress(to: Float)
  func didChangeProgress(to: Float)
}

class ProgressView: UIView {
  
  @IBOutlet weak var delegate: ProgressViewDelegate?
  
  // the progress (0...1)
  var progress: Float = 0 {
    didSet { updateProgress() }
  }
  
  // the ring width in px
  var width: Float = 20 {
    didSet { setNeedsLayout() }
  }
  
  // the tint
  var tint: Tint? {
    didSet { updateColors() }
  }
  
  // the center of the ring
  private var ringCenter: CGPoint { CGPoint(x: self.bounds.midX, y: self.bounds.midY ) }

  // the radius of the ring
  private var outerRadius: CGFloat { min(self.bounds.size.width, self.bounds.size.height) / 2 }
  
  // background layer color
  
  // background layer
  lazy private var ringLayer = CAShapeLayer()
  
  // progress layer
  lazy private var progressLayer = CAShapeLayer()
  
  // MARK: - UIView
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  override func layoutSubviews() {
    updateRing()
    updateProgress()
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    updateColors()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard touches.count == 1 else { return }
    delegate?.willChangeProgress()
    let point = touches.first!.location(in: self)
    progress = Float(bounds.center.angle(target: point))
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard touches.count == 1 else { return }
    let point = touches.first!.location(in: self)
    let newProgress = Float(bounds.center.angle(target: point))
    
    // let the progress stick to the 0% / 100% mark
    if progress > 0.75 && newProgress < 0.25 {
      progress = 1
    } else if progress < 0.25 && newProgress > 0.75 {
      progress = 0
    } else {
      progress = newProgress
    }
    delegate?.updateProgress(to: progress)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    delegate?.didChangeProgress(to: progress)
  }

  // MARK: - Private Methods
  
  private func setup() {
    layer.addSublayer(ringLayer)
    layer.addSublayer(progressLayer)
  }
  
  private func updateColors() {
    guard let tint = tint else { return }
    backgroundColor = tint.backgroundColor
    progressLayer.fillColor = tint.foregroundColor.cgColor
    ringLayer.fillColor = tint.greyColor.cgColor
  }
  
  // update the ring layer
  private func updateRing() {
    ringLayer.path = self.ringPath(startAngle: 0, endAngle: 2.0 * Float.pi)
  }
  
  // update the progress layer
  private func updateProgress() {
    progressLayer.path = self.ringPath(startAngle: -Float.pi / 2, endAngle: 2 * Float.pi * (progress - 1 / 4))

    // animate (not working)
//    let morph = CABasicAnimation(keyPath:"path")
//    morph.duration = 0.1
//    morph.fromValue = self.progressLayer.path
//    morph.toValue = path.CGPath
//    progressLayer.addAnimation(morph, forKey: "morph")
  }
  
  private func ringPath(startAngle: Float, endAngle: Float) -> CGPath {
    let innerRadius = outerRadius - CGFloat(width)
    let start = CGFloat(startAngle)
    let end = CGFloat(endAngle)
    let path = UIBezierPath(arcCenter: ringCenter, radius: outerRadius, startAngle: start, endAngle: end, clockwise: true)
    path.addArc(withCenter: ringCenter, radius: innerRadius, startAngle: end, endAngle: start, clockwise: false)
    return path.cgPath
  }

}
