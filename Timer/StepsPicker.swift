//
//  StepsPicker.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 26.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

struct StepProgress {
  var step: Int
  var progress: Float
}

@objc protocol StepsPickerDelegate: AnyObject {
  func willChangeStep()
  func updateStep(to: Int)
  func didChangeStep(to: Int)
}

class StepsPicker: UIView {
  
  @IBOutlet weak var delegate: StepsPickerDelegate?
  
  // steps
  var program: Program? {
    didSet {
      updatePaths()
      updateColors()
    }
  }
  
  var index: Program.Index? {
    didSet { updateProgress() }
  }
  
  // the line layers
  lazy private var maskLayer = CAShapeLayer(fillColor: UIColor.black)
  lazy private var progressLayer = CAShapeLayer()
  lazy private var backgroundLayer = CAShapeLayer()
  
  // the marker layer
  lazy private var markerLayer = CAShapeLayer()
  lazy private var markerLabelLayer = CATextLayer(font: UIFont.systemFont(ofSize: 24, weight: .medium))
  
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
    let step = stepFor(touch: touches.first!)
    delegate?.updateStep(to: step)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard touches.count == 1 else { return }
    let step = stepFor(touch: touches.first!)
    delegate?.updateStep(to: step)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    let step = stepFor(touch: touches.first!)
    delegate?.updateStep(to: step)
  }
  // MARK: - Private Functions
  
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
    guard let index = index else { return }
    let x = positionFor(index: index)
    let rect = CGRect(x: bounds.minX, y: bounds.minY, width: x, height: bounds.height)
    maskLayer.path = CGPath(rect: rect, transform: nil)
    
    let point = CGPoint(x: x, y: bounds.midY)
    CALayer.performWithoutAnimation {
      markerLayer.position = point
      markerLabelLayer.position = point
      markerLabelLayer.string = String(index.step + 1)
    }
  }
  
  // update colors (called when colors change)
  private func updateColors() {
    guard let program = program else { return }
    backgroundColor = program.tint.backgroundColor
    backgroundLayer.fillColor = program.tint.greyColor.cgColor
    progressLayer.fillColor = program.tint.foregroundColor.cgColor
    markerLayer.fillColor = program.tint.foregroundColor.cgColor
    markerLabelLayer.foregroundColor = program.tint.backgroundColor.cgColor
  }
  
  // compute the position of the given index
  // used for drawing
  private func positionFor(index: Program.Index) -> CGFloat {
    return bounds.minX + 20 + CGFloat(index.progress) * (bounds.width - 40)
  }
  
  // compute the step for the given position
  // used for identifying which step to switch to on touch
  private func stepFor(position: CGFloat) -> Int {
    guard let program = program else { return 0 }
    let timeToPosition = (bounds.width - 40) / CGFloat(program.totalLength)
    let time = Int((position - 20 - bounds.minX) / timeToPosition)
    let index = program.indexFor(time: time)
    let step = index.time > program.steps[index.step].length / 2 ? index.step + 1 : index.step
    return min(program.steps.count - 1, step)
  }
  
  private func stepFor(touch: UITouch) -> Int {
    return stepFor(position: touch.location(in: self).x)
  }
  
  // create the path with dots for the line (used for the bg and the progress line / the latter with a mask)
  private func linePath() -> CGPath {
    let path = CGMutablePath()
    
    // base line
    let rect = CGRect(x: bounds.minX + 20, y: bounds.midY - 4, width: bounds.width - 40, height: 8)
    path.addRoundedRect(in: rect, cornerWidth: 4, cornerHeight: 4)
    guard let program = program else { return path }

    // steps
    let timeToPosition = (bounds.width - 40) / CGFloat(program.totalLength)
    var x = bounds.minX + 20 - 8
    for step in program.steps {
      let stepRect = CGRect(x: x, y: bounds.midY - 8, width: 16, height: 16)
      path.addEllipse(in: stepRect)
      x += timeToPosition * CGFloat(step.length)
    }
    return path
  }
  
}
