//
//  RunViewCell.swift
//  Timer
//
//  Created by Jonathan Diehl on 03.28.16.
//  Copyright © 2016 Jonathan Diehl. All rights reserved.
//

import UIKit

class RunViewCell: UICollectionViewCell {

	@IBOutlet weak var label: UILabel!

	var run: Int = 0 {
		didSet {
			label.text = "\(run)"
		}
	}
	
	var progress: Int = 0 {
		didSet {
			// nothing
		}
	}

}
