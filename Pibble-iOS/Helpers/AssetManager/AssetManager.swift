//
//  AssetManager.swift
//  Pibble
//
//  Created by Kazakov Sergey on 25.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

protocol LocaleSpecificAssetProtocol {
  
}


protocol DeviceSpecificAssetProtocol {
  
}

extension DeviceSpecificAssetProtocol {
  fileprivate var baseAssetName: String {
    return String(describing: self)
  }
  
  fileprivate func assetFor(_ layout: DeviceScreenLayoutType) -> UIImage {
    let typeString = String(describing: type(of: self))
    
    let assetName = "\(typeString)-\(baseAssetName)-\(layout.name)"
    return UIImage(named: assetName) ?? UIImage()
  }
  
  var asset: UIImage {
    return assetFor(AssetsManager.layout)
  }
}

extension LocaleSpecificAssetProtocol {
  fileprivate var baseAssetName: String {
    return String(describing: self)
  }
  
  fileprivate func assetFor(_ appLanguage: AppLanguage) -> UIImage {
    let typeString = String(describing: type(of: self))
    
    let assetName = "\(typeString)-\(baseAssetName)-\(appLanguage.languageCode)"
    return UIImage(named: assetName) ?? UIImage()
  }
  
  var asset: UIImage {
    return assetFor(AssetsManager.LocalizedAssets.appLanguage)
  }
}

enum AssetsManager {
  static let layout = DeviceScreenLayoutType()
  
  enum Background: DeviceSpecificAssetProtocol {
    case auth
    case welcome
  }
  
  enum LocalizedAssets {
    static var appLanguage: AppLanguage = .english
    
    enum PostsFeed: LocaleSpecificAssetProtocol {
      case topGroupWinBanner
      
    }
  }
}
