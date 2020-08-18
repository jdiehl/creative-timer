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
    edit()
  }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "EditProgram" {
      let viewController = segue.destination as! EditProgramTableViewController
      let row = tableView.indexPathForSelectedRow!.row
      viewController.program = programManager.localPrograms[row]
      viewController.programChanged = { self.programManager.localPrograms[row] = $0 }
    }
  }
  
  // MARK: - Table view data source
	
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return programManager.localPrograms.count
  }
	
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ProgramCell", for: indexPath) as! ProgramCell
    let program = programManager.localPrograms[indexPath.row]
    cell.set(program: program)
    return cell
  }
  
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if isEditing {
      performSegue(withIdentifier:"EditProgram", sender: nil)
      setEditing(false, animated: true)
    } else {
      programManager.activeProgram = programManager.localPrograms[indexPath.row]
      cancel()
    }
	}
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      programManager.localPrograms.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
	
	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}

  override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
		programManager.localPrograms.insert(programManager.localPrograms.remove(at: fromIndexPath.row), at:toIndexPath.row)
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
  }

}
