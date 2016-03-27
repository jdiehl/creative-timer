//
//  ViewController.swift
//  Timer
//
//  Created by Jonathan Diehl on 03.26.16.
//  Copyright © 2016 Jonathan Diehl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var timerView: TimerView!
	@IBOutlet weak var playPauseButton: UIButton!
	
	var timer = Timer(total: 5)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// set up timer
		timerView.total = timer.total
		timer.onTick = { value in
			self.timerView.value = value
			
			// reset the view if we have reached the total value
			if (value == self.timer.total) {
				self.reset(nil)
			}
		}
	}
	
	func updatePlayPauseButton() {
		let imageName = timer.running ? "PauseButton" : "PlayButton"
		let image = UIImage(named: imageName)
		playPauseButton.setImage(image, forState: .Normal)
	}
	
	@IBAction func reset(sender: AnyObject?) {
		timer.reset()
		self.timerView.value = self.timer.value
		updatePlayPauseButton()
	}

	@IBAction func playPause(sender: AnyObject) {
		if (timer.running) {
			timer.stop()
		} else {
			timer.start()
		}
		updatePlayPauseButton()
	}

	@IBAction func settings(sender: AnyObject) {
		// todo
	}
}

