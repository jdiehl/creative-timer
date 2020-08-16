//
//  PresetViewController.swift
//  Timer
//
//  Created by Jonathan Diehl on 30/03/16.
//  Copyright © 2016 Jonathan Diehl. All rights reserved.
//

import UIKit
import Eureka

class EditProgramViewControllerOld: FormViewController {

  var program: Program? {
    didSet { setupForm() }
  }
  
  var programChanged: ((Program) -> Void)?

  @IBAction func done() {
    let title = (form.rowBy(tag: "title") as! TextRow).value!
    let program = Program(title: title, tint: Tint(theme: .crimson, style: .automatic), steps: self.program!.steps)
    programChanged?(program)
  }

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    setupForm()
  }
  
  // MARK: - Private Methods

  private func setupForm() {
    guard isViewLoaded else { return }
    guard let program = program else { return }
    form.removeAll()
    form +++ Section("Timer")
      <<< TextRow() { row in
        row.tag = "title"
        row.title = "Name"
        row.value = program.title
      }.cellUpdate { cell, row in
          cell.textField.clearButtonMode = .whileEditing
      }
      <<< LabelRow { row in
        row.title = "Appearance"
        row.onCellSelection { cell, row in
          let editTintViewController = EditTintViewController()
          self.navigationController?.pushViewController(editTintViewController, animated: true)
        }
      }.cellUpdate { cell, row in
        cell.accessoryType = .disclosureIndicator
    }
  }
}
