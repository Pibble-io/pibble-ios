//
//  BaseSearchResult+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 30.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

extension BaseSearchResultManagedObject: BaseSearchResultProtocol {
  var searchResultEntity: SearchResultEntity {
    switch searchResultType {
    case .user:
      return SearchResultEntity(user: self as! UserSearchResultManagedObject)
    case .tag:
      return SearchResultEntity(tag: self as! TagSearchResultManagedObject)
    case .place:
      return SearchResultEntity(place: self as! LocationSearchResultManagedObject)
    }
  }
  
  var searchString: String {
    return searchKey ?? ""
  }
  
  var searchResultType: SearchResultType {
    return SearchResultType(rawValue: Int(resultType)) ?? .user
  }
  
  var searchResultCreatedAt: Date {
    guard let date = createdAt else {
      return Date()
    }
    
    return Date(timeIntervalSince1970: date.timeIntervalSince1970)
  }
  
  var identifier: Int {
    return Int(id)
  }
}
