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

	@IBOutlet weak var runsView: UIView!
	@IBOutlet weak var progressView: CircularProgressView!
	@IBOutlet weak var resetButton: UIButton!
	@IBOutlet weak var playPauseButton: UIButton!
	@IBOutlet weak var presetsButton: UIButton!
	
	let timer = Timer()
	let presetManager = PresetManager.sharedManager
	var runViews: [CircularProgressView] = []
	
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
			if self.runViews.count > self.timer.currentRun {
				self.runViews[self.timer.currentRun].progress = progress
			}
			self.progressView.progress = progress
			self.progressView.title = formatTime(self.timer.time - currentTime)
		}
		
		// on run change
		timer.onRunChange = { currentRun in
			for (i, runView) in self.runViews.enumerate() {
				runView.progress = i < currentRun ? 1 : 0
			}
		}

		// configure the progress view
		progressView.font = UIFont.boldSystemFontOfSize(44)
		progressView.innerRadius = 66

		// apply the preset
		applyPreset(presetManager.activePreset)
	}
	
	override func viewWillLayoutSubviews() {
		setupRunViews()
	}
	
	func setupRunViews() {
		for runView in runViews {
			runView.removeFromSuperview()
		}
		runViews.removeAll()
		
		// do not show the runs unless there are at least 2
		if timer.runs < 2 {
			return
		}

		// arrange the views
		let width = self.runsView.bounds.size.width
		let	distance = min(50, (width + 5) / 8)
		let offset = (width - (distance * CGFloat(timer.runs) - 5)) / 2
		for run in 1...timer.runs {
			let i = CGFloat(run - 1)
			let frame = CGRectMake(offset + distance * i, 0, distance - 5, distance - 5)
			let runView = CircularProgressView(frame: frame)
			runView.innerRadius = Float(distance) / 2 - 5
			runView.title = "\(run)"
			self.runsView.addSubview(runView)
			runViews.append(runView)
		}
	}
	
	func applyPreset(preset: Preset) {
		timer.time = preset.time
		timer.runs = preset.runs
		progressView.title = formatTime(self.timer.time)
		setupRunViews()
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

