//
//  Filter.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 28/11/2023.
//

import Foundation

struct Filter: Codable {
  let id: String
  let name: String
  let thumbnailURL: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case thumbnailURL = "url"
  }
}
