//
//  PostHelpServiceProtocol.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 01/10/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol PostHelpServiceProtocol {
  func createPostHelpFor(_ post: PostingProtocol, postHelp: CreatePostHelpProtocol, complete: @escaping CompleteHandler)
  
  func showPostHelp(postHelpId: Int, complete: @escaping
    ResultCompleteHandler<PartialPostHelpRequestProtocol, PibbleError>)
  
  func getAnswersFor(postHelpId: Int, page: Int, perPage: Int, complete: @escaping
    ResultCompleteHandler<([PartialPostHelpAnswerProtocol], PaginationInfoProtocol), PibbleError>)
  
  func createAnswerFor(postHelpId: Int, body: String, complete: @escaping
    ResultCompleteHandler<PartialPostHelpAnswerProtocol, PibbleError>)
  
  func createAnswerReplyFor(postHelpId: Int, answerId: Int, body: String, complete: @escaping
    ResultCompleteHandler<PartialPostHelpAnswerProtocol, PibbleError>)
  
  func showAnswer(postHelpId: Int, answerId: Int, complete: @escaping
    ResultCompleteHandler<PartialPostHelpAnswerProtocol, PibbleError>)
  
  func upvoteAnswer(postHelpId: Int, answerId: Int, amount: Int, complete: @escaping CompleteHandler)
  
  func deleteAnswer(postHelpId: Int, answerId: Int, complete: @escaping CompleteHandler)
  
  func pickAnswer(postHelpId: Int, answerId: Int, complete: @escaping CompleteHandler)
}
