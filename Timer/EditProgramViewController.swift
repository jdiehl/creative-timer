//
//  PresetViewController.swift
//  Timer
//
//  Created by Jonathan Diehl on 30/03/16.
//  Copyright © 2016 Jonathan Diehl. All rights reserved.
//

import UIKit

func timeToComponents(_ time: Int) -> (Int, Int) {
  let minutes = time / 60
  let seconds = time - minutes * 60
  return (minutes, seconds)
}

func timeFromComponents(_ minutes: Int, seconds: Int) -> (Int) {
  return minutes * 60 + seconds
}

class EditProgramViewController: UIViewController, UITextFieldDelegate {
	
	let programManager = ProgramManager.shared
	var program: Program?
	
	@IBOutlet weak var titleInput: UITextField!
	@IBOutlet weak var minInput: UITextField!
	@IBOutlet weak var secInput: UITextField!
	@IBOutlet weak var runsInput: UITextField!
	
	@objc func done() {
		view.endEditing(true)
		programManager.activeProgram = program!
		dismiss(animated: true, completion: nil)
	}
	
	func update() {
    titleInput.text = program!.title
//		let (minutes, seconds) = timeToComponents(program!.time)
//		minInput.text = "\(minutes)"
//		secInput.text = "\(seconds)"
//		runsInput.text = "\(preset!.runs)"
	}

  override func viewDidLoad() {
    super.viewDidLoad()
		if program == nil {
      program = programManager.activeProgram
		}
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
		update()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
//		view.endEditing(true)
//
//		// update presets
//		if presetManager.presets.contains(preset!) {
//			presetManager.savePresets()
//		} else if preset!.title != "" {
//			presetManager.presets.append(preset!)
//			presetManager.savePresets()
//		}
	}
	
    // MARK: - UITextFieldDelegate
	
//	func textFieldDidEndEditing(_ textField: UITextField) {
//		switch textField {
//		case titleInput:
//			preset!.title = titleInput.text!
//			break
//		case minInput:
//			let minutes = min(max(Int(minInput.text!)!, 0), 90)
//			preset!.time = timeFromComponents(minutes, seconds: Int(secInput.text!)!)
//			break
//		case secInput:
//			let seconds = min(max(Int(secInput.text!)!, 0), 59)
//			preset!.time = timeFromComponents(Int(minInput.text!)!, seconds: seconds)
//			break
//		case runsInput:
//			preset!.runs = min(max(Int(runsInput.text!)!, 1), 16)
//			break
//		default:
//			break
//		}
//		update()
//	}
	
}
