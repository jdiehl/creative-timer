//
//  Preset.swift
//  Timer
//
//  Created by Jonathan Diehl on 03.28.16.
//  Copyright © 2016 Jonathan Diehl. All rights reserved.
//

import UIKit

class Preset: NSObject {
	var title: String
	var time: Int
	var runs: Int
	
	override var description: String {
		return "<Preset id=\(Unmanaged.passUnretained(self).toOpaque()) title=\(title) time=\(time) runs=\(runs)>"
	}
	
	init(title: String, time: Int, runs: Int) {
		self.title = title
		self.time = time
		self.runs = runs
		super.init()
	}
	
	init(info: [String: AnyObject]) {
		self.title = String(describing: info["title"]!)
        self.time = Int(truncating: info["time"] as! NSNumber)
        self.runs = Int(truncating: info["runs"] as! NSNumber)
		super.init()
	}
	
	func info() -> [String: AnyObject] {
		return [
			"title": self.title as AnyObject,
			"time": NSNumber(value: Int32(self.time) as Int32),
			"runs": NSNumber(value: Int32(self.runs) as Int32)
			
		]
	}
	
	
}
