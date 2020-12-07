//
//  UserDescriptionPickerModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum UserDescriptionPickerModuleConfigurator: ModuleConfigurator {
  case defaultConfig(UserProfilePickDelegateProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let delegate):
      return (V: UserDescriptionPickerViewController.self,
              I: UserDescriptionPickerInteractor(),
              P: UserDescriptionPickerPresenter(delegate: delegate),
              R: UserDescriptionPickerRouter())
    }
  }
}
