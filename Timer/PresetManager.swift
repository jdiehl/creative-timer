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

	fileprivate let defaults = UserDefaults()
	fileprivate var _activePreset: Preset
	fileprivate var _soundsEnabled: Bool
	
	var presets: [Preset]
	
	var soundsEnabled: Bool {
		get {
			return _soundsEnabled
		}
		set {
			_soundsEnabled = newValue
			defaults.set(_soundsEnabled, forKey: "soundsEnabled")
		}
	}

	// set active preset
	var activePreset: Preset {
		get {
			return _activePreset
		}
		set {
			_activePreset = newValue
			defaults.set(_activePreset.info(), forKey: "activePreset")
			onChange?(_activePreset)
		}
	}
	
	func savePresets() {
		defaults.set(presets.map { $0.info() }, forKey: "presets")
	}
	
	override init() {
		
		// register defaults
		let defaultPresets = [
			["title": "5 minutes",  "time": 5*60,  "runs": 1],
			["title": "10 minutes", "time": 10*60, "runs": 1],
			["title": "15 minutes", "time": 15*60, "runs": 1],
			["title": "20 minutes", "time": 20*60, "runs": 1],
			["title": "Crazy Eight", "time": 60, "runs": 8]
		]
		UserDefaults().register(defaults: [
			"soundsEnabled": true,
			"presets": defaultPresets,
			"activePreset": defaultPresets[0]
		])
		
		// load sounds enabled
		_soundsEnabled = defaults.bool(forKey: "soundsEnabled")
		
		// load presets
		let infos = defaults.object(forKey: "presets") as! [[String: AnyObject]]
		presets = infos.map { Preset(info: $0) }

		// load active preset
		let info = defaults.object(forKey: "activePreset") as! [String: AnyObject]
		_activePreset = Preset(info: info)
	}

}
