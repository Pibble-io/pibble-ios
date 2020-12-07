//
//  UserProfileCountsStatusTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 06.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias UserProfileShowStatsActionHandler =  (UserProfileStatsTableViewCell, UserProfileContent.UserStatsShowActions) -> Void

class UserProfileStatsTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet var countLabels: [UILabel]!
  @IBOutlet var titleLabels: [UILabel]!
  
  @IBOutlet var showStatsButtons: [UIButton]!
  
  @IBAction func showStatsAction(_ sender: UIButton) {
    guard let buttonIdx = showStatsButtons.index(of: sender) else {
      return
    }
    
    guard buttonIdx < actions.count else {
      return
    }
    
    let action = actions[buttonIdx]
    handler?(self, action)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  fileprivate var actions: [UserProfileContent.UserStatsShowActions] = []
  
  fileprivate var handler: UserProfileShowStatsActionHandler?
  
  func setViewModel(_ vm: UserProfileCountsStatusViewModelProtocol, handler: @escaping UserProfileShowStatsActionHandler) {
    self.handler = handler
    let viewModelItemsCount = vm.countItems.count
    
    guard viewModelItemsCount == countLabels.count,
      viewModelItemsCount == titleLabels.count else {
        return
    }
    actions = []
    for (idx, viewModel) in vm.countItems.enumerated() {
      titleLabels[idx].text = viewModel.title
      countLabels[idx].text = viewModel.amount
      actions.append(viewModel.showStatAction)
    }
  }
}
