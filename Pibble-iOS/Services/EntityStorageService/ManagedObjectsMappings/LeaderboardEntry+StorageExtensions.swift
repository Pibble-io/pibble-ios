//
//  LeaderboardEntry+StorageExtensions.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 19/07/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension LeaderboardEntryManagedObject: MappableManagedObject {
  typealias ID = String?
  
  fileprivate func replace(with object: LeaderboardEntryProtocol, in context: NSManagedObjectContext) {
    id = object.identifier
    value = NSDecimalNumber(value: object.leaderboardValue)
    
    switch object.leaderboardType {
    case .days(let days):
      allHistoryChallenge = false
      dailyChallenge = Int32(days)
    case .allHistory:
      dailyChallenge = 0
      allHistoryChallenge = true
    }
    
    if let leaderboardUser = object.leaderboardUser {
      user = UserManagedObject.replaceOrCreate(with: leaderboardUser, in: context)
    }
  }
  
  fileprivate func update(with object: PartialLeaderboardEntryProtocol, in context: NSManagedObjectContext) {
    id = object.identifier
    value = NSDecimalNumber(value: object.leaderboardValue)
    
    switch object.leaderboardType {
    case .days(let days):
      allHistoryChallenge = false
      dailyChallenge = Int32(days)
    case .allHistory:
      dailyChallenge = -1
      allHistoryChallenge = true
    }
    
    if let leaderboardUser = object.leaderboardUser {
      user = UserManagedObject.updateOrCreate(with: leaderboardUser, in: context)
    }
  }
  
  static func replaceOrCreate(with object: LeaderboardEntryProtocol, in context: NSManagedObjectContext) -> LeaderboardEntryManagedObject {
    let managedObject = LeaderboardEntryManagedObject.findOrCreate(with: LeaderboardEntryManagedObject.ID(object.identifier), in: context)
    managedObject.replace(with: object, in: context)
    return managedObject
  }
  
  static func updateOrCreate(with object: PartialLeaderboardEntryProtocol, in context: NSManagedObjectContext) -> LeaderboardEntryManagedObject {
    let managedObject = LeaderboardEntryManagedObject.findOrCreate(with: LeaderboardEntryManagedObject.ID(object.identifier), in: context)
    managedObject.update(with: object, in: context)
    return managedObject
  }
}

extension LeaderboardEntryManagedObject: LeaderboardEntryProtocol {
  var leaderboardType: LeaderboardType {
    guard allHistoryChallenge else {
      return .days(Int(dailyChallenge))
    }
    
    return .allHistory
  }
  
  var identifier: String {
    return id ?? ""
  }
  
  var leaderboardValue: Double {
    return value?.doubleValue ?? 0.0
  }
  
  var leaderboardUser: UserProtocol? {
    return user
  }
}

extension LeaderboardEntryProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = LeaderboardEntryManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = LeaderboardEntryManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

enum LeaderboardRelations: CoreDataStorableRelation {
  case top(PartialLeaderboardEntryProtocol, isTop: Bool, sortId: Int)
  
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    switch self {
    case .top(let leaderboardEntry, let isTop, let sortId):
      let managedLeaderboardEntry = LeaderboardEntryManagedObject.updateOrCreate(with: leaderboardEntry, in: context)
      managedLeaderboardEntry.isTop = isTop
      managedLeaderboardEntry.sortId = Int32(sortId)
    }
  }
  
  func delete(in context: NSManagedObjectContext) {
    switch self {
    case .top(let leaderboardEntry, _, _):
      let managedLeaderboardEntry = LeaderboardEntryManagedObject.updateOrCreate(with: leaderboardEntry, in: context)
      switch leaderboardEntry.leaderboardType {
      case .days(_):
        managedLeaderboardEntry.dailyChallenge = -1
      case .allHistory:
        managedLeaderboardEntry.allHistoryChallenge = false
      }
    }
  }
}
