//
//  LocationPickModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 23.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum LocationPick {
  enum ItemPresentationStyle {
    case top
    case bottom
    case defaultStyle
  }
  enum ItemType {
//    case map
    case location(LocationItemViewModelProtocol)
  }
  
}
