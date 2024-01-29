//
//  StorageManager.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation
import Security

final class StorageManager {
  typealias StoringItem = (value: String, key: Keys)
  static var shared = StorageManager()
  
  private let keychain = Keychain(service: "com.sonohealth.org")
  private let userDefaults = UserDefaults.standard
  enum Keys: String, CaseIterable {
    case expiresAt
    case accessToken
    case refreshToken
    case id
    case isFirstTime
  }
  
  func store(_ item: String, by key: Keys) {
    userDefaults.set(item, forKey: key.rawValue)
  }
  
  func updateIfNeeded(_ item: String, by key: Keys) {
    let oldValue = userDefaults.string(forKey: key.rawValue)
    guard item != oldValue else { return }
    userDefaults.set(item, forKey: key.rawValue)
  }
  
  func get(by key: Keys) -> String? {
    return userDefaults.string(forKey: key.rawValue)
  }
  
  func delete(by key: Keys) {
    userDefaults.removeObject(forKey: key.rawValue)
  }
  
  func clear() {
    Keys.allCases.forEach {
      userDefaults.removeObject(forKey: $0.rawValue)
    }
  }
  
  func writeKeychain(_ values: StoringItem...) {
    do {
      try values.forEach {
        try keychain.set($0.value, key: $0.key.rawValue)
      }
    } catch {
      print(error)
    }
  }
  
  func getKeychain(by key: Keys) -> String? {
    do {
      return try keychain.get(key.rawValue)
    } catch {
      print(error)
      return nil
    }
  }
  
  func clearKeychain() {
    do {
      try keychain.removeAll()
    } catch {
      print(error)
    }
  }
}
