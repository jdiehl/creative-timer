//
//  EventEmitter.swift
//  Timer
//
//  Created by Jonathan Diehl on 20.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import Foundation

class EventEmitter<Event: Hashable> {
  typealias EventListener = () -> Void

  private var eventListeners: [Event: [EventListener]] = [:]
  
  func on(_ event: Event, listener: @escaping EventListener) {
    if eventListeners[event] == nil {
      eventListeners[event] = []
    }
    eventListeners[event]!.append(listener)
  }
  
  func off(_ event: Event) {
    eventListeners[event] = nil
  }
  
  func off() {
    eventListeners = [:]
  }
  
  func emit(_ event: Event) {
    guard let listeners = eventListeners[event] else { return }
    for listener in listeners {
      listener()
    }
  }
  
}
