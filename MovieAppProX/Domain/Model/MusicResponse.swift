//
//  MusicResponse.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 28/11/2023.
//

import Foundation

struct MusicResponse: Codable {
  let code: Int
  let musics: [Music]
  
  enum CodingKeys: String, CodingKey {
    case code
    case musics = "data"
  }
}
