//
//  ViewController.swift
//  Timer
//
//  Created by Jonathan Diehl on 03.26.16.
//  Copyright © 2016 Jonathan Diehl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var timerView: TimerView!
	
	var timer: Timer = Timer(total: 5)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// set up timer
		timerView.total = timer.total
		timer.onTick = { value in
			self.timerView.value = value
		}

		// start timer
		timer.start()
	}
	
}

