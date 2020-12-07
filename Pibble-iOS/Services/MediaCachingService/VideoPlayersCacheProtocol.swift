//
//  VideoPlayersCacheProtocol.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 27/08/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol VideoPlayersCacheProtocol {
  func hasCacheFor(_ urlString: String) -> Bool
  func getOrCreatePlayerFor(_ urlString: String) -> VideoPlayerServiceProtocol?
}
