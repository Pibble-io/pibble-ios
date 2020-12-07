//
//  PlaceServiceProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 25.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

protocol PlaceServiceProtocol {
  func searchPlace(_ place: String, complete: @escaping
    ResultCompleteHandler<[LocationProtocol], PibbleError>)
  
  func getRelatedPostsFor(_ place: LocationProtocol, page: Int, perPage: Int, complete: @escaping ResultCompleteHandler<(place: LocationProtocol, posts: [PartialPostingProtocol], pagination: PaginationInfoProtocol), PibbleError>)
}
