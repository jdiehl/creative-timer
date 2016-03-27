//
//  TimerView.swift
//  Timer
//
//  Created by Jonathan Diehl on 03.26.16.
//  Copyright © 2016 Jonathan Diehl. All rights reserved.
//

import UIKit

class TimerView: UIView {
	
	var total: Int = 60 {
		didSet { setNeedsLayout() }
	}
	var value: Int = 0 {
		didSet { setNeedsLayout() }
	}
	var color: UIColor = UIColor.redColor() {
		didSet { setNeedsLayout() }
	}
	
	private let shapeLayer: CAShapeLayer = CAShapeLayer()
	private let textLayer: CATextLayer = CATextLayer()
	private let textFont = UIFont.boldSystemFontOfSize(22)
	
	override func awakeFromNib() {
		let contentScale = UIScreen.mainScreen().scale
		
		// set up shape layer
		shapeLayer.contentsScale = contentScale
		layer.addSublayer(shapeLayer)

		// set up text layer
		textLayer.contentsScale = contentScale
		textLayer.font = textFont
		textLayer.fontSize = textFont.pointSize
		textLayer.foregroundColor = UIColor.blackColor().CGColor
		textLayer.backgroundColor = UIColor.whiteColor().CGColor
		layer.addSublayer(textLayer)
	}
	
	override func layoutSubviews() {

		// compute the require points
		let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
		let radius = min(self.bounds.size.width, self.bounds.size.height) / 2;
		let startAngle = CGFloat(-M_PI_2)
		let endAngle = startAngle + 2 * CGFloat(M_PI) / CGFloat(total) * CGFloat(value == 0 ? total : value);
		
		// construct the path
		let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
		path.addArcWithCenter(center, radius: 30, startAngle: endAngle, endAngle: startAngle, clockwise: false)
		
		// update the shapelayer
		shapeLayer.fillColor = color.CGColor
		shapeLayer.path = path.CGPath
		
		// set label
		let remainingTime = value < total ? total - value : total
		let text: NSString = remainingTime < 60 ? "\(remainingTime)\"" : "\(remainingTime / 60)'"
		let textSize = text.sizeWithAttributes([NSFontAttributeName: textFont])
		textLayer.frame = CGRectMake(center.x - textSize.width / 2, center.y - textSize.height / 2, textSize.width, textSize.height)
		textLayer.string = text
	}

}
