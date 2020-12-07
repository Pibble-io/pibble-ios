//
//  PostMessageContentDownloadTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 17/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class ChatDigitalGoodPostHeaderActionTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet weak var downloadButton: UIButton!
  @IBAction func downloadAction(_ sender: UIButton) {
    guard buttonHasDisabledState else {
      handler?(self)
      return
    }
    
    UIView.animate(withDuration: 0.1, animations: { [weak self] in
      self?.setButtonEnabled(false)
    }) { [weak self] (_) in
      guard let strongSelf = self else {
        return
      }
      strongSelf.handler?(strongSelf)
    }
  }
  
  fileprivate var handler: Chat.HeaderItemActionHandler?
  fileprivate var buttonHasDisabledState: Bool = false

  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: ChatDigitalGoodPostHeaderActionViewModelProtocol, handler: @escaping Chat.HeaderItemActionHandler) {
    self.handler = handler
    
    downloadButton.setTitleForAllStates(vm.title)
    downloadButton.setTitle(vm.disabledTitle, for: .disabled)
    setButtonEnabled(vm.hasEnabledState)
    buttonHasDisabledState = vm.hasDisabledState
  }
  
  fileprivate func setButtonEnabled(_ enabled: Bool) {
    downloadButton.setTitleColor(UIConstants.Colors.downloadButtonTitle, for: .normal)
    downloadButton.setTitleColor(UIConstants.Colors.downloadButtonTitleSelected, for: .disabled)
    
    downloadButton.layer.cornerRadius = 7.0
    downloadButton.layer.borderWidth = 1.0
    
    downloadButton.isEnabled = enabled
    
    guard enabled else {
      downloadButton.layer.borderColor = UIConstants.Colors.downloadButtonBorderSelected.cgColor
      downloadButton.backgroundColor =  UIConstants.Colors.downloadButtonBackgroundSelected
      return
    }
    
    downloadButton.layer.borderColor = UIConstants.Colors.downloadButtonBorder.cgColor
    downloadButton.backgroundColor =  UIConstants.Colors.downloadButtonBackground
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let downloadButtonBorder = UIColor.bluePibble
    static let downloadButtonBorderSelected = UIColor.white
    
    static let downloadButtonBackground = UIColor.white
    static let downloadButtonBackgroundSelected = UIColor.gray191
    
    static let downloadButtonTitle = UIColor.bluePibble
    static let downloadButtonTitleSelected = UIColor.white
  }
}
