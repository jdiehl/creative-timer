//
//  EditTintViewController.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 08.08.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit
import Eureka

class EditTintViewController: FormViewController {

  var tint: TintColor? { didSet { setupForm() }}
  var style: TintStyle? { didSet { setupForm() }}
  
  var willClose: (() -> Void)?

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    setupForm()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    willClose?()
  }
  
  // MARK: - Private Methods

  private func setupForm() {
    guard isViewLoaded else { return }
    form.removeAll()
    
    form +++ SelectableSection<ListCheckRow<String>>() { section in
        section.header = HeaderFooterView(title: "Color")
    }

    for option in TintManager.allColors {
      form.last! <<< ListCheckRow<String>(option.rawValue){ lrow in
        lrow.title = option.rawValue
        lrow.selectableValue = option.rawValue
        lrow.value = nil
      }
    }
  }
}
