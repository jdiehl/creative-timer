//
//  ViewController.swift
//  Timer
//
//  Created by Jonathan Diehl on 03.26.16.
//  Copyright © 2016 Jonathan Diehl. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, ProgramManagerDelegate, ControlsDelegate {

	@IBOutlet weak var headerView: UIView!
	@IBOutlet weak var progressView: UIView!
  @IBOutlet weak var stepsView: UIView!
  @IBOutlet weak var controlsView: UIView!

  let runner = ProgramRunner.shared
  let programManager = ProgramManager.shared
  
  lazy var headerViewController: HeaderViewController = instantiateChild(identifier: "Header")
  lazy var progressViewController: ProgressViewController = instantiateChild(identifier: "TimeProgress")
  lazy var stepsViewController: StepsViewController = instantiateChild(identifier: "Steps")
  lazy var controlsViewController: ControlsViewController = instantiateChild(identifier: "Controls")
  lazy var announcerViewController: AnnouncerViewController = AnnouncerViewController()

  // MARK: - ProgramManagerDelegate
  
  func managerChangedProgram(programManager: ProgramManager) {
    updateProgram()
  }
  
  // MARK: - ControlsDelegate

  func onSettings() {
    performSegue(withIdentifier: "showPrograms", sender: self)
  }
  
  // MARK: - UIViewController
  
	override func viewDidLoad() {
		super.viewDidLoad()
    setupViewControllers()
    updateProgram()
    programManager.delegate = self
	}
	
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let navigationController = segue.destination as! UINavigationController
    let viewController = navigationController.viewControllers[0] as! ProgramTableViewController
    viewController.popoverPresentationController?.sourceRect = controlsViewController.resetButton.bounds
  }
  
  // MARK: - Private Methods
  
  // position child view controllers
  private func setupViewControllers() {
    addChild(announcerViewController)
    announcerViewController.embedIn(view: view)
    headerViewController.embedIn(view: headerView)
    progressViewController.embedIn(view: progressView)
    controlsViewController.embedIn(view: controlsView)
    stepsViewController.embedIn(view: stepsView)
    controlsViewController.delegate = self
  }
  
  private func updateProgram() {
    let program = programManager.activeProgram
    runner.program = program
    view.backgroundColor = program.tint.backgroundColor
  }
  
}
