//
//  DiscoverServiceProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 20.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

protocol DiscoverServiceProtocol {
  func searchForTop(_ searchString: String, complete: @escaping
    ResultCompleteHandler<([PartialUserProtocol], [LocationProtocol], [TagProtocol]), PibbleError>)
  
  func searchTag(_ tag: String, complete: @escaping ResultCompleteHandler<[TagProtocol], PibbleError>)
  
  func searchPlace(_ place: String, complete: @escaping ResultCompleteHandler<[LocationProtocol], PibbleError>)
  
  func searchUser(_ username: String, complete: @escaping
    ResultCompleteHandler<[PartialUserProtocol], PibbleError>)
  
}
