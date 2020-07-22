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
  
  lazy var headerViewController: HeaderViewController = instantiateChild(identifier: "Header")
  lazy var progressViewController: ProgressViewController = instantiateChild(identifier: "TimeProgress")
  lazy var stepsViewController: StepsViewController = instantiateChild(identifier: "Steps")
  lazy var controlsViewController: ControlsViewController = instantiateChild(identifier: "Controls")
  lazy var flashViewController: FlashViewController = FlashViewController()

  // MARK: - ProgramManagerDelegate
  
  func managerChangedProgram(programManager: ProgramManager) {
    runner.program = programManager.activeProgram
  }
  
  // MARK: - ControlsDelegate

  func onSettings() {
    performSegue(withIdentifier: "showPresets", sender: self)
  }
  
  // MARK: - UIViewController
  
	override func viewDidLoad() {
		super.viewDidLoad()
    setupViewControllers()
    setupEvents()
    updateColors()
    runner.program = ProgramManager.shared.activeProgram
	}
	
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let navigationController = segue.destination as! UINavigationController
    let viewController = navigationController.viewControllers[0] as! PresetTableViewController
    viewController.popoverPresentationController?.sourceRect = controlsViewController.resetButton.bounds
  }
  
  // position child view controllers
  private func setupViewControllers() {
    addChild(flashViewController)
    flashViewController.embedIn(view: view)
    headerViewController.embedIn(view: headerView)
    progressViewController.embedIn(view: progressView)
    controlsViewController.embedIn(view: controlsView)
    stepsViewController.embedIn(view: stepsView)
    controlsViewController.delegate = self
  }
  
  // set up event handlers
  private func setupEvents() {
    
    // runner started
    runner.on(.started) {
      UIApplication.shared.isIdleTimerDisabled = true
    }
    
    // runner stopped
    runner.on(.stopped) {
      UIApplication.shared.isIdleTimerDisabled = false
    }
    
    // runner step
    runner.on(.stepChanged) {
      if self.runner.running { self.flashViewController.blink() }
    }
    
    // runner finished
    runner.on(.finished) {
      self.flashViewController.flash() { success in
        UIApplication.shared.isIdleTimerDisabled = false
      }
    }

    TintManager.shared.on(.tintChanged) { self.updateColors() }
  }
  
  private func updateColors() {
    self.view.backgroundColor = TintManager.shared.backgroundColor
  }
  
}
