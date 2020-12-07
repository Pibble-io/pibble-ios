//
//  LanguagePickerModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum LanguagePickerModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, LanguagePickerDelegateProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let delegate):
      return (V: LanguagePickerViewController.self,
              I: LanguagePickerInteractor(accountProfileService: diContainer.accountProfileService),
              P: LanguagePickerPresenter(delegate: delegate),
              R: LanguagePickerRouter())
    }
  }
}
