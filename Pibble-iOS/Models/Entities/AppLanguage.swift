//
//  AppLanguage.swift
//  Pibble
//
//  Created by Sergey Kazakov on 20/05/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

enum AppLanguage: String {
  case english = "en"
  case korean = "ko"
}

extension AppLanguage {
  var title: String {
    switch self {
    case .english:
      return "English"
    case .korean:
      return "한국어"
    }
  }
  
  var localizedTitle: String {
    return localizedStringKey.localize()
  }
  
  var localizedStringKey: AppLanguage.Strings {
    switch self {
    case .english:
      return .english
    case .korean:
      return .korean
    }
  }
  
  var languageCode: String {
    return rawValue
  }
}


extension AppLanguage {
  enum Strings: String, LocalizedStringKeyProtocol {
    case english = "English"
    case korean = "Korean"
  }
}
