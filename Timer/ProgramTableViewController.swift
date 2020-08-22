//
//  PresetTableViewController.swift
//  Timer
//
//  Created by Jonathan Diehl on 30/03/16.
//  Copyright © 2016 Jonathan Diehl. All rights reserved.
//

import UIKit

class ProgramTableViewController: UITableViewController {
	
	let programManager = ProgramManager.shared
  
  // MARK: - IBActions
	
	@IBAction func cancel() {
		dismiss(animated: true, completion: nil)
	}
  
  @IBAction func edit() {
    setEditing(!isEditing, animated: true)
  }
  
  // MARK: - UIViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = self.editButtonItem
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
  }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "EditProgram" {
      let viewController = segue.destination as! EditProgramTableViewController
      let row = tableView.indexPathForSelectedRow!.row
      viewController.program = programManager.programs[row]
      viewController.programChanged = { self.programManager.set(program: $0, at: row) }
    }
  }
  
  // MARK: - Table view data source
	
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return programManager.programs.count
  }
	
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ProgramCell", for: indexPath) as! ProgramCell
    let program = programManager.programs[indexPath.row]
    cell.set(program: program)
    return cell
  }
  
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if isEditing {
      performSegue(withIdentifier:"EditProgram", sender: nil)
      setEditing(false, animated: true)
    } else {
      programManager.set(active: indexPath.row)
      cancel()
    }
	}
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      programManager.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
	
	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return programManager.programs.count > 1 ? .delete : .none
	}

  override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
    let program = programManager.programs[fromIndexPath.row]
    programManager.remove(at: fromIndexPath.row)
    programManager.insert(program: program, at:toIndexPath.row)
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
  }

}
