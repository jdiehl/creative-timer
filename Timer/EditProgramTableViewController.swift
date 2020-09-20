//
//  EditProgramTableViewController.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 16.08.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

fileprivate let SectionName = 0
fileprivate let SectionAppearance = 1
fileprivate let SectionConfig = 2
fileprivate let SectionSteps = 3

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
        guard let step = step else { return }
        self.program!.steps[indexPath.row] = step
      }
    }
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  switch section {
    case SectionName: return 1
    case SectionAppearance: return 2
    case SectionConfig: return program!.pause > 0 ? 3 : 2
    case SectionSteps: return stepsCount + 1
    default: return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
      case SectionName: return "Name"
      case SectionAppearance: return "Appearance"
      case SectionConfig: return "Configuration"
      case SectionSteps: return "Steps"
      default: return nil
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch (indexPath.section, indexPath.row) {
      case (SectionName, 0): return makeTitleCell(indexPath: indexPath)
      case (SectionAppearance, 0): return makeThemeCell(indexPath: indexPath)
      case (SectionAppearance, 1): return makeStyleCell(indexPath: indexPath)
      case (SectionConfig, 0): return makeDirectionCell(indexPath: indexPath)
      case (SectionConfig, 1): return makePauseSwitchCell(indexPath: indexPath)
      case (SectionConfig, 2): return makePauseLengthCell(indexPath: indexPath)
      case (SectionSteps, 0..<stepsCount): return makeStepCell(indexPath: indexPath)
      case (SectionSteps, stepsCount): return makeAddCell(indexPath: indexPath)
      default: return UITableViewCell()
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.section == SectionSteps else { return }
    performSegue(withIdentifier: "EditStep", sender: nil)
  }
  
  
  override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
    program?.steps.swapAt(fromIndexPath.row, toIndexPath.row)
  }
  
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return indexPathIsEditable(indexPath) ? .delete : .none
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return indexPathIsEditable(indexPath)
  }
  
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return indexPathIsEditable(indexPath)
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      program!.steps.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
  
  // MARK: - Private Methods
  
  private func indexPathForSelectedStep() -> IndexPath {
    if tableView.indexPathForSelectedRow != nil { return tableView.indexPathForSelectedRow! }
    let indexPath = IndexPath(row: stepsCount, section: SectionSteps)
    program!.steps.append(Program.Step(title: "", length: 30))
    return indexPath
  }
  
  private func indexPathIsEditable(_ indexPath: IndexPath) -> Bool {
    return indexPath.section == SectionSteps && indexPath.row < stepsCount
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
      self.program?.theme = $0
      self.tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .none)
    }
    return cell
  }

  private func makeStyleCell(indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "StyleCell", for: indexPath) as! StyleCell
    cell.selectionStyle = .none
    cell.theme = self.program?.tint.theme
    cell.style = self.program?.tint.style
    cell.didChange = { self.program?.style = $0 }
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

  private func makeDirectionCell(indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
    cell.set(on: program!.direction == .down)
    cell.set(label: "Count downwards")
    cell.didChange = { on in self.program!.direction = on ? .down : .up }
    return cell
  }

  private func makePauseSwitchCell(indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
    cell.set(on: program!.pause > 0)
    cell.set(label: "Pause between steps")
    cell.didChange = { on in
      let pauseLengthIndexPath = IndexPath(row: 2, section: SectionConfig)
      if on {
        self.program!.pause = 10
        self.tableView.insertRows(at: [pauseLengthIndexPath], with: .automatic)
      } else {
        self.program!.pause = 0
        self.tableView.deleteRows(at: [pauseLengthIndexPath], with: .automatic)
      }
    }
    return cell
  }
  private func makePauseLengthCell(indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LengthCell", for: indexPath) as! TextFieldCell
    cell.textField.text = String(program!.pause)
    cell.didChange = { text in
      self.program!.pause = Int(text)!
      if self.program!.pause == 0 { self.tableView.deleteRows(at: [indexPath], with: .automatic) }
    }
    return cell
  }

}
