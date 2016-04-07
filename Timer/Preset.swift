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
		return "<Preset id=\(unsafeAddressOf(self)) title=\(title) time=\(time) runs=\(runs)>"
	}
	
	init(title: String, time: Int, runs: Int) {
		self.title = title
		self.time = time
		self.runs = runs
		super.init()
	}
	
	init(info: [String: AnyObject]) {
		self.title = String(info["title"]!)
		self.time = Int(info["time"] as! NSNumber)
		self.runs = Int(info["runs"] as! NSNumber)
		super.init()
	}
	
	func info() -> [String: AnyObject] {
		return [
			"title": self.title,
			"time": NSNumber(int: Int32(self.time)),
			"runs": NSNumber(int: Int32(self.runs))
			
		]
	}
	
	
}
