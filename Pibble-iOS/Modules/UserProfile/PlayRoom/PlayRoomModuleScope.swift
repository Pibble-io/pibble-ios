//
//  PlayRoomModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

enum PlayRoom {
  enum PlayRoomType {
    case currentUser
    case otherUser(targetUser: UserProtocol)
  }
  
}

extension PlayRoom {
  enum Strings {
    enum NavigationBarTitles: String, LocalizedStringKeyProtocol {
      case playroom = "Playroom"
      case playroomFor = "%\'s Playroom"
    }
    
    enum Alerts: String, LocalizedStringKeyProtocol  {
      case exitMessage = "Do you want to exit Playroom?"
      case okAction = "Ok"
      case cancelAction = "Cancel"
    }
  }
}
