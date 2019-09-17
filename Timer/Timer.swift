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
	var currentTime: Int = 0 {
		didSet {
			if oldValue != currentTime {
				onTimeChange?(currentTime)
			}
		}
	}
	fileprivate (set) var currentRun: Int = 0 {
		didSet {
			if oldValue != currentRun {
				onRunChange?(currentRun)
			}
		}
	}
	fileprivate (set) var running: Bool = false
	
	var onTimeChange: ((Int) -> Void)?
	var onRunChange: ((Int) -> Void)?
	var onDone: (() -> Void)?
	
	fileprivate var startTime = 0
	fileprivate var startTS: Date?
	fileprivate var timer: Foundation.Timer?
	
	func suggestTitle() -> String {
		let minutes = time / 60
		let seconds = time - minutes * 60
		if (seconds == 0) {
			return minutes == 1 ? "1 minute" : "\(minutes) minutes"
		}
		if (minutes == 0) {
			return seconds == 1 ? "1 second" : "\(seconds) seconds"
		}
		let secString = (seconds < 10 ? "0" : "") + "\(seconds)"
		return "\(minutes):\(secString)"
	}
	
	func start() {
    stop()
		
		// disable the idle screen while the timer is running
		UIApplication.shared.isIdleTimerDisabled = true
		
		// remember the starting value and timestamp as basis for computing the current value
		startTime = currentTime + currentRun * time
		startTS = Date()
		
		// start the timer
		timer = Foundation.Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
		
		// schedule a local notification
		scheduleNotifications()
		
		running = true
	}
	
	func stop() {
    running = false

    // cancel a scheduled notification
    cancelNotifications()
  
    // stop the timer
    timer?.invalidate()
    timer = nil
  }
	
	func reset() {
		stop()
		currentRun = 0
		currentTime = 0
  }
	
	deinit {
    stop()
	}
    
	fileprivate func cancelNotifications() {
		UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
	}
	
	fileprivate func scheduleNotifications() {
		cancelNotifications()
		for i in 1...runs {
			let ts = i * time - startTime
			if ts > 0 {
				var text = "\(suggestTitle()) have passed"
				if (runs > 1) {
					text += " (\(i)/\(runs))"
				}
				let identifier = "run-\(i)"
				let triggerDate = startTS!.addingTimeInterval(TimeInterval(ts))
				let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
				let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
				let content = UNMutableNotificationContent()
				content.body = text
				content.sound = UNNotificationSound.default
				let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
				UNUserNotificationCenter.current().add(request) { (error) in
					// check error
				}
			}
		}
	}
	
	@objc fileprivate func tick() {
		// determine the passed time from the stored timestamp and startTime
		let passedTime = startTime - Int(startTS!.timeIntervalSinceNow)
		
		// determine the current run
		let run = min(runs, passedTime / time)
		
		// update the current run and time
		if (run < runs) {
			currentRun = run
			currentTime = passedTime - currentRun * time
		} else {
      currentTime = time
      stop()
      onDone?()
		}
	}

}
