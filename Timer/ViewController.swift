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
	
	let timer = Timer()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// set up timer
		timer.total = NSUserDefaults().integerForKey("total")
		timerView.total = timer.total
		timer.onTick = { value in
			self.timerView.value = value
			
			// reset the view if we have reached the total value
			if (value == self.timer.total) {
				self.reset()
			}
		}
	}
	
	func setTotal(total: Int) {
		NSUserDefaults().setInteger(total, forKey: "total")
		timer.total = total
		timerView.total = total
		reset()
	}
	
	func updatePlayPauseButton() {
		let imageName = timer.running ? "PauseButton" : "PlayButton"
		let image = UIImage(named: imageName)
		playPauseButton.setImage(image, forState: .Normal)
	}
	
	@IBAction func reset(sender: AnyObject? = nil) {
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

	@IBAction func settings(sender: UIView) {
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
		alert.addAction(UIAlertAction(title: "5 minutes", style: .Default, handler: { style in
			self.setTotal(5*60)
		}))
		alert.addAction(UIAlertAction(title: "10 minutes", style: .Default, handler: { style in
			self.setTotal(10*60)
		}))
		alert.addAction(UIAlertAction(title: "15 minutes", style: .Default, handler: { style in
			self.setTotal(15*60)
		}))
		alert.addAction(UIAlertAction(title: "20 minutes", style: .Default, handler: { style in
			self.setTotal(20*60)
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
		alert.popoverPresentationController?.sourceView = sender
		self.presentViewController(alert, animated: true, completion: nil)
	}
}

