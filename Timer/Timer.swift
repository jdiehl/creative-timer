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
	var running: Bool { return timer != nil }
	
	private var startValue = 0
	private var startTime: NSDate?
	private var timer: NSTimer?
	
	private var notification: UILocalNotification?
	
	init(total: Int = 60, onTick: ((total: Int) -> Void)? = nil) {
		self.total = total
		self.onTick = onTick
	}
	
	func start() {
		stop()
		
		// disable the idle screen while the timer is running
		UIApplication.sharedApplication().idleTimerDisabled = true
		
		// remember the starting value and timestamp as basis for computing the current value
		startValue = value
		startTime = NSDate()
		
		// start the timer
		timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
		
		// schedule a local notification
		scheduleNotification()
	}
	
	func stop() {
		
		// cancel a scheduled notification
		cancelNotification()
		
		// stop the timer
		timer?.invalidate()
		timer = nil
		
		// re-enable the idle screen timer
		UIApplication.sharedApplication().idleTimerDisabled = false
	}
	
	func reset() {
		stop()
		value = 0
	}
	
	deinit {
		stop()
	}
	
	private func cancelNotification() {
		if (notification != nil) {
			// only cancel the notification if it hasn't fired
			if (notification!.fireDate!.timeIntervalSinceNow > 0) {
				UIApplication.sharedApplication().cancelLocalNotification(notification!)
			}
			notification = nil
		}
	}
	
	private func scheduleNotification() {
		cancelNotification()
		notification = UILocalNotification()
		notification!.alertBody = "Time expired"
		notification!.alertAction = "view"
		notification!.fireDate = startTime?.dateByAddingTimeInterval(NSTimeInterval(total - startValue))
		notification!.soundName = UILocalNotificationDefaultSoundName
		notification!.userInfo = nil
		UIApplication.sharedApplication().scheduleLocalNotification(notification!)
	}
	
	@objc private func tick() {
		// determine the value from the time interval and startValue
		// the value can never be more than total
		value = min(total, startValue - Int(startTime!.timeIntervalSinceNow))
		
		// if we have reached total: stop the timer
		if (value == total) {
			stop()
		}
		onTick?(value: value)
	}

}
