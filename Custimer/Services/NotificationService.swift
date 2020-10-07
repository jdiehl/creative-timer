//
//  NotificationScheduler.swift
//  Timer
//
//  Created by Jonathan Diehl on 12.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class NotificationService {
  static let shared = NotificationService()
  
//  let runner = ProgramRunner.shared
//  
//  private var identifiers: [String] = []
//  
//  private var center: UNUserNotificationCenter { UNUserNotificationCenter.current() }
//  
//  func schedule() {
//    guard identifiers.count == 0 else { return }
//    guard runner.running else { return }
//
//    // the current and all future steps
//    let steps = runner.program.steps[runner.index.step..<runner.program.steps.count]
//
//    // start with the negative index time (step length will be added)
//    var time = -runner.index.time
//    
//    // schedule a notification for each step
//    for (i, step) in steps.enumerated() {
//      time += step.length
//      let next = i + 1 < steps.count ? steps[i + 1] : nil
//      scheduleOne(time: time, i: i, step: step, next: next)
//    }
//  }
//  
//  func cancel() {
//    center.removePendingNotificationRequests(withIdentifiers: identifiers)
//    identifiers = []
//  }
//  
//  private func scheduleOne(time: Int, i: Int, step: Program.Step, next: Program.Step?) {
//    guard time > 0 else { return }
//
//    // define the trigger
//    let date = Date(timeIntervalSinceNow: TimeInterval(time))
//    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//    
//    // define the body
//    let content = UNMutableNotificationContent()
//    if let next = next {
//      content.title = "\(runner.program.title) \(i + 2)/\(runner.program.steps.count)"
//      content.body = next.title
//    } else {
//      content.title = runner.program.title
//      content.body = NSLocalizedString("Fertig", comment: "Notification body for a finished program")
//    }
//    content.sound = .default
//    
//    // define the identifier
//    let identifier = String(time)
//    identifiers.append(identifier)
//    
//    // schedule the notification
//    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//    center.add(request)
//  }
  
}
