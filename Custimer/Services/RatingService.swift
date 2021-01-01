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
    count = UserDefaults.standard.integer(forKey: "ratings.count")
  }
  
  func request() {
    count += 1
    if whenToRequest.contains(count) {
      if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
        SKStoreReviewController.requestReview(in: scene)
      }
    }
  }
}
