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
  }
  
  var activeProgram: String? {
    get { defaults.string(forKey: "activeProgram") }
    set { defaults.set(newValue, forKey: "activeProgram") }
  }
}
