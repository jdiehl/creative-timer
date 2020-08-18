//
//  EditStepTableViewController.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 18.08.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class EditStepTableViewController: UITableViewController {
  
  var step: Program.Step? {
    didSet { stepChanged?(step!) }
  }

  var stepChanged: ((Program.Step) -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
      case 0: return "Title"
      case 1: return "Length"
      default: return nil
    }
  }
  
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    guard section == 1 else { return nil }
    let view = UIView()
    view.backgroundColor = UIColor.systemGroupedBackground
    return view
  }
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    guard section == 1 else { return 0 }
    let tableHeight = tableView.frame.height - tableView.adjustedContentInset.top - tableView.adjustedContentInset.bottom
    let fitHeight = tableHeight - 2 * (60 + 28)
    return max(fitHeight, 28)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch (indexPath.section, indexPath.row) {
      case (0, 0): return makeTitleCell(indexPath: indexPath)
      case (1, 0): return makeLengthCell(indexPath: indexPath)
      default: return UITableViewCell()
    }
  }
  
  // MARK: - Cell Factory
  
  private func makeTitleCell(indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TextFieldCell
    cell.textField.text = step?.title
    cell.didChange = { self.step?.title = $0 }
    return cell
  }

  private func makeLengthCell(indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TextFieldCell
    cell.textField.text = String(step?.length ?? 0)
    cell.didChange = { self.step?.length = Int($0) ?? 0 }
    return cell
  }

}
