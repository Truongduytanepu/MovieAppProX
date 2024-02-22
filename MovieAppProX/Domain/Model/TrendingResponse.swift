//
//  TrendingResponse.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import Foundation

struct TrendingResponse: Codable {
  let code: Int
  let trendings: [Trending]
  
  enum CodingKeys: String, CodingKey {
    case code
    case trendings = "data"
  }
}
