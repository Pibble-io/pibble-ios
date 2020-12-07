//
//  FundingCampaignTeam+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 30.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension FundingCampaignTeamManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func replace(with object: FundingCampaignTeamProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    name = object.teamTitle
    logoUrlString = object.teamLogoUrlString
    membersCount = Int32(object.teamMembersCount)
    fundingType = object.fundingCampaignType.rawValue
    
    if let teamCreator = object.teamCreator {
      user = UserManagedObject.replaceOrCreate(with: teamCreator, in: context)
    }
    
    if let fundingCampaign = object.fundingCampaign {
      campaign = FundingCampaignManagedObject.replaceOrCreate(with: fundingCampaign, in: context)
    }
      
    return self
  }
  
  fileprivate func update(with object: PartialFundingCampaignTeamProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    name = object.teamTitle
    logoUrlString = object.teamLogoUrlString
    membersCount = Int32(object.teamMembersCount)
    fundingType = object.fundingCampaignType.rawValue
    
    if let teamCreator = object.teamCreator {
      user = UserManagedObject.updateOrCreate(with: teamCreator, in: context)
    }
    
    if let fundingCampaign = object.fundingCampaign {
      campaign = FundingCampaignManagedObject.replaceOrCreate(with: fundingCampaign, in: context)
    }
    
    return self
  }
  
  static func replaceOrCreate(with object: FundingCampaignTeamProtocol, in context: NSManagedObjectContext) -> FundingCampaignTeamManagedObject {
    
    let managedObject = FundingCampaignTeamManagedObject.findOrCreate(with: FundingCampaignTeamManagedObject.ID(object.identifier), in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialFundingCampaignTeamProtocol, in context: NSManagedObjectContext) -> FundingCampaignTeamManagedObject {
    
    let managedObject = FundingCampaignTeamManagedObject.findOrCreate(with: FundingCampaignTeamManagedObject.ID(object.identifier), in: context)
    return managedObject.update(with: object, in: context)
  }
}

enum FundingCampaignTeamRelations: CoreDataStorableRelation {
  case searchResult(FundingCampaignTeamProtocol)
  
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    switch self {
    case .searchResult(let fundingCampaignTeam):
      let managedObject = FundingCampaignTeamManagedObject.replaceOrCreate(with: fundingCampaignTeam, in: context)
      managedObject.isSearchResult = true
    }
  }
  
  func delete(in context: NSManagedObjectContext) {
    switch self {
    case .searchResult(let fundingCampaignTeam):
      let managedObject = FundingCampaignTeamManagedObject.replaceOrCreate(with: fundingCampaignTeam, in: context)
      managedObject.isSearchResult = false
    }
  }
}

extension FundingCampaignTeamManagedObject: FundingCampaignTeamProtocol {
  var fundingCampaignType: CampaignType {
    return CampaignType(rawValue: fundingType ?? "")
  }
  
  var fundingCampaign: FundingCampaignProtocol? {
    return campaign
  }
  
  var teamCreator: UserProtocol? {
    return user
  }
  
  var teamMembersCount: Int {
    return Int(membersCount)
  }
  
  var identifier: Int {
    return Int(id)
  }
  
  var teamTitle: String {
    return name ?? ""
  }
  
  var teamLogoUrlString: String {
    return logoUrlString ?? ""
  }
}

extension FundingCampaignTeamProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = FundingCampaignTeamManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = FundingCampaignTeamManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialFundingCampaignTeamProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = FundingCampaignTeamManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = FundingCampaignTeamManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
