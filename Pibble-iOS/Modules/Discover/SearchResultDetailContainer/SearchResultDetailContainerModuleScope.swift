//
//  SearchResultDetailContainerModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 27.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum SearchResultDetailContainer {
  enum PostsSegments: Int {
    case listing
    case grid
  }
  
  enum ContentType {
    case relatedPostsForTag(TagProtocol)
    case relatedPostsForTagString(String)
    case placeRelatedPosts(LocationProtocol)
  }
}
