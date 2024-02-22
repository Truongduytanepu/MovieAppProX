//
//  CreditManager.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 30/11/2023.
//

import Foundation
import SwiftKeychainWrapper
import Combine

class CreditManager {
  static let shared = CreditManager()
  
  enum Keys {
    static let remainingFree = "REMAINING_FREE"
    static let didFirstOpenApp = "DID_FIRST_OPEN_APP"
  }
  
  @Published private(set) var remainingFree: Int = 0
  @Published private(set) var showReward: Bool = false
}

extension CreditManager {
  func didCreate() {
    guard remainingFree > 0 else {
      return
    }
    self.remainingFree -= 1
    KeychainWrapper.standard.set(remainingFree, forKey: Keys.remainingFree)
    checkMaxRemaining()
  }
  
  func didReceiveReward() {
    var remainingFree = remainingFree + Global.shared.rewardFree
    if remainingFree > Global.shared.maxRemainingFree {
      remainingFree = Global.shared.maxRemainingFree
    }
    self.remainingFree = remainingFree
    KeychainWrapper.standard.set(remainingFree, forKey: Keys.remainingFree)
    checkMaxRemaining()
  }
  
  func fetch() {
    if KeychainWrapper.standard.bool(forKey: Keys.didFirstOpenApp) == true {
      loadRemainingFree()
    } else {
      KeychainWrapper.standard.set(true, forKey: Keys.didFirstOpenApp)
      firstOpenApp()
    }
    checkMaxRemaining()
  }
  
  func isLimit() -> Bool {
    return remainingFree == 0
  }
}

extension CreditManager {
  private func loadRemainingFree() {
    self.remainingFree = KeychainWrapper.standard.integer(forKey: Keys.remainingFree) ?? 0
  }
  
  private func firstOpenApp() {
    KeychainWrapper.standard.set(Global.shared.defaultFree, forKey: Keys.remainingFree)
    loadRemainingFree()
  }
  
  private func checkMaxRemaining() {
    self.showReward = remainingFree < Global.shared.maxRemainingFree
  }
}
