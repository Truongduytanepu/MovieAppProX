//
//  APIError.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 05/10/2023.
//

import Foundation

enum APIError: Error {
  case invalidRequest
  case invalidResponse
  case jsonEncodingError
  case jsonDecodingError
  case notInternet
}
