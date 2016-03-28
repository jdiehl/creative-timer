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
	
	let presetManager = PresetManager()
	let timer = Timer()
	
	private var myContext = 0
	
	override func viewDidLoad() {
		
		// play/pause icon
		timer.onStartStop = { running in
			let imageName = running ? "PauseButton" : "PlayButton"
			let image = UIImage(named: imageName)
			self.playPauseButton.setImage(image, forState: .Normal)
		}
		
		// on time change
		timer.onTimeChange = { time in
			self.timerView.value = time
		}
		
		super.viewDidLoad()
		applyPreset(presetManager.activePreset)
	}
	
	func applyPreset(preset: Preset) {
		timer.time = preset.time
		timer.runs = preset.runs
		timerView.total = timer.time
		reset()
	}
	
	@IBAction func reset(sender: AnyObject? = nil) {
		timer.reset()
	}

	@IBAction func playPause(sender: AnyObject) {
		if (timer.running) {
			timer.stop()
		} else {
			timer.start()
		}
	}

	@IBAction func settings(sender: UIView) {
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
		for preset in presetManager.presets {
			alert.addAction(UIAlertAction(title: String(preset.title), style: .Default, handler: { style in
				self.presetManager.activePreset = preset
				self.applyPreset(preset)
			}))
		}
		alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
		alert.popoverPresentationController?.sourceView = sender
		self.presentViewController(alert, animated: true, completion: nil)
	}
}

