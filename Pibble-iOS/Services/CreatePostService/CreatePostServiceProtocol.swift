//
//  CreatePostServiceProtocol.swift
//  Pibble
//
//  Created by Sergey Kazakov on 29/01/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol CreatePostServiceProtocol {
  func beginPreUploadingTask(draft: MutablePostDraftProtocol)
  func cancelPreUploadingTask(draft: MutablePostDraftProtocol)
  func cancelUploadingTask(post: PostingProtocol)
  
  func performPosting(draft: MutablePostDraftProtocol)
}
