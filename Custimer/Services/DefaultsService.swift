//
//  DefaultsService.swift
//  Custimer
//
//  Created by Jonathan Diehl on 27.09.20.
//

import Foundation

class DefaultsService {
  static let shared = DefaultsService()
  
  private let defaults = UserDefaults.standard
  
  init() {
    defaults.register(defaults: ["activeProgram": 0])
  }
  
  var activeProgram: Int {
    get { defaults.integer(forKey: "activeProgram") }
    set { defaults.set(newValue, forKey: "activeProgram") }
  }
}
