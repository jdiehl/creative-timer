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
  lazy private var maskLayer = CAShapeLayer(fillColor: UIColor.black).addTo(layer)
  lazy private var progressLayer = StepsLayer().addTo(layer)
  lazy private var backgroundLayer = StepsLayer().addTo(layer)
  
  // the marker layer
  lazy private var markerView = MarkerView().addTo(self)
  
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
    updatePaths()
    updateProgress()
    updateColors()
    progressLayer.mask = maskLayer
  }
  
  // update paths (called from setup and layout)
  private func updatePaths() {
    backgroundLayer.set(program: program, bounds: bounds)
    progressLayer.set(program: program, bounds: bounds)
  }
  
  // update progress (called also from changing progress
  private func updateProgress() {
    guard let index = index else { return }
    let x = positionFor(index: index)
    let rect = CGRect(x: bounds.minX, y: bounds.minY, width: x, height: bounds.height)
    maskLayer.path = CGPath(rect: rect, transform: nil)
    
    let point = CGPoint(x: x, y: bounds.midY)
    markerView.center = point
    markerView.set(label: String(index.step + 1))
  }
  
  // update colors (called when colors change)
  private func updateColors() {
    guard let program = program else { return }
    backgroundColor = program.tint.backgroundColor
    backgroundLayer.fillColor = program.tint.greyColor.cgColor
    progressLayer.fillColor = program.tint.foregroundColor.cgColor
    markerView.set(tint: program.tint)
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
    
    // get the index for the position
    let timeToPosition = (bounds.width - 40) / CGFloat(program.totalLength)
    let time = Int((position - 20 - bounds.minX) / timeToPosition)
    let index = program.indexFor(time: time)
    
    // if this is the last step, return it
    if index.step == program.steps.count - 1 { return index.step }
    
    // determine the index for this and the next step
    let a = positionFor(index: program.indexFor(step: index.step, stepTime: 0))
    let b = positionFor(index: program.indexFor(step: index.step + 1, stepTime: 0))
    
    // return the step closer to the position
    return abs(position - a) < abs(position - b) ? index.step : index.step + 1
  }
  
  private func stepFor(touch: UITouch) -> Int {
    return stepFor(position: touch.location(in: self).x)
  }

}
