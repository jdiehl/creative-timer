//
//  TimerView.swift
//  Timer
//
//  Created by Jonathan Diehl on 03.26.16.
//  Copyright © 2016 Jonathan Diehl. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {
	
	var title: String = "" {
		didSet { updateTitle() }
	}
	var font: UIFont = UIFont.systemFont(ofSize: 14) {
		didSet { updateTitle() }
	}
	var progress: Float = 0 {
		didSet { updateProgress() }
	}
	var innerRadius: Float = 18 {
		didSet { setNeedsLayout() }
	}

	// background layer
	lazy fileprivate var ringLayer: CAShapeLayer = {
		let ringLayer = CAShapeLayer()
		ringLayer.contentsScale = UIScreen.main.scale
		self.layer.addSublayer(ringLayer)
		return ringLayer
	}()
	
	// progress layer
	lazy fileprivate var progressLayer: CAShapeLayer = {
		let progressLayer = CAShapeLayer()
    progressLayer.opacity = 1
		progressLayer.contentsScale = UIScreen.main.scale
		self.layer.addSublayer(progressLayer)
		return progressLayer
	}()

	// text layer
	lazy fileprivate var textLayer: CATextLayer = {
		let textLayer = CATextLayer()
		textLayer.contentsScale = UIScreen.main.scale
		self.layer.addSublayer(textLayer)
		return textLayer
	}()
	
	// update the ring layer
	fileprivate func updateRing() {
		let PI2 = 2 * CGFloat(Double.pi)
		let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
		let radius = min(self.bounds.size.width, self.bounds.size.height) / 2;
		
		// color
		var ringColor: UIColor
		if #available(iOS 13, *) {
			ringColor = UIColor.systemGray6
		} else {
			ringColor = UIColor(white: 0.9, alpha: 1)
		}
		
		// render the background path
		let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: PI2, clockwise: true)
		path.addArc(withCenter: center, radius: CGFloat(innerRadius), startAngle: PI2, endAngle: 0, clockwise: false)
		ringLayer.fillColor = ringColor.cgColor
		ringLayer.path = path.cgPath
	}
	
	// update the progress layer
	fileprivate func updateProgress() {
		let PI2 = 2 * CGFloat(Double.pi)
		let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
		let radius = min(self.bounds.size.width, self.bounds.size.height) / 2;
		let startAngle = CGFloat(-Double.pi) / 2.0
		let endAngle = startAngle + PI2 * CGFloat(progress);
		
		// render the progress path
		let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
		path.addArc(withCenter: center, radius: CGFloat(innerRadius), startAngle: endAngle, endAngle: startAngle, clockwise: false)
		progressLayer.fillColor = UIColor.systemRed.cgColor

		// animate (not working)
//		let morph = CABasicAnimation(keyPath:"path")
//		morph.duration = 0.1
//		morph.fromValue = self.progressLayer.path
//		morph.toValue = path.CGPath
//		progressLayer.addAnimation(morph, forKey: "morph")
		progressLayer.path = path.cgPath
	}
	
	// update the title layer
	fileprivate func updateTitle() {
		let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
		let size = title.size(withAttributes: [NSAttributedString.Key.font: font])
		
		// color
		var textColor: UIColor
		if #available(iOS 13, *) {
			textColor = UIColor.label
		} else {
			textColor = UIColor.black
		}
		
		textLayer.font = font
		textLayer.fontSize = font.pointSize
		textLayer.foregroundColor = textColor.cgColor
		textLayer.frame = CGRect(x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height)
		textLayer.string = title
	}
	
	override func layoutSubviews() {
		updateRing()
		updateProgress()
		updateTitle()
	}

}
