//
//  RunsView.swift
//  Timer
//
//  Created by Jonathan Diehl on 03/04/16.
//  Copyright © 2016 Jonathan Diehl. All rights reserved.
//

import UIKit

class RunsView: UIView {
	
	var runViews: [CircularProgressView] = []
	
	func setRunsFromTimer(timer: Timer) {
		
		// remove previous views
		for runView in runViews {
			runView.removeFromSuperview()
		}
		runViews.removeAll()
		
		// do not show the runs unless there are at least 2
		if timer.runs < 2 {
			return
		}
		
		// add new views
		for run in 1...timer.runs {
			let runView = CircularProgressView(frame: CGRectZero)
			runView.title = "\(run)"
			self.addSubview(runView)
			runViews.append(runView)
		}
		
		setNeedsLayout()
	}

	override func layoutSubviews() {
		let runs = runViews.count
		let width = bounds.size.width
		let	distance = min(50, (width + 5) / 8)
		let offset = (width - (distance * CGFloat(runs) - 5)) / 2
		for (i, runView) in runViews.enumerate() {
			runView.frame = CGRectMake(offset + distance * CGFloat(i), 0, distance - 5, distance - 5)
//			runView.innerRadius = Float(distance) / 2 - 5
		}
	}

}