//
//  PushUpdateConfig.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 30/11/2023.
//

import Foundation

struct PushUpdateConfig: Codable {
  let status: Bool
  let nowVersion: Double
  let obligatory: Bool
  let normalContent: String
  let obligatoryContent: String
}
