//
//  MediaCachingServiceProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 07.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

protocol MediaCachingServiceProtocol {
  func cancelPreparingMediaFor(_ urlString: String)
  func prepareMediaFor(_ urlString: String, type: ContentType)
}
