//
//  CampaignPickModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 29.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum CampaignPick {
  
  struct CampaignPickItemViewModel: CampaignPickItemViewModelProtocol {
    let teamTitle: String
    let campaignLogoPlaceholder: UIImage?
   
    let campaignLogoURLString: String
    let campaignTitle: String
    let campaignInfo: NSAttributedString
    let campaignGoals: NSAttributedString
    let isSelected: Bool
    let selectedItemImage: UIImage
    
    init(fundingCamgaignTeam: FundingCampaignTeamProtocol, isSelected: Bool) {
      self.isSelected = isSelected
      selectedItemImage = UIImage(imageLiteralResourceName: "CampaignPick-CampaignTeamSelection")

      campaignLogoPlaceholder = UIImage.avatarImageForTitleString(fundingCamgaignTeam.teamTitle)
      campaignLogoURLString = fundingCamgaignTeam.teamLogoUrlString
      campaignTitle = fundingCamgaignTeam.fundingCampaign?.campaignTitle ?? ""
      
      teamTitle = fundingCamgaignTeam.teamTitle
      
      let raise = String(format:"%.0f", fundingCamgaignTeam.fundingCampaign?.campaignCollectedAmount ?? 0.0)
      let goal = String(format:"%.0f", fundingCamgaignTeam.fundingCampaign?.campaignGoalAmount ?? 0.0)
      let currency = CampaignPick.Strings.currency.localize()
      let campaignGoalsString = "\(CampaignPick.Strings.raise.localize()): \(raise) \(currency) \(CampaignPick.Strings.goal.localize()) \(goal) \(currency)"
      
      campaignGoals =  NSAttributedString(string: campaignGoalsString,
                                          attributes: [
                                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 12.0),
                                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.fundinCampaignInfo
        ])
      
      var createdAtString = ""
      
      if let date = fundingCamgaignTeam.fundingCampaign?.campaignStartDate {
        let dateString = Date.campaignDateFormat.string(from: date)
        createdAtString = "\(CampaignPick.Strings.createdAt.localize()) \(dateString)"
      }
      
      let members = fundingCamgaignTeam.teamMembersCount 
      let fundinCampaignInfoString = "\(CampaignPick.Strings.members.localize()): \(members) \(createdAtString)"
      
      campaignInfo =  NSAttributedString(string: fundinCampaignInfoString,
                                          attributes: [
                                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 12.0),
                                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.fundinCampaignInfo
        ])
    }
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let fundinCampaignInfo = UIColor.gray84
  }
}


extension Date {
  fileprivate static let campaignDateFormat: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    return dateFormatter
  }()

}

extension CampaignPick {
  enum Strings: String, LocalizedStringKeyProtocol {
    case members = "Members"
    case createdAt = "Created at"
    case raise = "Raise"
    case goal = "Goal"
    case currency = "PIB"
  }
}
