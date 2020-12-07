//
//  AccountProfileServiceProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 23.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

protocol AccountProfileServiceProtocol {
  var currentUserAccount: AccountProfileProtocol? { get }
  var currentAccountUpvoteLimits: AccountUpvoteLimitsProtocol? { get }
  
  func getProfile(complete: @escaping ResultCompleteHandler<AccountProfileProtocol, PibbleError>)
  
  func getAccountUpvoteLimits(complete: @escaping ResultCompleteHandler<AccountUpvoteLimitsProtocol, PibbleError>)
  
  func availableUpVotesForCurrentUser(complete: @escaping ResultCompleteHandler<(min: Int, max: Int, available: Int), PibbleError>)
  
  func updateWallCover(imageFileURL: URL, complete: @escaping CompleteHandler)
  func updateUserpic(imageFileURL: URL, complete: @escaping CompleteHandler)
  func updateUserDescription(description: String, complete: @escaping CompleteHandler)
  
  func updateUserProfile(_ profile: UserProfileProtocol, complete: @escaping CompleteHandler)
  
  func updateAccountCurrency(_ currency: BalanceCurrency, complete: @escaping CompleteHandler)
  
  func updateUsername(username: String, complete: @escaping CompleteHandler) 
}


