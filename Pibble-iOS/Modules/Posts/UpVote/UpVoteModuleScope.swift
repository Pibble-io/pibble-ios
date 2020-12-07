//
//  UpVoteModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum UpVote {
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
  }
  
  struct UpVoteViewModel {
    let minSliderValue: Float
    let maxSliderValue: Float
    let currentSliderValue: Float
    let currentUpVoteAmount: String
    let currentUpVoteCurrency: String
    let upvotePurposeTitle: NSAttributedString
  }
}
