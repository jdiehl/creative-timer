//
//  EditProgramTableViewController.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 16.08.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class EditProgramTableViewController: UITableViewController {
  
  var program: Program? {
    didSet { programChanged?(program!) }
  }
  
  var stepsCount: Int { program?.steps.count ?? 0 }

  var programChanged: ((Program) -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()
    isEditing = true
    tableView.tableFooterView = UIView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "EditStep" {
      let viewController = segue.destination as! EditStepTableViewController
      let indexPath = indexPathForSelectedStep()
      viewController.step = program!.steps[indexPath.row]
      viewController.stepChanged = { step in
        if let step = step {
          self.program!.steps[indexPath.row] = step
        } else {
          self.program!.steps.remove(at: indexPath.row)
        }
      }
    }
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  switch section {
    case 0: return 1
    case 1: return 2
    case 2: return stepsCount + 1
    default: return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
      case 0: return "Name"
      case 1: return "Appearance"
      case 2: return "Steps"
      default: return nil
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch (indexPath.section, indexPath.row) {
      case (0, 0): return makeTitleCell(indexPath: indexPath)
      case (1, 0): return makeThemeCell(indexPath: indexPath)
      case (1, 1): return makeStyleCell(indexPath: indexPath)
      case (2, 0..<stepsCount): return makeStepCell(indexPath: indexPath)
      case (2, stepsCount): return makeAddCell(indexPath: indexPath)
      default: return UITableViewCell()
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.section == 2 else { return }
    performSegue(withIdentifier: "EditStep", sender: nil)
  }
  
  
  override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
    program?.steps.swapAt(fromIndexPath.row, toIndexPath.row)
  }
  
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .none
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return indexPath.section == 2 && indexPath.row < stepsCount
  }
  
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return indexPath.section == 2 && indexPath.row < stepsCount
  }
  
  override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
    return false
  }
  
  // MARK: - Private Methods
  
  private func indexPathForSelectedStep() -> IndexPath {
    if tableView.indexPathForSelectedRow != nil { return tableView.indexPathForSelectedRow! }
    let indexPath = IndexPath(row: stepsCount, section: 2)
    program!.steps.append(Program.Step(title: "", length: 30))
    return indexPath
  }
  
  // MARK: - Cell Factory
  
  private func makeTitleCell(indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TextFieldCell
    cell.selectionStyle = .none
    cell.textField.text = program?.title
    cell.didChange = { self.program?.title = $0 }
    return cell
  }

  private func makeThemeCell(indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell", for: indexPath) as! ThemeCell
    cell.selectionStyle = .none
    cell.theme = self.program?.tint.theme
    cell.didChange = {
      self.program?.tint.theme = $0
      self.tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .none)
    }
    return cell
  }

  private func makeStyleCell(indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "StyleCell", for: indexPath) as! StyleCell
    cell.selectionStyle = .none
    cell.theme = self.program?.tint.theme
    cell.style = self.program?.tint.style
    cell.didChange = { self.program?.tint.style = $0 }
    return cell
  }

  private func makeStepCell(indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "StepCell", for: indexPath)
    let step = program!.steps[indexPath.row]
    cell.textLabel?.text = step.title
    cell.detailTextLabel?.text = step.length.toTimeString()
    return cell
  }

  private func makeAddCell(indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath) as! ButtonCell
    cell.onTap = { self.performSegue(withIdentifier: "EditStep", sender: nil) }
    return cell
  }

}
