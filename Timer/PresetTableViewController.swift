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
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

    // MARK: - Table view data source
	
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? presetManager.presets.count : 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier("presetCell", forIndexPath: indexPath)
			let preset = presetManager.presets[indexPath.row] as Preset
			cell.textLabel!.text = preset.title
			return cell
		}
		return tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath)
    }
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 0 {
			presetManager.activePreset = presetManager.presets[indexPath.row]
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
			presetManager.presets.removeAtIndex(indexPath.row)
			presetManager.savePresets()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
	
	// allow deletion and insertion
	override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
		return .Delete
	}

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
		presetManager.presets.insert(presetManager.presets.removeAtIndex(fromIndexPath.row), atIndex:toIndexPath.row)
		presetManager.savePresets()
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return indexPath.section == 0
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "editPreset" {
			let viewController = segue.destinationViewController as! PresetViewController
			viewController.preset = presetManager.presets[self.tableView.indexPathForCell(sender! as! UITableViewCell)!.row]
		}
    }

}
