//
//  PresetViewController.swift
//  Timer
//
//  Created by Jonathan Diehl on 30/03/16.
//  Copyright © 2016 Jonathan Diehl. All rights reserved.
//

import UIKit

func timeToComponents(time: Int) -> (Int, Int) {
	let minutes = time / 60
	let seconds = time - minutes * 60
	return (minutes, seconds)
}

func timeFromComponents(minutes: Int, seconds: Int) -> (Int) {
	return minutes * 60 + seconds
}

class PresetViewController: UIViewController, UITextFieldDelegate {
	
	private var presetManager = PresetManager.sharedManager
	var preset: Preset?
	
	@IBOutlet weak var titleInput: UITextField!
	@IBOutlet weak var minInput: UITextField!
	@IBOutlet weak var secInput: UITextField!
	@IBOutlet weak var runsInput: UITextField!
	
	func done() {
		view.endEditing(true)
		presetManager.activePreset = preset!
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func update() {
		let (minutes, seconds) = timeToComponents(preset!.time)
		titleInput.text = preset!.title
		minInput.text = "\(minutes)"
		secInput.text = "\(seconds)"
		runsInput.text = "\(preset!.runs)"
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		if preset == nil {
			let activePreset = presetManager.activePreset
			preset = Preset(title: "", time: activePreset.time, runs: activePreset.runs)
		}
		
		// ok button
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(done))
		
		// title
		self.title = "Edit Preset"
		
		update()
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		view.endEditing(true)

		// update presets
		if presetManager.presets.contains(preset!) {
			presetManager.savePresets()
		} else if preset!.title != "" {
			presetManager.presets.append(preset!)
			presetManager.savePresets()
		}
	}
	
    // MARK: - UITextFieldDelegate
	
	func textFieldDidEndEditing(textField: UITextField) {
		switch textField {
		case titleInput:
			preset!.title = titleInput.text!
			break
		case minInput:
			let minutes = min(max(Int(minInput.text!)!, 0), 90)
			preset!.time = timeFromComponents(minutes, seconds: Int(secInput.text!)!)
			break
		case secInput:
			let seconds = min(max(Int(secInput.text!)!, 0), 59)
			preset!.time = timeFromComponents(Int(minInput.text!)!, seconds: seconds)
			break
		case runsInput:
			preset!.runs = min(max(Int(runsInput.text!)!, 1), 8)
			break
		default:
			break
		}
		update()
	}
	
}
