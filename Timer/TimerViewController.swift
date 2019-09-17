//
//  ViewController.swift
//  Timer
//
//  Created by Jonathan Diehl on 03.26.16.
//  Copyright © 2016 Jonathan Diehl. All rights reserved.
//

import UIKit
import AudioToolbox

// helper
func formatTime(_ seconds: Int) -> String {
	if (seconds > 60) {
    let minutes = (seconds - 1) / 60 + 1
		return "\(minutes)'"
	}
	return "\(seconds)\""
}

enum PlayPauseState: String {
    case play = "PlayButton"
    case pause = "PauseButton"
}

class TimerViewController: UIViewController {

	@IBOutlet weak var runsView: RunsView!
	@IBOutlet weak var progressView: CircularProgressView!
	@IBOutlet weak var resetButton: UIButton!
	@IBOutlet weak var playPauseButton: UIButton!
	@IBOutlet weak var presetsButton: UIButton!
	
	let timer = Timer()
	let presetManager = PresetManager.sharedManager
  var doneTimer: Foundation.Timer?
  var done = false
  var timeSetGestureRecognizer: TimeSetGestureRecognizer?
    
  @objc func setTime() {
    if let angle = self.timeSetGestureRecognizer?.angle {
      timer.currentTime = Int(round(CGFloat(self.timer.time) * angle))
      done = false
    }
    
  }
  
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// preset change
		presetManager.onChange = { preset in
			self.applyPreset(preset)
		}
		
    timer.onDone = {
      if self.presetManager.soundsEnabled {
        AudioServicesPlaySystemSound(1013);
      }
      self.setPlayPause(state: .play)
      self.showTimerDone()
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
			for (i, runView) in self.runsView.runViews.enumerated() {
				runView.progress = i < currentRun ? 1 : 0
			}
			if self.presetManager.soundsEnabled {
				AudioServicesPlaySystemSound(1013);
			}
		}

		// configure the progress view
		progressView.font = UIFont.boldSystemFont(ofSize: 44)
		progressView.innerRadius = 66

		// apply the preset
		applyPreset(presetManager.activePreset)
    
    // install set time gesture recognizer
    self.timeSetGestureRecognizer = TimeSetGestureRecognizer(target: self, action: #selector(setTime))
    
    var shouldResume = false
    self.timeSetGestureRecognizer!.onStart = {
      shouldResume = self.timer.running
      self.pause()
    }
    self.timeSetGestureRecognizer!.onFinish = {
      if shouldResume {
        self.play()
      }
    }
    self.progressView.addGestureRecognizer(self.timeSetGestureRecognizer!)
	}
	
	func applyPreset(_ preset: Preset) {
		timer.time = preset.time
		timer.runs = preset.runs
		progressView.title = formatTime(timer.time)
		runsView.setRunsFromTimer(timer)
		reset()
	}
	
	@IBAction func reset(_ sender: AnyObject? = nil) {
    if (done) {
      done = false
      timeDoneFinished()
    }
    setPlayPause(state: .play)
    timer.reset()
	}
  
  func pause() {
    timer.stop()
    UIApplication.shared.isIdleTimerDisabled = false
    setPlayPause(state: .play)
  }
  
  func play() {
    timer.start()
    UIApplication.shared.isIdleTimerDisabled = true
    setPlayPause(state: .pause)
  }

	@IBAction func playPause(_ sender: AnyObject) {
    if (done) {
      reset()
    }
		if (timer.running) {
      self.pause()
		} else {
      self.play()
		}
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let navigationController = segue.destination as! UINavigationController
		let viewController = navigationController.viewControllers[0] as! PresetTableViewController
		viewController.popoverPresentationController?.sourceRect = resetButton.bounds
	}
	
	@IBAction func settings(_ sender: UIView) {
		self.performSegue(withIdentifier: "showPresets", sender: sender)
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
	
    fileprivate func setPlayPause(state: PlayPauseState) {
        let image = UIImage(named: state.rawValue)
        self.playPauseButton.setImage(image, for: UIControl.State())
    }
    
    fileprivate func showTimerDone() {
        done = true
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut, .repeat, .autoreverse, .allowUserInteraction], animations: { self.progressView.alpha = 0.0 }, completion: nil)
        doneTimer?.invalidate()
        doneTimer = Foundation.Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timeDoneFinished), userInfo: nil, repeats: false)
    }
    
    @objc fileprivate func timeDoneFinished() {
        self.progressView.layer.removeAllAnimations()
        self.progressView.alpha = 1.0
        UIApplication.shared.isIdleTimerDisabled = false
        doneTimer?.invalidate()
        doneTimer = nil
    }
    
}

