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
	var font: UIFont = UIFont.systemFontOfSize(14) {
		didSet { updateTitle() }
	}
	var progress: Float = 0 {
		didSet { updateProgress() }
	}
	var innerRadius: Float = 21 {
		didSet { setNeedsLayout() }
	}

	var color: UIColor = UIColor.redColor() {
		didSet { updateProgress() }
	}
	var ringColor: UIColor = UIColor(white: 0.9, alpha: 1) {
		didSet { updateProgress() }
	}
	var textColor: UIColor = UIColor.blackColor() {
		didSet { updateTitle() }
	}
	
	// background layer
	lazy private var ringLayer: CAShapeLayer = {
		let ringLayer = CAShapeLayer()
		ringLayer.contentsScale = UIScreen.mainScreen().scale
		self.layer.addSublayer(ringLayer)
		return ringLayer
	}()
	
	// progress layer
	lazy private var progressLayer: CAShapeLayer = {
		let progressLayer = CAShapeLayer()
		progressLayer.contentsScale = UIScreen.mainScreen().scale
		self.layer.addSublayer(progressLayer)
		return progressLayer
	}()

	// text layer
	lazy private var textLayer: CATextLayer = {
		let textLayer = CATextLayer()
		textLayer.contentsScale = UIScreen.mainScreen().scale
		self.layer.addSublayer(textLayer)
		return textLayer
	}()
	
	// update the ring layer
	private func updateRing() {
		let PI2 = 2 * CGFloat(M_PI)
		let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
		let radius = min(self.bounds.size.width, self.bounds.size.height) / 2;
		
		// render the background path
		let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: PI2, clockwise: true)
		path.addArcWithCenter(center, radius: CGFloat(innerRadius), startAngle: PI2, endAngle: 0, clockwise: false)
		ringLayer.fillColor = ringColor.CGColor
		ringLayer.path = path.CGPath
	}
	
	// update the progress layer
	private func updateProgress() {
		let PI2 = 2 * CGFloat(M_PI)
		let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
		let radius = min(self.bounds.size.width, self.bounds.size.height) / 2;
		let startAngle = CGFloat(-M_PI_2)
		let endAngle = startAngle + PI2 * CGFloat(progress);
		
		// render the progress path
		let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
		path.addArcWithCenter(center, radius: CGFloat(innerRadius), startAngle: endAngle, endAngle: startAngle, clockwise: false)
		progressLayer.fillColor = color.CGColor

		// animate (not working)
//		let morph = CABasicAnimation(keyPath:"path")
//		morph.duration = 0.1
//		morph.fromValue = self.progressLayer.path
//		morph.toValue = path.CGPath
//		progressLayer.addAnimation(morph, forKey: "morph")
		
		progressLayer.path = path.CGPath
	}
	
	// update the title layer
	private func updateTitle() {
		let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
		let size = title.sizeWithAttributes([NSFontAttributeName: font])
		textLayer.font = font
		textLayer.fontSize = font.pointSize
		textLayer.foregroundColor = textColor.CGColor
		textLayer.frame = CGRectMake(center.x - size.width / 2, center.y - size.height / 2, size.width, size.height)
		textLayer.string = title
	}
	
	override func layoutSubviews() {
		updateRing()
		updateProgress()
		updateTitle()
	}

}
