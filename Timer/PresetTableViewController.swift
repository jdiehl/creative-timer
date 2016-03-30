//
//  PresetTableViewController.swift
//  Timer
//
//  Created by Jonathan Diehl on 30/03/16.
//  Copyright © 2016 Jonathan Diehl. All rights reserved.
//

import UIKit

class PresetTableViewController: UITableViewController {
	
	let presetManager = PresetManager.sharedManager
	var presets: [Preset] = PresetManager.sharedManager.presets
	
	// on cancel
	func cancel() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// cancel button
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancel))
		
		// title
		self.title = "Presets"

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source
	
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? presets.count : 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier("presetCell", forIndexPath: indexPath)
			let preset = presets[indexPath.row] as Preset
			cell.textLabel!.text = preset.title
			return cell
		}
		return tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath)
    }
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 0 {
			presetManager.activePreset = presets[indexPath.row]
			return self.dismissViewControllerAnimated(true, completion: nil)
		}
	}
	
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section == 0
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
			presets.removeAtIndex(indexPath.row)
			presetManager.presets = presets
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
	
	// allow deletion and insertion
	override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
		return .Delete
	}

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
		presets.insert(presets.removeAtIndex(fromIndexPath.row), atIndex:toIndexPath.row)
		presetManager.presets = presets
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return indexPath.section == 0
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let viewController = segue.destinationViewController as! PresetViewController
		if tableView.indexPathForSelectedRow!.section == 0 {
			viewController.preset = presets[tableView.indexPathForSelectedRow!.row]
		}
    }

}
