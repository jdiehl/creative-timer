//
//  RequestRatingService.swift
//  Custimer
//
//  Created by Jonathan Diehl on 01.01.21.
//

import Foundation
import StoreKit

class RatingService {
  static let shared = RatingService()
  
  let whenToRequest = [1, 3, 10]
  private var count: Int
  
  init() {
    let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString" as String) as! String
    let lastVersion = UserDefaults.standard.string(forKey: "ratings.version")
    if lastVersion != currentVersion {
      UserDefaults.standard.set(currentVersion, forKey: "ratings.version")
      UserDefaults.standard.set(0, forKey: "ratings.count")
    }
    count = UserDefaults.standard.integer(forKey: "ratings.count")
  }
  
  func request() {
    count += 1
    UserDefaults.standard.set(count, forKey: "ratings.count")
    if whenToRequest.contains(count) {
      if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
        SKStoreReviewController.requestReview(in: scene)
      }
    }
  }
}
