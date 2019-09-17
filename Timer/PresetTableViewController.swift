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
	
	// soundsEnabled
	@IBAction func onToggleSoundsEnabled(_ sender: UISwitch) {
		presetManager.soundsEnabled = sender.isOn;
	}
	
	// on cancel
	@objc func done() {
		self.dismiss(animated: true, completion: nil)
	}
  
  override func viewDidLoad() {
    super.viewDidLoad()
		
		// cancel button
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
		
		// title
		self.title = "Settings"

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem
  }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

    // MARK: - Table view data source
	
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? 1 : presetManager.presets.count + 1
    }
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return section == 0 ? nil : "Presets"
	}
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "soundCell", for: indexPath)
			cell.contentView.subviews.forEach({ (view) in
				if view.isKind(of: UISwitch.self) {
					(view as! UISwitch).isOn = presetManager.soundsEnabled
				}
			})
      return cell
		}
		if indexPath.section == 1 && indexPath.row < presetManager.presets.count {
			let cell = tableView.dequeueReusableCell(withIdentifier: "presetCell", for: indexPath)
			let preset = presetManager.presets[indexPath.row] as Preset
			cell.textLabel!.text = preset.title
			return cell
		}
		return tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 1 && indexPath.row < presetManager.presets.count {
			presetManager.activePreset = presetManager.presets[indexPath.row]
			return self.dismiss(animated: true, completion: nil)
		}
	}
	
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1 && indexPath.row < presetManager.presets.count
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			presetManager.presets.remove(at: indexPath.row)
			presetManager.savePresets()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
	
	// allow deletion and insertion
	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
		presetManager.presets.insert(presetManager.presets.remove(at: fromIndexPath.row), at:toIndexPath.row)
		presetManager.savePresets()
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return indexPath.section == 1 && indexPath.row < presetManager.presets.count
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "editPreset" {
			let viewController = segue.destination as! PresetViewController
			viewController.preset = presetManager.presets[self.tableView.indexPath(for: sender! as! UITableViewCell)!.row]
		}
    }

}
