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
  var programsCount: Int { programManager.programs.count }
  
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
  }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "EditProgram" {
      let viewController = segue.destination as! EditProgramTableViewController
      let row = tableView.indexPathForSelectedRow?.row ?? programsCount - 1
      viewController.program = programManager.programs[row]
      viewController.programChanged = { self.programManager.set(program: $0, at: row) }
    }
  }
  
  // MARK: - Table view data source
	
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return programsCount + 1
  }
	
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
      case programsCount: return makeInsertCell(indexPath: indexPath)
      default: return makeProgramCell(indexPath: indexPath)
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == programsCount { return 60 }
    return 100
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
    if indexPath.row >= programsCount || programsCount <= 1 { return .none }
    return .delete
	}

  override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
    let program = programManager.programs[fromIndexPath.row]
    programManager.remove(at: fromIndexPath.row)
    programManager.insert(program: program, at:toIndexPath.row)
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return indexPath.row < programsCount
  }
  
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return indexPath.row < programsCount
  }
  
  // MARK: - Cell Factory
  
  func makeProgramCell(indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ProgramCell", for: indexPath) as! ProgramCell
    let program = programManager.programs[indexPath.row]
    cell.set(program: program)
    return cell
  }

  func makeInsertCell(indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath) as! ButtonCell
    cell.onTap = {
      self.programManager.add()
      self.tableView.insertRows(at: [indexPath], with: .automatic)
      self.performSegue(withIdentifier: "EditProgram", sender: nil)
    }
    return cell
  }

}
