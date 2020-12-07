//
//  UIImageFromStringExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 05.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit


extension Character {
  fileprivate static let alphabet = "abcdefghijklmnopqrstuvwxyz1234567890"
  fileprivate static let numberForChar: [Character: CGFloat] = {
    let count = CGFloat(Character.alphabet.count)
    var dict: [Character: CGFloat] = [:]
    for (idx, char) in Character.alphabet.enumerated() {
      dict[char] = CGFloat(idx) / count
    }
    return dict
  }()
  
  func numberInAlphabet() -> CGFloat {
    return Character.numberForChar[self] ?? 0.0
  }
}

extension String {
  func generateColor() -> UIColor {
     guard count > 1 else {
      return UIColor.black
    }
    
    let r = self.first?.numberInAlphabet() ?? 0.0
    let g = self.last?.numberInAlphabet() ?? 0.0
    let b = self.last?.numberInAlphabet() ?? 0.0
    return UIColor(red: r, green: g, blue: b, alpha: 1.0)
  }
}

fileprivate extension UIColor {
  static func random() -> UIColor {
    
    srand48(Int(arc4random_uniform(100)))
    
    var red = 0.0;
    while red < 0.1 || red > 0.84 {
      red = drand48()
    }
    
    var green = 0.0;
    while green < 0.1 || green > 0.84 {
      green = drand48()
    }
    
    var blue = 0.0;
    while blue < 0.1 || blue > 0.84 {
      blue = drand48()
    }
    return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
  }
}

extension UIImage {
  static func avatarImageForNameString(_ username: String) -> UIImage? {
    let size = CGSize(width: 100, height: 100)
    return avatarImageForNameString(username, size: size)
  }
  
  static func avatarImageForTitleString(_ title: String) -> UIImage? {
    let size = CGSize(width: 100, height: 100)
    return avatarImageForTitleString(title, size: size)
  }
  
  static func avatarStringFor(_ username: String) -> String {
    let name = username.lowercased()
    var initials = ""
    let initialsArray = name.components(separatedBy: " ")
    
    if let firstWord = initialsArray.first {
      if let firstLetter = firstWord.first {
        initials += String(firstLetter).capitalized
      }
    }
    if initialsArray.count > 1, let lastWord = initialsArray.last {
      if let lastLetter = lastWord.first {
        initials += String(lastLetter).capitalized
      }
    } else {
      if let lastChar = name.last {
        initials += String(lastChar).capitalized
      }
    }
    
    return initials
  }
  
  static func avatarStringForTitle(_ title: String) -> String {
    let uppercasedTitle = title.uppercased()
    guard uppercasedTitle.count > 1 else {
      return uppercasedTitle
    }
    
    return String(uppercasedTitle.prefix(2))
  }
  
  static func avatarImageForNameString(_ username: String, size: CGSize) -> UIImage? {
    guard Thread.isMainThread else {
      return nil
    }
    
    let name = username.lowercased()
    let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    let nameLabel = UILabel(frame: frame)
    nameLabel.textAlignment = .center
    nameLabel.backgroundColor = name.generateColor()
    nameLabel.textColor = .white
    let fontSize: CGFloat = floor(size.height * 0.4)
    nameLabel.font = UIFont.AvenirNextMedium(size: fontSize)
    let initials = avatarStringFor(username)

    nameLabel.text = initials
    UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
    if let currentContext = UIGraphicsGetCurrentContext() {
     
      nameLabel.layer.render(in: currentContext)
      
      let nameImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return nameImage
    }
    
    return nil
  }
  
  static func avatarImageForTitleString(_ title: String, size: CGSize) -> UIImage? {
    guard Thread.isMainThread else {
      return nil
    }
    
    let name = title.lowercased()
    let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    let nameLabel = UILabel(frame: frame)
    nameLabel.textAlignment = .center
    nameLabel.backgroundColor = name.generateColor()
    nameLabel.textColor = .white
    let fontSize: CGFloat = floor(size.height * 0.4)
    nameLabel.font = UIFont.AvenirNextMedium(size: fontSize)
    let initials = avatarStringForTitle(title)
    
    nameLabel.text = initials
    UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
    if let currentContext = UIGraphicsGetCurrentContext() {
      
      nameLabel.layer.render(in: currentContext)
      
      let nameImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return nameImage
    }
    
    return nil
  }
}


