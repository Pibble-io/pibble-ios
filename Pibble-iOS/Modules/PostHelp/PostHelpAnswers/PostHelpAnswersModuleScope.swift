//
//  PostHelpAnswersModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum PostHelpAnswers {
  enum Actions {
    case reply
    case upvote
    case showUser
  }
  
  struct ItemLayout {
    let size: CGSize
    
    static func defaultLayout() -> ItemLayout {
      return ItemLayout(size: CGSize.zero)
    }
  }
  
  struct PostHelpAnswersHeaderViewModel: PostHelpAnswersHeaderViewModelProtocol {
    let userpicPlaceholder: UIImage?
    let userPic: String
    let attrubutedBody: NSAttributedString
    let date: String
    
    
    init?(postHelpRequest: PostHelpRequestProtocol) {
      guard postHelpRequest.helpDescription.count > 0 else {
        return nil
      }
      
      var username = postHelpRequest.helpForUser?.userName.capitalized ?? ""
      username = username.count > 0 ? "\(username): ": username
      
      userPic = postHelpRequest.helpForUser?.userpicUrlString ?? ""
      userpicPlaceholder = username.count > 0 ? UIImage.avatarImageForNameString(username): nil
      
//      date = post.postingCreatedAt.timeAgoSinceNow(useNumericDates: true)
      date = ""
      let body = postHelpRequest.helpDescription
      
      let attributerUserNameString = NSAttributedString(string: username, attributes: [NSAttributedString.Key.font : UIFont.AvenirNextMedium(size: 13.0)])
      
      let attributedBodyString =  NSAttributedString(string: body, attributes: [NSAttributedString.Key.font : UIFont.AvenirNextRegular(size: 13.0)])
      let attrubutedComment = NSMutableAttributedString()
      attrubutedComment.append(attributerUserNameString)
      attrubutedComment.append(attributedBodyString)
      
      attrubutedBody = attrubutedComment
    }
  }
  
  struct AnswerViewModel: PostHelpAnswerViewModelProtocol {
    let username: String
    let userPic: String
    let userpicPlaceholder: UIImage?
    let body: String
    let createdAt: String
    
    let attrubutedBody: NSAttributedString
    let isReplyAnswer: Bool
    let isSelectedToReply: Bool
    let isUpVoted: Bool
    let brushedCountTitle: String
    let isUpVoteEnabled: Bool
    let canBeEdited: Bool
    let canBePicked: Bool
    
    let helpRewardAmount: String
    let isPicked: Bool
    
    let isInteractionEnabled: Bool
    
    init(answer: PostHelpAnswerProtocol, isSelectedToReply: Bool, postHelpRequset: PostHelpRequestProtocol) {
      self.isSelectedToReply = isSelectedToReply
      username = answer.answerUser?.userName.capitalized ?? ""
      userPic = answer.answerUser?.userpicUrlString ?? ""
      body = answer.answerBody
      userpicPlaceholder = UIImage.avatarImageForNameString(username)
      isUpVoted = answer.isUpVotedByUser
      brushedCountTitle = answer.answerUpVotesAmount > 0 ?
        "\(PostHelpAnswers.Strings.brushed.localize()) \(answer.answerUpVotesAmount)" : ""
      isUpVoteEnabled = true //!comment.isMyComment
      
      var commentDate = ""
      commentDate = answer.createdAtDate.timeAgoSinceNow(useNumericDates: true)
      
      createdAt = commentDate
      
      let attributerUserNameString = NSAttributedString(string: "\(username): ", attributes: [NSAttributedString.Key.font : UIFont.AvenirNextMedium(size: 13.0)])
      
      let attributedBodyString =  NSAttributedString(string: body, attributes: [NSAttributedString.Key.font : UIFont.AvenirNextRegular(size: 13.0)])
      let attrubutedComment = NSMutableAttributedString()
      attrubutedComment.append(attributerUserNameString)
      attrubutedComment.append(attributedBodyString)
      
      attrubutedBody = attrubutedComment
      
      let isReply = answer.isReplyAnswer ?? false
      let isParentCommentDeleted = answer.isParentAnswerDeleted ?? false
      isReplyAnswer = isReply && !isParentCommentDeleted
      
      isInteractionEnabled = !answer.isDraftAnswer
      
      
      canBeEdited = answer.isMyAnswer && !answer.isPickedAnswer
      canBePicked = !answer.isMyAnswer && !answer.isPickedAnswer
      
      isPicked = answer.isPickedAnswer
      helpRewardAmount = String(format: "%.0f", postHelpRequset.rewardAmount.value)
    }
  }
}


extension PostHelpAnswers {
  enum Strings: String, LocalizedStringKeyProtocol {
    case deleteCommentMessage = "Delete Comment?"
    case deleteCommentAction = "Delete"
    case pickAnswerAction = "Pick"
    case cancelDeleteComment = "Cancel"
    case brushed = "Brushed"
  }
}
