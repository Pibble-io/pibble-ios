//
//  UserInteractionServiceProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 02.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

protocol UserInteractionServiceProtocol {
  func getFriendsForCurrentUser(page: Int, perPage: Int, complete: @escaping
    ResultCompleteHandler<([PartialUserProtocol], PaginationInfoProtocol), PibbleError>)
  func getFollowersForCurrentUser(page: Int, perPage: Int, complete: @escaping
    ResultCompleteHandler<([PartialUserProtocol], PaginationInfoProtocol), PibbleError>)
  func getFollowingsForCurrentUser(page: Int, perPage: Int, complete: @escaping
    ResultCompleteHandler<([PartialUserProtocol], PaginationInfoProtocol), PibbleError>)
  
  func getFriendsForUser(username: String, page: Int, perPage: Int, complete: @escaping
    ResultCompleteHandler<([PartialUserProtocol], PaginationInfoProtocol), PibbleError>)
  
  func getFollowersForUser(username: String, page: Int, perPage: Int, complete: @escaping
    ResultCompleteHandler<([PartialUserProtocol], PaginationInfoProtocol), PibbleError>)
  
  func getMutedUsers(page: Int, perPage: Int, complete: @escaping
    ResultCompleteHandler<([PartialUserProtocol], PaginationInfoProtocol), PibbleError>)
  
  func getFollowingsForUser(username: String, page: Int, perPage: Int, complete: @escaping
    ResultCompleteHandler<([PartialUserProtocol], PaginationInfoProtocol), PibbleError>)
  
  func getFriendshipRequestsForCurrentUser(page: Int, perPage: Int, complete: @escaping
    ResultCompleteHandler<([PartialUserProtocol], PaginationInfoProtocol), PibbleError>)
  
  func getRecentFundSentUsers(page: Int, perPage: Int, complete: @escaping
    ResultCompleteHandler<([PartialUserProtocol], PaginationInfoProtocol), PibbleError>)
  
  func follow(user: UserProtocol, complete: @escaping CompleteHandler)
  
  func unfollow(user: UserProtocol, complete: @escaping CompleteHandler)
  
  func requestFriendship(user: UserProtocol, complete: @escaping CompleteHandler)
  func acceptFriendship(user: UserProtocol, complete: @escaping CompleteHandler)
  func rejectFriendship(user: UserProtocol, complete: @escaping CompleteHandler)
  func cancelFriendship(user: UserProtocol, complete: @escaping CompleteHandler)
  
  func upvote(user: UserProtocol, amount: Int, complete: @escaping CompleteHandler)
  
  func searchUser(_ username: String, complete: @escaping
    ResultCompleteHandler<[PartialUserProtocol], PibbleError>)
  
  func getUser(username: String, complete: @escaping
    ResultCompleteHandler<UserProtocol, PibbleError>)
  
  func getCurrentUser(complete: @escaping
    ResultCompleteHandler<UserProtocol, PibbleError>)
  
  func getCurrentUserRewardsHistory(period: RewardsHistoryPeriod, complete: @escaping ResultCompleteHandler<(prb: [HistoricalDataPointProtocol], pgb: [HistoricalDataPointProtocol]), PibbleError>)
  
  func getRewardsHistory(username: String, period: RewardsHistoryPeriod, complete: @escaping ResultCompleteHandler<(prb: [HistoricalDataPointProtocol], pgb: [HistoricalDataPointProtocol]), PibbleError>)
  
  func getPostsForuser(username: String, page: Int, perPage: Int, complete: @escaping (Result<([PartialPostingProtocol], PaginationInfoProtocol), PibbleError>) -> ())
  
  func getUpvotedPostsForuser(username: String, page: Int, perPage: Int, complete: @escaping (Result<([PartialPostingProtocol], PaginationInfoProtocol), PibbleError>) -> ())
  
  func getWinnerPostsForUser(username: String, cursor: Int?, perPage: Int, complete: @escaping ResultCompleteHandler<([PartialPostingProtocol], PaginationInfoProtocol), PibbleError>)
  
  func setMuteUserSettingsOnMainFeed(_ user: UserProtocol, muted: Bool, complete: @escaping CompleteHandler)
}
