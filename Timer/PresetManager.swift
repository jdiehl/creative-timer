//
//  PresetManager.swift
//  Timer
//
//  Created by Jonathan Diehl on 03.28.16.
//  Copyright © 2016 Jonathan Diehl. All rights reserved.
//

import UIKit

class PresetManager: NSObject {
	
	static let sharedManager = PresetManager()
	
	var onChange: ((Preset) -> Void)?

	private let defaults = NSUserDefaults()
	private var _activePreset: Preset
	
	var presets: [Preset]

	// set active preset
	var activePreset: Preset {
		get {
			return _activePreset
		}
		set {
			_activePreset = newValue
			defaults.setObject(_activePreset.info(), forKey: "activePreset")
			onChange?(_activePreset)
		}
	}
	
	func savePresets() {
		defaults.setObject(presets.map { $0.info() }, forKey: "presets")
	}
	
	override init() {
		
		// register defaults
		let defaultPresets = [
			["title": "5 minutes",  "time": 5*60,  "runs": 1],
			["title": "10 minutes", "time": 10*60, "runs": 1],
			["title": "15 minutes", "time": 15*60, "runs": 1],
			["title": "20 minutes", "time": 20*60, "runs": 1],
			["title": "Crazy Eight", "time": 40, "runs": 8]
		]
		NSUserDefaults().registerDefaults([
			"presets": defaultPresets,
			"activePreset": defaultPresets[0]
		])
		
		// load presets
		let infos = defaults.objectForKey("presets") as! [[String: AnyObject]]
		presets = infos.map { Preset(info: $0) }

		// load active preset
		let info = defaults.objectForKey("activePreset") as! [String: AnyObject]
		_activePreset = Preset(info: info)
	}

}
