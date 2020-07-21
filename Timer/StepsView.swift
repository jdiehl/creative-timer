//
//  StepsView.swift
//  Timer
//
//  Created by Jonathan Diehl on 19.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

struct StepProgress {
  var step: Int
  var progress: Float
}

@objc protocol StepsViewDelegate: AnyObject {
  func willChangeStep()
  func updateStep(to: Int)
  func didChangeStep(to: Int)
}

class StepsView: UIView {
  
  @IBOutlet weak var delegate: StepsViewDelegate?
  
  // steps
  var steps: [Program.Step] = [] {
    didSet { updatePaths() }
  }
  
  var progress: StepProgress = StepProgress(step: 0, progress: 0) {
    didSet { updateProgress() }
  }
  
  // the line layers
  lazy private var maskLayer = CAShapeLayer(fillColor: UIColor.black)
  lazy private var progressLayer = CAShapeLayer()
  lazy private var backgroundLayer = CAShapeLayer()
  
  // the marker layer
  lazy private var markerLayer = CAShapeLayer()
  lazy private var markerLabelLayer = CATextLayer(font: UIFont.systemFont(ofSize: 24, weight: .medium))
  
  private var stepWidth: CGFloat { (bounds.width - 40) / CGFloat(max(steps.count, 1)) }
    
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
    updatePaths()
    updateProgress()
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    updateColors()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard touches.count == 1 else { return }
    delegate?.willChangeStep()
    set(point: touches.first!.location(in: self))
    delegate?.updateStep(to: progress.step)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard touches.count == 1 else { return }
    set(point: touches.first!.location(in: self))
    delegate?.updateStep(to: progress.step)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    delegate?.didChangeStep(to: progress.step)
  }
  // MARK: - Private Functions
  
  private func set(point: CGPoint) {
    let a = (point.x - bounds.minX) / bounds.width
    progress.step = min(steps.count - 1, Int(CGFloat(steps.count + 1) * a))
  }
  
  // set up all layers once after initializing
  private func setup() {
    progressLayer.mask = maskLayer
    layer.addSublayer(backgroundLayer)
    layer.addSublayer(progressLayer)
    layer.addSublayer(markerLayer)
    layer.addSublayer(markerLabelLayer)
    setupMarker()
    updatePaths()
    updateProgress()
    TintManager.shared.on(.tintChanged) { self.updateColors() }
    updateColors()
  }
  
  // set up the marker (called from setupLayers)
  private func setupMarker() {
    markerLayer.path = CGPath(ellipseIn: CGRect(x: -20, y: -20, width: 40, height: 40), transform: nil)
    let lineHeight = markerLabelLayer.font!.lineHeight!
    markerLabelLayer.alignmentMode = .center
    markerLabelLayer.frame = CGRect(x: -20, y: lineHeight / 2, width: 40, height: lineHeight)
  }
  
  // update paths (called from setup and layout)
  private func updatePaths() {
    let path = linePath()
    backgroundLayer.path = path
    progressLayer.path = path
  }
  
  // update progress (called also from changing progress
  private func updateProgress() {
    let x = 20 + CGFloat(Float(progress.step) + progress.progress) * stepWidth
    let rect = CGRect(x: bounds.minX, y: bounds.minY, width: x, height: bounds.height)
    maskLayer.path = CGPath(rect: rect, transform: nil)
    
    let point = CGPoint(x: x, y: bounds.midY)
    CALayer.performWithoutAnimation {
      markerLayer.position = point
      markerLabelLayer.position = point
      markerLabelLayer.string = String(progress.step + 1)
    }
  }
  
  // update colors (called when colors change)
  private func updateColors() {
    backgroundColor = TintManager.shared.backgroundColor
    backgroundLayer.fillColor = TintManager.shared.greyColor.cgColor
    progressLayer.fillColor = TintManager.shared.color.cgColor
    markerLayer.fillColor = TintManager.shared.color.cgColor
    markerLabelLayer.foregroundColor = TintManager.shared.backgroundColor.cgColor
  }
  
  // create the path with dots for the line (used for the bg and the progress line / the latter with a mask)
  private func linePath() -> CGPath {
    let path = CGMutablePath()
    
    // base line
    let rect = CGRect(x: bounds.minX + 20, y: bounds.midY - 4, width: bounds.width - 40, height: 8)
    path.addRoundedRect(in: rect, cornerWidth: 4, cornerHeight: 4)
    
    // steps
    for i in 0..<steps.count {
      let stepRect = CGRect(x: bounds.minX + 12 + CGFloat(i) * stepWidth, y: bounds.midY - 8, width: 16, height: 16)
      path.addEllipse(in: stepRect)
    }
    return path
  }
  
}
