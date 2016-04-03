//
//  ViewController.swift
//  Timer
//
//  Created by Jonathan Diehl on 03.26.16.
//  Copyright © 2016 Jonathan Diehl. All rights reserved.
//

import UIKit

// helper
func formatTime(time: Int) -> String {
	if (time > 60) {
		return "\(time / 60)'"
	}
	return "\(time)\""
}

class TimerViewController: UIViewController {

	@IBOutlet weak var runsView: RunsView!
	@IBOutlet weak var progressView: CircularProgressView!
	@IBOutlet weak var resetButton: UIButton!
	@IBOutlet weak var playPauseButton: UIButton!
	@IBOutlet weak var presetsButton: UIButton!
	
	let timer = Timer()
	let presetManager = PresetManager.sharedManager
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// preset change
		presetManager.onChange = { preset in
			self.applyPreset(preset)
		}
		
		// play/pause icon
		timer.onStartStop = { running in
			let imageName = running ? "PauseButton" : "PlayButton"
			let image = UIImage(named: imageName)
			self.playPauseButton.setImage(image, forState: .Normal)
		}
		
		// on time change
		timer.onTimeChange = { currentTime in
			let progress = Float(currentTime) / Float(self.timer.time)
			if self.runsView.runViews.count > self.timer.currentRun {
				self.runsView.runViews[self.timer.currentRun].progress = progress
			}
			self.progressView.progress = progress
			self.progressView.title = formatTime(self.timer.time - currentTime)
		}
		
		// on run change
		timer.onRunChange = { currentRun in
			for (i, runView) in self.runsView.runViews.enumerate() {
				runView.progress = i < currentRun ? 1 : 0
			}
		}

		// configure the progress view
		progressView.font = UIFont.boldSystemFontOfSize(44)
		progressView.innerRadius = 66

		// apply the preset
		applyPreset(presetManager.activePreset)
	}
	
	func applyPreset(preset: Preset) {
		timer.time = preset.time
		timer.runs = preset.runs
		progressView.title = formatTime(timer.time)
		runsView.setRunsFromTimer(timer)
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

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let navigationController = segue.destinationViewController as! UINavigationController
		let viewController = navigationController.viewControllers[0] as! PresetTableViewController
		viewController.popoverPresentationController?.sourceRect = resetButton.bounds
	}
	
	@IBAction func settings(sender: UIView) {
		self.performSegueWithIdentifier("showPresets", sender: sender)
//		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
//		for preset in presetManager.presets {
//			alert.addAction(UIAlertAction(title: String(preset.title), style: .Default, handler: { style in
//				self.presetManager.activePreset = preset
//				self.applyPreset(preset)
//			}))
//		}
//		alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
//		alert.popoverPresentationController?.sourceView = sender
//		alert.popoverPresentationController?.sourceRect = sender.bounds
//		self.presentViewController(alert, animated: true, completion: nil)
	}
	
}

