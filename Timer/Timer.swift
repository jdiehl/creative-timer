//
//  Timer.swift
//  Timer
//
//  Created by Jonathan Diehl on 03.26.16.
//  Copyright © 2016 Jonathan Diehl. All rights reserved.
//

import UIKit

class Timer: NSObject {
	
	var total: Int
	var value: Int = 0
	var onTick: ((value: Int) -> Void)?
	var running: Bool { return timer == nil }
	
	private var startTime: NSDate?
	private var timer: NSTimer?
	
	init(total: Int = 60, onTick: ((total: Int) -> Void)? = nil) {
		self.total = total
		self.onTick = onTick
	}
	
	func start() {
		stop()
		UIApplication.sharedApplication().idleTimerDisabled = true
		startTime = NSDate()
		timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
		scheduleNotification()
	}
	
	func stop() {
		timer?.invalidate()
		timer = nil
		UIApplication.sharedApplication().idleTimerDisabled = false
	}
	
	func reset() {
		value = 0
	}
	
	deinit {
		stop()
	}
	
	private func scheduleNotification() {
		let notification = UILocalNotification()
		notification.alertBody = "Timer expired"
		notification.alertAction = "view"
		notification.fireDate = startTime?.dateByAddingTimeInterval(NSTimeInterval(total))
		notification.soundName = UILocalNotificationDefaultSoundName
		notification.userInfo = nil
		UIApplication.sharedApplication().scheduleLocalNotification(notification)
	}
	
	@objc private func tick() {
		value = min(total, Int(-startTime!.timeIntervalSinceNow))
		if (value == total) {
			stop()
		}
		onTick?(value: value)
	}

}
