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
		didSet { updateProgress() }
	}
	var color: UIColor = UIColor.redColor() {
		didSet { updateProgress() }
	}
	
	private let shapeLayer: CAShapeLayer = CAShapeLayer()
	private let textLayer: CATextLayer = CATextLayer()
	
	override func awakeFromNib() {
		let contentScale = UIScreen.mainScreen().scale
		
		// set up shape layer
		shapeLayer.contentsScale = contentScale
		layer.addSublayer(shapeLayer)

		// set up text layer
		textLayer.contentsScale = contentScale
		textLayer.foregroundColor = UIColor.blackColor().CGColor
		textLayer.backgroundColor = UIColor.whiteColor().CGColor
		layer.addSublayer(textLayer)
	}
	
	private func updateProgress() {
		let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
		let radius = min(self.bounds.size.width, self.bounds.size.height) / 2;
		let startAngle = CGFloat(-M_PI_2)
		let endAngle = startAngle + 2 * CGFloat(M_PI) * CGFloat(progress);
		
		// construct the path
		let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
		path.addArcWithCenter(center, radius: CGFloat(innerRadius), startAngle: endAngle, endAngle: startAngle, clockwise: false)
		
		// update the shapelayer
		shapeLayer.fillColor = color.CGColor
		shapeLayer.path = path.CGPath
	}
	
	private func updateTitle() {
		let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
		let size = title.sizeWithAttributes([NSFontAttributeName: font])
		textLayer.font = font
		textLayer.fontSize = font.pointSize
		textLayer.frame = CGRectMake(center.x - size.width / 2, center.y - size.height / 2, size.width, size.height)
		textLayer.string = title
	}
	
	override func layoutSubviews() {
		updateProgress()
		updateTitle()
	}

}
