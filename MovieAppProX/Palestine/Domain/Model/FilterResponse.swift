//
//  FilterResponse.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 28/11/2023.
//

import Foundation

struct FilterResponse: Codable {
  let code: Int
  let filters: [Filter]
  
  enum CodingKeys: String, CodingKey {
    case code
    case filters = "data"
  }
}
