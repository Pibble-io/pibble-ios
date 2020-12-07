//
//  PostingMediaCampaignTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 04.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias PostingMediaCampaignCellActionsHandler = (UITableViewCell, MediaPosting.FundingEditActions) -> Void

class PostingMediaCampaignTableViewCell: UITableViewCell, DequeueableCell {
  //static let identifier = "PostingMediaPromotionTableViewCell"
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var itemTitleLabel: UILabel!
  @IBOutlet weak var selectionImageView: UIImageView!
  
  fileprivate var viewModel: MediaPostingCampaignViewModelProtocol?
  fileprivate var handler: PostingMediaCampaignCellActionsHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  @IBAction func selectItemAction(_ sender: Any) {
    handler?(self, .campaignPickTypeSelectionChanged(isSelected: true))
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: MediaPostingCampaignViewModelProtocol, handler: @escaping PostingMediaCampaignCellActionsHandler) {
    self.handler = handler
    viewModel = vm
    itemTitleLabel.text = vm.title
   
    selectionImageView.image = vm.isSelected ?
      UIImage(imageLiteralResourceName: "MediaPosting-RoundedCheckBox-selected"):
      UIImage(imageLiteralResourceName: "MediaPosting-RoundedCheckBox")
  }
}

fileprivate enum UIConstants {
  static let cornerRadius: CGFloat = 5.0
  enum Colors {
    static let picked = UIColor.black
    static let notPicked = UIColor.gray168
  }
}
