//
//  Timer.swift
//  Timer
//
//  Created by Jonathan Diehl on 03.26.16.
//  Copyright © 2016 Jonathan Diehl. All rights reserved.
//

import UIKit

class Timer: NSObject {
	
	var time: Int = 300
	var runs: Int = 1
	private (set) var currentTime: Int = 0 {
		didSet {
			if oldValue != currentTime {
				onTimeChange?(currentTime)
			}
		}
	}
	private (set) var currentRun: Int = 0 {
		didSet {
			if oldValue != currentRun {
				onRunChange?(currentRun)
			}
		}
	}
	private (set) var running: Bool = false {
		didSet {
			if oldValue != running {
				onStartStop?(running)
			}
		}
	}
	
	var onTimeChange: ((Int) -> Void)?
	var onRunChange: ((Int) -> Void)?
	var onStartStop: ((Bool) -> Void)?
	
	private var startTime = 0
	private var startTS: NSDate?
	private var timer: NSTimer?
	
	private var notifications: [UILocalNotification] = []
	
	func start() {
		stop()
		
		// disable the idle screen while the timer is running
		UIApplication.sharedApplication().idleTimerDisabled = true
		
		// remember the starting value and timestamp as basis for computing the current value
		startTime = currentTime + currentRun * time
		startTS = NSDate()
		
		// start the timer
		timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
		
		// schedule a local notification
		scheduleNotifications()
		
		running = true
	}
	
	func stop() {
		
		// cancel a scheduled notification
		cancelNotifications()
		
		// stop the timer
		timer?.invalidate()
		timer = nil
		
		// re-enable the idle screen timer
		UIApplication.sharedApplication().idleTimerDisabled = false
		
		running = false
	}
	
	func reset() {
		stop()
		currentTime = 0
		currentRun = 0
	}
	
	deinit {
		stop()
	}
	
	private func cancelNotifications() {
		for notification in notifications {
			// only cancel the notification if it hasn't fired
			if notification.fireDate!.timeIntervalSinceNow > 0 {
				UIApplication.sharedApplication().cancelLocalNotification(notification)
			}
		}
		notifications = []
	}
	
	private func scheduleNotifications() {
		cancelNotifications()
		for i in 1...runs {
			let ts = i * time - startTime
			if ts > 0 {
				let notification = UILocalNotification()
				notification.alertBody = "Time expired"
				notification.alertAction = "view"
				notification.soundName = UILocalNotificationDefaultSoundName
				notification.fireDate = startTS?.dateByAddingTimeInterval(NSTimeInterval(ts))
				UIApplication.sharedApplication().scheduleLocalNotification(notification)
				notifications.append(notification)
			}
		}
	}
	
	@objc private func tick() {
		// determine the passed time from the stored timestamp and startTime
		let passedTime = startTime - Int(startTS!.timeIntervalSinceNow)
		
		// determine the current run
		currentRun = min(runs, passedTime / time)
		
		// if we exceeded the number of runs we planned, we are done
		if (currentRun >= runs) {
			return reset()
		}
		
		// update the current time
		currentTime = passedTime - currentRun * time
	}

}
