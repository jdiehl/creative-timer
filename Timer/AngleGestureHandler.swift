//
//  TimeSetGestureHandler.swift
//  Timer
//
//  Created by Jonathan Diehl on 12.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

protocol AngleGestureHandlerDelegate: AnyObject {
  func angleGestureBegan(handler: AngleGestureHandler)
  func angleGestureEnded(handler: AngleGestureHandler)
  func angleGestureUpdated(handler: AngleGestureHandler, angle: CGFloat)
}

class AngleGestureHandler {
  let view: UIView
  weak var delegate: AngleGestureHandlerDelegate?
  var wasRunning: Bool?

  private var angleRecognizer: AngleGestureRecognizer?

  init(view: UIView) {
    self.view = view
  }

  convenience init(view: UIView, delegate: AngleGestureHandlerDelegate) {
    self.init(view: view)
    self.delegate = delegate
  }

  func start() {
    let angleRecognizer = AngleGestureRecognizer(target: self, action: #selector(onUpdate))
    angleRecognizer.onStart = {
      self.delegate?.angleGestureBegan(handler: self)
    }
    angleRecognizer.onFinish = {
      self.delegate?.angleGestureEnded(handler: self)
    }
    view.addGestureRecognizer(angleRecognizer)
    self.angleRecognizer = angleRecognizer
  }
  
  func stop() {
    guard let angleRecognizer = self.angleRecognizer else { return }
    self.view.removeGestureRecognizer(angleRecognizer)
    self.angleRecognizer = nil
  }
  
  deinit {
    stop()
  }
  
  @objc private func onUpdate() {
    guard let angle = self.angleRecognizer?.angle else { return }
    self.delegate?.angleGestureUpdated(handler: self, angle: angle)
  }

}
