//
//  DonateModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum Donate {
  enum AmountPickType {
    case anyAmount
    case fixedStepAmount(Int)
  }
  
  enum UpvotePurpose {
    case posting
    case comment
    case user(Int)
  }
  
  struct UpVoteModel {
    let minUpvotes: Int
    let maxUpvotes: Int
    let available: Int
    let currentPickUpvoteAmount: Int
    let currency: BalanceCurrency
  }
  
  struct UpVoteViewModel {
    let minSliderValue: Float
    let maxSliderValue: Float
    let currentSliderValue: Float
    let currentUpVoteAmount: String
    let currentUpVoteCurrency: String
    let currentUpVoteCurrencyColor: UIColor
    let upvotePurposeTitle: NSAttributedString
    
    let isUpvoteEnabled: Bool
  }
    
}
