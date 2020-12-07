//
//  PostsFeedUploadingStateTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 30/01/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit


typealias PostsFeedUploadingStateTableViewCellActionHandler = (PostsFeedUploadingStateTableViewCell, PostsFeed.UploadingActions) -> Void
class PostsFeedUploadingStateTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet weak var stateLabel: UILabel!
  @IBOutlet weak var progressBarView: UIView!
  
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var progressBarBackgroundView: UIView!
  @IBOutlet weak var progressBarWidthConstraint: NSLayoutConstraint!
  
  @IBAction func cancelAction(_ sender: Any) {
    progressBarWidthConstraint.constant = 0.0
    handler?(self, .cancel)
  }
  
  fileprivate var isAnimating: Bool = false
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  fileprivate var handler: PostsFeedUploadingStateTableViewCellActionHandler?
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: PostsFeedUploadingViewModelProtocol, handler: @escaping PostsFeedUploadingStateTableViewCellActionHandler) {
   
    self.handler = handler
    stateLabel.text = vm.stateTitle
    cancelButton.isHidden = !vm.cancelButtonEnabled
    
    let curProgressContraint = max(progressBarWidthConstraint.constant, progressBarBackgroundView.bounds.width * vm.progress)
    
    guard vm.progress.isLess(than: 1.0) else {
      UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
        self?.progressBarWidthConstraint.constant = curProgressContraint
        self?.progressBarBackgroundView.layoutIfNeeded()
        
      }) { [weak self] (_) in
        self?.progressBarWidthConstraint.constant = 0.0
        self?.progressBarView.isHidden = true
      }
      return
    }
    
    progressBarView.isHidden = false
    let progressDelta = CGFloat(Float.random(in: -0.2 ..< 0.2))
    let progress = min(0.9, vm.progress + progressDelta)
    let curProgressContraintWithRand = max(progressBarWidthConstraint.constant,
                                   progressBarBackgroundView.bounds.width * progress)
    
    progressBarWidthConstraint.constant = curProgressContraintWithRand
    UIView.animate(withDuration: 10.0, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
      self?.progressBarBackgroundView.layoutIfNeeded()
      
    }) { (_) in  }
  }
}
