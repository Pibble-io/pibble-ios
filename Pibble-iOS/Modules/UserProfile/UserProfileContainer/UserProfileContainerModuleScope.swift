//
//  UserProfileContainerModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum UserProfileContainer {
  enum UserPostsSegments: Int {
    case listing
    case grid
    case favorites
    case brushed
  }
  
  
}

extension UserProfileContainer {
  enum Strings: String, LocalizedStringKeyProtocol {
    case cancelAction = "Cancel"
    case chat = "Message"
    case mute = "Mute"
    case report = "Report"
    
    case messageRooms = "Open message rooms"
    case settings = "Settings"
    case logout = "Log Out"
  }
}

