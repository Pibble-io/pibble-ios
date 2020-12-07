//
//  User+Mappable.swift
//  Pibble
//
//  Created by Kazakov Sergey on 03.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension UserManagedObject: PartiallyUpdatable {
  
}

extension UserManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  static func replaceOrCreate(with object: UserProtocol, in context: NSManagedObjectContext) -> UserManagedObject {
    let managedObject = UserManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.name = object.userName
    managedObject.id = Int32(object.identifier)
    managedObject.avatar = object.userpicUrlString
    managedObject.uuid = object.userUUID
    managedObject.level = Int32(object.userLevel)
    
    managedObject.wallCover = object.userWallCoverUrlString
    
    managedObject.updateInteractionStatus(object.currentUserInteractionStatus)
    
    if let isCurrent = object.isCurrent {
      managedObject.isMe = isCurrent
    }
  
    if let isFriendshipDenied = object.isFriendshipDeniedByCurrentUser {
      managedObject.isFriendshipDenied = isFriendshipDenied
    }
    
    managedObject.isOutboundFriendRequested = object.isOutboundFriendshipRequested
    managedObject.isInboundFriendRequested = object.isInboundFriendshipRequested
    
    managedObject.earnedRewards = NSDecimalNumber(value: object.earnedBrushRewards)
    managedObject.rewardsLimit = NSDecimalNumber(value: object.brushRewardsLimit)
    managedObject.availablePoints = Int32(object.availableLevelUpPoints)
    managedObject.necessaryPoints = Int32(object.necessaryLevelUpPoints)
    
    managedObject.followersCount = Int32(object.userFollowersCount)
    managedObject.followingsCount = Int32(object.userFollowingsCount)
    managedObject.friendsCount = Int32(object.userFriendsCount)
    managedObject.postsCount = Int32(object.userPostsCount)
    
    managedObject.profileDescription = object.userProfileDescription
    managedObject.profileFirstName = object.userProfileFirstName
    managedObject.profileLastName = object.userProfileLastName
    managedObject.profileSiteAddress = object.userProfileSiteName
    
    managedObject.setValueIfNotNil(\UserManagedObject.email, value: object.userEmail)
    
    managedObject.isBanned = object.isBannedUser
    
    managedObject.setValueIfNotNil(\UserManagedObject.prizeWon, value: object.userWonPrizeAmount.map { NSDecimalNumber(value: $0) })
    
    let _ = object.userWallets
      .map { return WalletManagedObject.replaceOrCreate(with: $0, in: context) }
      .forEach { $0.user = managedObject }
    
    object.walletBalances.forEach {
      switch $0.currency {
      case .pibble:
        managedObject.pibBalance = NSDecimalNumber(value: $0.value)
      case .etherium:
        managedObject.ethBalance = NSDecimalNumber(value: $0.value)
      case .greenBrush:
        managedObject.greenBrushBalance = NSDecimalNumber(value: $0.value)
      case .redBrush:
        managedObject.redBrushBalance = NSDecimalNumber(value: $0.value)
      case .won:
        break
      case .bitcoin:
        managedObject.btcBalance = NSDecimalNumber(value: $0.value)
      case .australianDollar:
        break
      case .greatBritainPound:
        break
      case .canadianDollar:
        break
      case .chineseYuan:
        break
      case .euro:
        break
      case .japaneseYen:
        break
      case .usDollar:
        break
      case .unsupportedCurrency:
        break
      case .pibbleKlaytn:
        managedObject.pibKlaytnBalance = NSDecimalNumber(value: $0.value)
      case .klaytn:
        managedObject.klaytnBalance = NSDecimalNumber(value: $0.value)
      }
    }
    return managedObject
  }
  
  static func updateOrCreate(with object: PartialUserProtocol, in context: NSManagedObjectContext) -> UserManagedObject {
    let managedObject = UserManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.name = object.userName
    managedObject.id = Int32(object.identifier)
    managedObject.uuid = object.userUUID
    
    managedObject.setValueIfNotNil(\UserManagedObject.avatar, value: object.userpicUrlString)
    managedObject.setValueIfNotNil(\UserManagedObject.level, value: object.userLevel.map { Int32($0) })
    managedObject.setValueIfNotNil(\UserManagedObject.wallCover, value: object.userWallCoverUrlString)
    
    managedObject.updateInteractionStatus(object.currentUserInteractionStatus)
    
    managedObject.setValueIfNotNil(\UserManagedObject.isFollowingMe, value: object.isFollowingCurrentUser)
    managedObject.setValueIfNotNil(\UserManagedObject.isFollowedByMe, value: object.isFollowedByCurrentUser)
    managedObject.setValueIfNotNil(\UserManagedObject.isFriend, value: object.isFriendWithCurrentUser)
    managedObject.setValueIfNotNil(\UserManagedObject.isMe, value: object.isCurrent )
    managedObject.setValueIfNotNil(\UserManagedObject.isFriendshipDenied, value: object.isFriendshipDeniedByCurrentUser)
    
    managedObject.setValueIfNotNil(\UserManagedObject.isOutboundFriendRequested, value: object.isOutboundFriendshipRequested)
    managedObject.setValueIfNotNil(\UserManagedObject.isInboundFriendRequested, value: object.isInboundFriendshipRequested)
    
    managedObject.setValueIfNotNil(\UserManagedObject.earnedRewards, value: object.earnedBrushRewards.map { NSDecimalNumber(value: $0) })
    
    managedObject.setValueIfNotNil(\UserManagedObject.rewardsLimit, value: object.brushRewardsLimit.map { NSDecimalNumber(value: $0) })
   
    managedObject.setValueIfNotNil(\UserManagedObject.availablePoints, value: object.availableLevelUpPoints.map { Int32($0) })
    managedObject.setValueIfNotNil(\UserManagedObject.necessaryPoints, value: object.necessaryLevelUpPoints.map { Int32($0) })
    
    managedObject.setValueIfNotNil(\UserManagedObject.followersCount, value: object.userFollowersCount.map { Int32($0) })
    managedObject.setValueIfNotNil(\UserManagedObject.followingsCount, value: object.userFollowingsCount.map { Int32($0) })
    managedObject.setValueIfNotNil(\UserManagedObject.friendsCount, value: object.userFriendsCount.map { Int32($0) })
    managedObject.setValueIfNotNil(\UserManagedObject.postsCount, value: object.userPostsCount.map { Int32($0) })
    
    managedObject.setValueIfNotNil(\UserManagedObject.profileDescription, value: object.userProfileDescription)
    managedObject.setValueIfNotNil(\UserManagedObject.profileFirstName, value: object.userProfileFirstName)
    managedObject.setValueIfNotNil(\UserManagedObject.profileLastName, value: object.userProfileLastName)
    managedObject.setValueIfNotNil(\UserManagedObject.profileSiteAddress, value: object.userProfileSiteName)
    managedObject.setValueIfNotNil(\UserManagedObject.email, value: object.userEmail)
    
    
    managedObject.setValueIfNotNil(\UserManagedObject.isBanned, value: object.isBannedUser)
    
    managedObject.setValueIfNotNil(\UserManagedObject.prizeWon, value: object.userWonPrizeAmount.map { NSDecimalNumber(value: $0) })
    
    
    let _ = object.userWallets?
      .map { return WalletManagedObject.replaceOrCreate(with: $0, in: context) }
      .forEach { $0.user = managedObject }

    object.walletBalances?.forEach {
      switch $0.currency {
      case .pibble:
        managedObject.pibBalance = NSDecimalNumber(value: $0.value)
      case .etherium:
        managedObject.ethBalance = NSDecimalNumber(value: $0.value)
      case .greenBrush:
        managedObject.greenBrushBalance = NSDecimalNumber(value: $0.value)
      case .redBrush:
        managedObject.redBrushBalance = NSDecimalNumber(value: $0.value)
      case .won:
        break
      case .bitcoin:
        managedObject.btcBalance = NSDecimalNumber(value: $0.value)
      case .australianDollar:
        break
      case .greatBritainPound:
        break
      case .canadianDollar:
        break
      case .chineseYuan:
        break
      case .euro:
        break
      case .japaneseYen:
        break
      case .usDollar:
        break
      case .unsupportedCurrency:
        break
      case .pibbleKlaytn:
        managedObject.pibKlaytnBalance = NSDecimalNumber(value: $0.value)
      case .klaytn:
        managedObject.klaytnBalance = NSDecimalNumber(value: $0.value)
      }
    }
    return managedObject
  }
}

extension UserManagedObject: UserProtocol {
  var userWonPrizeAmount: Double? {
    return prizeWon?.doubleValue ?? 0.0
  }
  
  var isBannedUser: Bool {
    return isBanned
  }
  
  var userProfileSiteName: String {
    return profileSiteAddress ?? ""
  }
  
  var userEmail: String? {
    return email
  }
  
  var userProfileFirstName: String {
    return profileFirstName ?? ""
  }
  
  var userProfileLastName: String {
    return profileLastName ?? ""
  }
  
  var userProfileDescription: String {
    return profileDescription ?? ""
  }
  
  var currentUserInteractionStatus: UserIntractionStatusProtocol? {
    return nil
  }
  
  var isOutboundFriendshipRequested: Bool {
    return isOutboundFriendRequested
  }
  
  var isInboundFriendshipRequested: Bool {
    return isInboundFriendRequested
  }
  
  var isFriendshipDeniedByCurrentUser: Bool? {
    return isFriendshipDenied
  }
  
  var isCurrent: Bool? {
    return isMe
  }
  
  var userFollowersCount: Int {
    return Int(followersCount)
  }
  
  var userFollowingsCount: Int {
    return Int(followingsCount)
  }
  
  var userFriendsCount: Int {
    return Int(friendsCount)
  }
  
  var userPostsCount: Int {
    return Int(postsCount)
  }
  
  var earnedBrushRewards: Double {
    return earnedRewards?.doubleValue ?? 0.0
  }
  
  var brushRewardsLimit: Double {
    return rewardsLimit?.doubleValue ?? 0.0
  }
  
  var availableLevelUpPoints: Int {
    return Int(availablePoints)
  }
  
  var necessaryLevelUpPoints: Int {
    return Int(necessaryPoints)
  }
  
  var isFollowingCurrentUser: Bool {
    return isFollowingMe
  }
  
  var isFollowedByCurrentUser: Bool {
    return isFollowedByMe
  }
  
  var isFriendWithCurrentUser: Bool {
    return isFriend
  }
  
  var userWallCoverUrlString: String {
    return wallCover ?? ""
  }
  
  var userWallets: [WalletProtocol] {
    return wallets?.allObjects as? [WalletManagedObject] ?? []
  }
  
  var greenBrushWalletBalance: Double {
    return greenBrushBalance?.doubleValue ?? 0.0
  }
  
  var redBrushWalletBalance: Double {
    return redBrushBalance?.doubleValue ?? 0.0
  }
  

 var userUUID: String {
    return uuid ?? ""
  }
  
  var userpicUrlString: String {
    return avatar ?? ""
  }
  
  var identifier: Int {
    return Int(id)
  }
  
  var userName: String {
    return name ?? ""
  }
  
  var walletBalances: [BalanceProtocol] {
    return [
      Balance(currency: .pibble, value: pibBalance?.doubleValue ?? 0.0),
      Balance(currency: .pibbleKlaytn, value: pibKlaytnBalance?.doubleValue ?? 0.0),
      Balance(currency: .klaytn, value: klaytnBalance?.doubleValue ?? 0.0),
      Balance(currency: .greenBrush, value: greenBrushBalance?.doubleValue ?? 0.0),
      Balance(currency: .redBrush, value: redBrushBalance?.doubleValue ?? 0.0),
      Balance(currency: .etherium, value: ethBalance?.doubleValue ?? 0.0),
      Balance(currency: .bitcoin, value: btcBalance?.doubleValue ?? 0.0)
    ]
  }
  
  var userLevel: Int {
    return Int(level)
  }
}

enum UserRelations: CoreDataStorableRelation {
  case following(UserProtocol, follows: UserProtocol)
  case followed(UserProtocol, by: UserProtocol)
  case friend(UserProtocol, of: UserProtocol)
  case muted(UserProtocol, by: UserProtocol)
  case sentFundsRecently(UserProtocol, to: UserProtocol)
  case receivedFundsRecently(UserProtocol, from: UserProtocol)
  
  case upvotedPostings(UserProtocol, posting: PartialPostingProtocol)
  case purchasedCommercePosts(UserProtocol, posting: PartialPostingProtocol)
  
  case registeredReferralUsers(PartialUserProtocol, referralOwner: UserProtocol)
  case referralOwnerUserFor(UserProtocol, referralOwner: UserProtocol)
  
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    switch self {
    case .following(let user, let follows):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedFollows = UserManagedObject.replaceOrCreate(with: follows, in: context)
      managedUser.addToFollows(managedFollows)
    case .followed(let user, let by):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedBy = UserManagedObject.replaceOrCreate(with: by, in: context)
      managedUser.addToFollowedBy(managedBy)
    case .friend(let user, let of):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedOf = UserManagedObject.replaceOrCreate(with: of, in: context)
      managedUser.addToFriends(managedOf)
    case .muted(let mutedUser, let byUser):
      let managedMutedUser = UserManagedObject.replaceOrCreate(with: mutedUser, in: context)
      let managedUser = UserManagedObject.replaceOrCreate(with: byUser, in: context)
      managedUser.addToMutedUsers(managedMutedUser)
    case .sentFundsRecently(let user, let to):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedTo = UserManagedObject.replaceOrCreate(with: to, in: context)
      managedUser.addToSentFundsRecently(managedTo)
    case .receivedFundsRecently(let user, let from):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedFrom = UserManagedObject.replaceOrCreate(with: from, in: context)
      managedUser.addToReceivedFundsRecently(managedFrom)
    case .upvotedPostings(let user, let posting):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedPosting = PostingManagedObject.updateOrCreate(with: posting, in: context)
      managedUser.addToUpvotedPostings(managedPosting)
    case .purchasedCommercePosts(let user, let posting):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedPosting = PostingManagedObject.updateOrCreate(with: posting, in: context)
      managedUser.addToPurchasedCommercePosts(managedPosting)
    case .registeredReferralUsers(let referralUser, let ownerUser):
      let managedReferralUser = UserManagedObject.updateOrCreate(with: referralUser, in: context)
      let managedOwnerUserFrom = UserManagedObject.replaceOrCreate(with: ownerUser, in: context)
      managedOwnerUserFrom.addToRegisteredReferralUsers(managedReferralUser)
    case .referralOwnerUserFor(let referralUser, let referralOwner):
      let managedReferralUser = UserManagedObject.replaceOrCreate(with: referralUser, in: context)
      let managedOwnerUserFrom = UserManagedObject.replaceOrCreate(with: referralOwner, in: context)
      managedOwnerUserFrom.addToRegisteredReferralUsers(managedReferralUser)
    }
  }
  
  func delete(in context: NSManagedObjectContext) {
    switch self {
    case .following(let user, let follows):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedFollows = UserManagedObject.replaceOrCreate(with: follows, in: context)
      managedUser.removeFromFollows(managedFollows)
    case .followed(let user, let by):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedBy = UserManagedObject.replaceOrCreate(with: by, in: context)
      managedUser.removeFromFollowedBy(managedBy)
    case .friend(let user, let of):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedOf = UserManagedObject.replaceOrCreate(with: of, in: context)
      managedUser.removeFromFriends(managedOf)
    case .muted(let user, let byUser):
      let managedMutedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedUser = UserManagedObject.replaceOrCreate(with: byUser, in: context)
      managedUser.removeFromMutedUsers(managedMutedUser)
    case .sentFundsRecently(let user, let to):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedTo = UserManagedObject.replaceOrCreate(with: to, in: context)
      managedUser.removeFromSentFundsRecently(managedTo)
    case .receivedFundsRecently(let user, let from):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedFrom = UserManagedObject.replaceOrCreate(with: from, in: context)
      managedUser.removeFromReceivedFundsRecently(managedFrom)
    case .upvotedPostings(let user, let posting):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedPosting = PostingManagedObject.updateOrCreate(with: posting, in: context)
      managedUser.removeFromUpvotedPostings(managedPosting)
    case .purchasedCommercePosts(let user, let posting):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedPosting = PostingManagedObject.updateOrCreate(with: posting, in: context)
      managedUser.removeFromPurchasedCommercePosts(managedPosting)
    case .registeredReferralUsers(let referralUser, let ownerUser):
      let managedReferralUser = UserManagedObject.updateOrCreate(with: referralUser, in: context)
      let managedOwnerUserFrom = UserManagedObject.replaceOrCreate(with: ownerUser, in: context)
      managedOwnerUserFrom.removeFromRegisteredReferralUsers(managedReferralUser)
    case .referralOwnerUserFor(let referralUser, let referralOwner):
      let managedReferralUser = UserManagedObject.replaceOrCreate(with: referralUser, in: context)
      let managedOwnerUserFrom = UserManagedObject.replaceOrCreate(with: referralOwner, in: context)
      managedOwnerUserFrom.removeFromRegisteredReferralUsers(managedReferralUser)
    }
  }
}


enum PartialUserRelations: CoreDataStorableRelation {
  case following(PartialUserProtocol, follows: UserProtocol)
  case followed(PartialUserProtocol, by: UserProtocol)
  case friend(PartialUserProtocol, of: UserProtocol)
  case muted(PartialUserProtocol, by: UserProtocol)
  case sentFundsRecently(UserProtocol, to: PartialUserProtocol)
  case receivedFundsRecently(UserProtocol, from: UserProtocol)
  
  case upvotedPostings(UserProtocol, posting: PartialPostingProtocol)
  case purchasedCommercePosts(UserProtocol, posting: PartialPostingProtocol)
  
  case registeredReferralUsers(PartialUserProtocol, referralOwner: UserProtocol)
  case referralOwnerUserFor(UserProtocol, referralOwner: PartialUserProtocol)
  
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    switch self {
    case .following(let user, let follows):
      let managedUser = UserManagedObject.updateOrCreate(with: user, in: context)
      let managedFollows = UserManagedObject.replaceOrCreate(with: follows, in: context)
      managedUser.addToFollows(managedFollows)
    case .followed(let user, let by):
      let managedUser = UserManagedObject.updateOrCreate(with: user, in: context)
      let managedBy = UserManagedObject.replaceOrCreate(with: by, in: context)
      managedUser.addToFollowedBy(managedBy)
    case .friend(let user, let of):
      let managedUser = UserManagedObject.updateOrCreate(with: user, in: context)
      let managedOf = UserManagedObject.replaceOrCreate(with: of, in: context)
      managedUser.addToFriends(managedOf)
    case .muted(let mutedUser, let byUser):
      let managedMutedUser = UserManagedObject.updateOrCreate(with: mutedUser, in: context)
      let managedUser = UserManagedObject.replaceOrCreate(with: byUser, in: context)
      managedUser.addToMutedUsers(managedMutedUser)
    case .sentFundsRecently(let user, let to):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedTo = UserManagedObject.updateOrCreate(with: to, in: context)
      managedUser.addToSentFundsRecently(managedTo)
    case .receivedFundsRecently(let user, let from):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedFrom = UserManagedObject.replaceOrCreate(with: from, in: context)
      managedUser.addToReceivedFundsRecently(managedFrom)
    case .upvotedPostings(let user, let posting):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedPosting = PostingManagedObject.updateOrCreate(with: posting, in: context)
      managedUser.addToUpvotedPostings(managedPosting)
    case .purchasedCommercePosts(let user, let posting):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedPosting = PostingManagedObject.updateOrCreate(with: posting, in: context)
      managedUser.addToPurchasedCommercePosts(managedPosting)
    case .registeredReferralUsers(let referralUser, let ownerUser):
      let managedReferralUser = UserManagedObject.updateOrCreate(with: referralUser, in: context)
      let managedOwnerUserFrom = UserManagedObject.replaceOrCreate(with: ownerUser, in: context)
      managedOwnerUserFrom.addToRegisteredReferralUsers(managedReferralUser)
    case .referralOwnerUserFor(let referralUser, let referralOwner):
      let managedReferralUser = UserManagedObject.replaceOrCreate(with: referralUser, in: context)
      let managedOwnerUserFrom = UserManagedObject.updateOrCreate(with: referralOwner, in: context)
      managedOwnerUserFrom.addToRegisteredReferralUsers(managedReferralUser)
    }
  }
  
  func delete(in context: NSManagedObjectContext) {
    switch self {
    case .following(let user, let follows):
      let managedUser = UserManagedObject.updateOrCreate(with: user, in: context)
      let managedFollows = UserManagedObject.replaceOrCreate(with: follows, in: context)
      managedUser.removeFromFollows(managedFollows)
    case .followed(let user, let by):
      let managedUser = UserManagedObject.updateOrCreate(with: user, in: context)
      let managedBy = UserManagedObject.replaceOrCreate(with: by, in: context)
      managedUser.removeFromFollowedBy(managedBy)
    case .friend(let user, let of):
      let managedUser = UserManagedObject.updateOrCreate(with: user, in: context)
      let managedOf = UserManagedObject.replaceOrCreate(with: of, in: context)
      managedUser.removeFromFriends(managedOf)
    case .muted(let user, let byUser):
      let managedMutedUser = UserManagedObject.updateOrCreate(with: user, in: context)
      let managedUser = UserManagedObject.replaceOrCreate(with: byUser, in: context)
      managedUser.removeFromMutedUsers(managedMutedUser)
    case .sentFundsRecently(let user, let to):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedTo = UserManagedObject.updateOrCreate(with: to, in: context)
      managedUser.removeFromSentFundsRecently(managedTo)
    case .receivedFundsRecently(let user, let from):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedFrom = UserManagedObject.replaceOrCreate(with: from, in: context)
      managedUser.removeFromReceivedFundsRecently(managedFrom)
    case .upvotedPostings(let user, let posting):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedPosting = PostingManagedObject.updateOrCreate(with: posting, in: context)
      managedUser.removeFromUpvotedPostings(managedPosting)
    case .purchasedCommercePosts(let user, let posting):
      let managedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      let managedPosting = PostingManagedObject.updateOrCreate(with: posting, in: context)
      managedUser.removeFromPurchasedCommercePosts(managedPosting)
    case .registeredReferralUsers(let referralUser, let ownerUser):
      let managedReferralUser = UserManagedObject.updateOrCreate(with: referralUser, in: context)
      let managedOwnerUserFrom = UserManagedObject.replaceOrCreate(with: ownerUser, in: context)
      managedOwnerUserFrom.removeFromRegisteredReferralUsers(managedReferralUser)
    case .referralOwnerUserFor(let referralUser, let referralOwner):
      let managedReferralUser = UserManagedObject.replaceOrCreate(with: referralUser, in: context)
      let managedOwnerUserFrom = UserManagedObject.updateOrCreate(with: referralOwner, in: context)
      managedOwnerUserFrom.removeFromRegisteredReferralUsers(managedReferralUser)
    }
  }
}

extension UserManagedObject: ObservableManagedObjectProtocol {
  static func createObservable(with object: UserProtocol, in context: NSManagedObjectContext) -> ObservableManagedObject<UserManagedObject> {
    let id = Int32(object.identifier)
    let fetchRequest: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
    let observableManagedObject = ObservableManagedObject<UserManagedObject>(id, fetchRequest: fetchRequest, context: context)
    return observableManagedObject
  }
}

extension UserProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = UserManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = UserManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialUserProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = UserManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = UserManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension UserManagedObject {
  func setMuteState(_ muted: Bool) {
    isMuted = muted
    mediaPostings?.forEach {
      if let usersPosting = ($0 as? PostingManagedObject), !usersPosting.isFault {
        usersPosting.triggerRefresh()
      }
    }
  }
  
  func setFollowState(_ following: Bool) {
    isFollowedByMe = following
    //we do not change isRecommended locally to keep order of main feed
    
    //let postsMayBeRecommended = isFollowedByMe || isMe || isFriend
    mediaPostings?.forEach {
      if let usersPosting = ($0 as? PostingManagedObject), !usersPosting.isFault {
        usersPosting.triggerRefresh()
//        if !postsMayBeRecommended {
//          usersPosting.isRecommendedInMainFeed = postsMayBeRecommended && usersPosting.isFreshPost
//        }
      }
    }
  }
}

//MARK:- Helpers

extension UserManagedObject {
  fileprivate func updateInteractionStatus(_ status: UserIntractionStatusProtocol?) {
    guard let interactionStatus = status else {
      return
    }
    
    let shouldTriggerPostsUpdate =
      isFollowingMe != interactionStatus.isFollowingCurrentUser ||
        isFollowedByMe != interactionStatus.isFollowedByCurrentUser ||
        isFriend != interactionStatus.isFriendWithCurrentUser ||
        isMuted != interactionStatus.isMutedByCurrentUser
    
    isFollowingMe = interactionStatus.isFollowingCurrentUser
    isFollowedByMe = interactionStatus.isFollowedByCurrentUser
    isFriend = interactionStatus.isFriendWithCurrentUser
    isMuted = interactionStatus.isMutedByCurrentUser
    
    if shouldTriggerPostsUpdate {
      mediaPostings?.forEach {
        if let usersPosting = ($0 as? PostingManagedObject) {
          usersPosting.triggerRefresh()
        }
      }
    }
  }
}
