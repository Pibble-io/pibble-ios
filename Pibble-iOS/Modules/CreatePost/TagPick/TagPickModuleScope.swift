//
//  TagPickModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 20.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum TagPick {
  enum ItemPresentationStyle {
    case top
    case bottom
    case single
    case defaultStyle
  }
  
  struct PickedTags {
    let tags: [String]
  }
  
  struct TagSuggestionViewModel: TagViewModelProtocol {
    let title: String
    let presentationStyle: ItemPresentationStyle
  }
    
}
