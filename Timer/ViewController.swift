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

class ViewController: UIViewController, UICollectionViewDataSource {

	@IBOutlet weak var progressView: CircularProgressView!
	@IBOutlet weak var playPauseButton: UIButton!
	@IBOutlet weak var runsView: UICollectionView!
	
	let timer = Timer()
	let presetManager = PresetManager()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// play/pause icon
		timer.onStartStop = { running in
			let imageName = running ? "PauseButton" : "PlayButton"
			let image = UIImage(named: imageName)
			self.playPauseButton.setImage(image, forState: .Normal)
		}
		
		// on time change
		timer.onTimeChange = { currentTime in
			if currentTime == 0 {
				self.progressView.progress = 1.0
				self.progressView.title = formatTime(self.timer.time)
			} else {
				self.progressView.progress = Float(currentTime) / Float(self.timer.time)
				self.progressView.title = formatTime(currentTime)
			}
		}

		// apply the preset
		applyPreset(presetManager.activePreset)

		// configure the progress view
		progressView.font = UIFont.boldSystemFontOfSize(44)
		progressView.innerRadius = 66
		progressView.progress = 1
		progressView.title = formatTime(self.timer.time)
	}
	
	func applyPreset(preset: Preset) {
		timer.time = preset.time
		timer.runs = preset.runs
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
	
	// UICollectionViewDataSource
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return timer.runs > 1 ? timer.runs : 0
	}
	
	// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let view = self.runsView.dequeueReusableCellWithReuseIdentifier("run", forIndexPath: indexPath) as! RunViewCell
		view.run = indexPath.row + 1
		return view
	}

}

