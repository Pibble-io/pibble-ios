//
//  CreatePostHelpModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 26/09/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

enum CreatePostHelp {
  enum HelpType {
    case predefinedText(String)
  }
  
  enum Reward {
    case predefinedAmount(Int)
    case amount(Int?)
    
    static func == (lhs: Reward, rhs: Reward) -> Bool {
      switch lhs {
      case .predefinedAmount(let lhsAmount):
        switch rhs {
        case .predefinedAmount(let rhsAmount):
          return lhsAmount == rhsAmount
        case .amount(_):
          return false
        }
        
      case .amount(let lhsAmount):
        switch rhs {
        case .predefinedAmount(_):
          return false
        case .amount(let rhsAmount):
          guard let lhsAmount = lhsAmount, let rhsAmount = rhsAmount else {
            return false
          }
          
          return lhsAmount == rhsAmount
        }
      }
    }
  }
  
  class PostHelpDraft: MutablePostHelpDraftProtocol {
    var helpDescription: String = ""
    var reward: Reward?
    
    var canBePosted: Bool {
      return createPostHelpDraft != nil
    }
    
    var createPostHelpDraft: CreatePostHelpProtocol? {
      guard helpDescription.count > 0 else {
        return nil
      }
      
      guard let reward = reward else {
        return nil
      }
      
      switch reward {
      case .predefinedAmount(let amount):
        return CreatePostHelpDraft(reward: amount, description: helpDescription)
      case .amount(let pickedAmount):
        guard let amount = pickedAmount else {
          return nil
        }
        
        return CreatePostHelpDraft(reward: amount, description: helpDescription)
      }
    }
  }
  
  struct CreatePostHelpDraft: CreatePostHelpProtocol {
    let reward: Int
    let description: String
  }
  
  struct TypeItemViewModel: CreatePostHelpTypeItemViewModelProtocol {
    var title: String
    
    init(helpType: HelpType) {
      switch helpType {
      case .predefinedText(let text):
        title = text
      }
    }
  }
  
  struct RewardItemViewModel: CreatePostHelpRewardItemViewModelProtocol {
    var amount: String
    
    var isSelected: Bool
    
    init(reward: Reward, isSelected: Bool) {
      self.isSelected = isSelected
      
      switch reward {
      case .predefinedAmount(let amount):
        self.amount = "\(amount)"
      case .amount(let pickedAmount):
        self.amount = pickedAmount.map { "\($0)"} ?? CreatePostHelp.Strings.RewardTitles.set.localize()
      }
    }
  }
}

extension CreatePostHelp {
  enum Strings {
    enum HelpTypes: String, LocalizedStringKeyProtocol {
      case translateToEnglish = "Translate into English"
      case translateToKorean = "Translate into Korean"
    }
    
    enum RewardTitles: String, LocalizedStringKeyProtocol {
      case set = "Set"
    }
  }
}

