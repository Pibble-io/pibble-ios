//
//  CommentsModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum Comments {
  enum Actions {
    case reply
    case upvote
    case showUser
  }
 
  struct CommentsHeaderViewModel: CommentsHeaderViewModelProtocol {
    let userpicPlaceholder: UIImage?
    let userPic: String
    let attrubutedBody: NSAttributedString
    let date: String
    
    init?(post: PostingProtocol) {
      guard post.postingCaption.count > 0 else {
        return nil
      }
      
      let username = post.postingUser?.userName.capitalized ?? ""
      userPic = post.postingUser?.userpicUrlString ?? ""
      userpicPlaceholder = UIImage.avatarImageForNameString(username)
      
      date = post.postingCreatedAt.timeAgoSinceNow(useNumericDates: true)
      let body = post.postingCaption
      
      let attributerUserNameString = NSAttributedString(string: "\(username): ", attributes: [NSAttributedString.Key.font : UIFont.AvenirNextMedium(size: 13.0)])
      
      let attributedBodyString =  NSAttributedString(string: body, attributes: [NSAttributedString.Key.font : UIFont.AvenirNextRegular(size: 13.0)])
      let attrubutedComment = NSMutableAttributedString()
      attrubutedComment.append(attributerUserNameString)
      attrubutedComment.append(attributedBodyString)
      
      attrubutedBody = attrubutedComment
    }
  }
  
  struct CommentViewModel: CommentViewModelProtocol {
    let username: String
    let userPic: String
    let userpicPlaceholder: UIImage?
    let body: String
    let createdAt: String
    
    let attrubutedBody: NSAttributedString
    let isReplyComment: Bool
    let isSelectedToReply: Bool
    let isUpVoted: Bool
    let brushedCountTitle: String
    let isUpVoteEnabled: Bool
    let canBeEdited: Bool
    
    let isInteractionEnabled: Bool
    
    init(comment: CommentProtocol, isSelectedToReply: Bool) {
      self.isSelectedToReply = isSelectedToReply
      username = comment.commentUser?.userName.capitalized ?? ""
      userPic = comment.commentUser?.userpicUrlString ?? ""
      body = comment.commentBody
      userpicPlaceholder = UIImage.avatarImageForNameString(username)
      isUpVoted = comment.isUpVotedByUser
      brushedCountTitle = comment.commentUpVotesAmount > 0 ?
        "\(Comments.Strings.brushed.localize()) \(comment.commentUpVotesAmount)" : ""
      isUpVoteEnabled = true //!comment.isMyComment
      
      canBeEdited = comment.isMyComment
      
      var commentDate = ""
      commentDate = comment.createdAtDate.timeAgoSinceNow(useNumericDates: true)
      
      createdAt = commentDate
      
      let attributerUserNameString = NSAttributedString(string: "\(username): ", attributes: [NSAttributedString.Key.font : UIFont.AvenirNextMedium(size: 13.0)])
      
      let attributedBodyString =  NSAttributedString(string: body, attributes: [NSAttributedString.Key.font : UIFont.AvenirNextRegular(size: 13.0)])
      let attrubutedComment = NSMutableAttributedString()
      attrubutedComment.append(attributerUserNameString)
      attrubutedComment.append(attributedBodyString)
      
      attrubutedBody = attrubutedComment
      
      let isReply = comment.isReplyComment ?? false
      let isParentCommentDeleted = comment.isParentCommentDeleted ?? false
      isReplyComment = isReply && !isParentCommentDeleted
      
      isInteractionEnabled = !comment.isDraftComment
    }
  }
}

extension Comments {
  enum Strings: String, LocalizedStringKeyProtocol {
    case deleteCommentMessage = "Delete Comment?"
    case deleteCommentAction = "Delete"
    case cancelDeleteComment = "Cancel"
    case brushed = "Brushed"
  }
}
