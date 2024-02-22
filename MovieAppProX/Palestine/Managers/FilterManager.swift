//
//  FilterManager.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 26/11/2023.
//

import Foundation
import Combine

class FilterManager {
  static let shared = FilterManager()
  
  @Published private(set) var filters = [Filter]()
  @Published private(set) var isLoading = false
  @Published private(set) var selectedFilter: Filter?
}

extension FilterManager {
  func fetch() {
    self.isLoading = true
    filters.removeAll()
    Task {
      do {
        let filterResponse = try await APIManager.shared.getFilter()
        self.filters = filterResponse.filters.reversed()
        self.selectedFilter = filters.first
        self.isLoading = false
      } catch {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
          guard let self else {
            return
          }
          self.fetch()
        }
      }
    }
  }
  
  func isSelected(filter: Filter) -> Bool {
    return selectedFilter?.id == filter.id
  }
}
