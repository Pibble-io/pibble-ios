//
//  TopGroupPostsServiceProtocol.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 17/07/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol TopGroupPostsServiceProtocol {
  func getTopGroups(_ complete: @escaping
    ResultCompleteHandler<[TopGroup], PibbleError>)
  
  func getTopGroupPostsFor(_ groupType: TopGroupPostsType, cursorId: Int?, perPage: Int, complete: @escaping
    ResultCompleteHandler<([PartialPostingProtocol], PaginationInfoProtocol), PibbleError>)
  
  func getTopGroupPostsFor(_ groupType: TopGroupPostsType, page: Int, perPage: Int, complete: @escaping
    ResultCompleteHandler<([PartialPostingProtocol], PaginationInfoProtocol), PibbleError>)
  
  func getLeaderboard(_ type: LeaderboardType, cursorId: Int?, perPage: Int, complete: @escaping
    ResultCompleteHandler<([PartialLeaderboardEntryProtocol], PaginationInfoProtocol), PibbleError>)
  
  func getLeaderboard(_ type: LeaderboardType, page: Int, perPage: Int, complete: @escaping
    ResultCompleteHandler<([PartialLeaderboardEntryProtocol], PaginationInfoProtocol), PibbleError>)
}
