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
	
	static func registerDefaults() {
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
	}
	
	var onChange: ((Preset) -> Void)?
	
	var presets: [Preset] {
		get {
			let infos = NSUserDefaults().objectForKey("presets") as! [[String: AnyObject]]
			return infos.map { Preset(info: $0) }
		}
		set {
			let infos = newValue.map { $0.info() }
			NSUserDefaults().setObject(infos, forKey: "presets")
		}
	}

	var activePreset: Preset {
		get {
			let info = NSUserDefaults().objectForKey("activePreset") as! [String: AnyObject]
			return Preset(info: info)
		}
		set {
			let info = newValue.info()
			NSUserDefaults().setObject(info, forKey: "activePreset")
			onChange?(newValue)
		}
	}

}
