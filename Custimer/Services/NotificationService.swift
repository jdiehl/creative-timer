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
  
  private var identifiers: [String] = []
  private var center: UNUserNotificationCenter { UNUserNotificationCenter.current() }
  private var granted = false
  
  func authorize() {
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      self.granted = granted
    }
  }
  
  func schedule(program: Program, after index: ProgramIndex) {
    guard granted else { return }
    cancel()

    var time = -index.time
    for i in 0..<program.steps.count {
      let step = program.steps[i]
      time += step.length
      if i < (program.steps.count - 1) { time += program.pause }
      if time > 0 { scheduleOne(time: time, i: i, program: program) }
    }
  }
  
  func cancel() {
    guard identifiers.count > 0 else { return }
    center.removePendingNotificationRequests(withIdentifiers: identifiers)
    identifiers = []
  }
  
  private func scheduleOne(time: Int, i: Int, program: Program) {
    let next = (i + 1) < program.steps.count ? program.steps[i + 1] : nil

    // define the trigger
    let date = Date(timeIntervalSinceNow: TimeInterval(time))
    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

    // define the body
    let content = UNMutableNotificationContent()
    if let next = next {
      content.title = "\(program.title) \(i + 2)/\(program.steps.count)"
      content.body = next.title
    } else {
      content.title = program.title
      content.body = NSLocalizedString("Fertig", comment: "Notification body for a finished program")
    }
    content.sound = .default
    
    // define the identifier
    let identifier = String(time)
    identifiers.append(identifier)
    
    // schedule the notification
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    center.add(request)
  }
  
}
