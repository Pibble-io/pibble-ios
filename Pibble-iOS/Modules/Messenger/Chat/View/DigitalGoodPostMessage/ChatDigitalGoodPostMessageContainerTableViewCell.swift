//
//  PostMessageTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 16/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class ChatDigitalGoodPostMessageContainerTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var messageBackgroundView: UIView!
  
  @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
  @IBOutlet weak var tableView: UITableView!
  fileprivate var tableViewContentSizeObserver: NSKeyValueObservation?
  
  deinit {
    tableViewContentSizeObserver = nil
  }
  
  fileprivate var handler: Chat.MessageActionHandler?
  
  fileprivate var viewModel: ChatDigitalGoodPostMessageViewModelProtocol? {
    didSet {
      tableView.reloadData()
      setNeedsLayout()
      layoutIfNeeded()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    
    tableView.isScrollEnabled = true
    
    tableViewContentSizeObserver = tableView.observe(\UITableView.contentSize) { [weak self] (object, observedChange) in

      self?.tableViewHeight.constant = object.contentSize.height
      self?.setNeedsLayout()
      self?.layoutIfNeeded()
    }
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UIConstants.itemCellsEstimatedHeights.comment
    
    tableView.registerCell(ChatDigitalGoodPostMessageContentDescriptionTableViewCell.self)
    tableView.registerCell(ChatDigitalGoodPostMessageContentDownloadActionTableViewCell.self)
    tableView.registerCell(ChatDigitalGoodPostMessageContentInvoiceStatusTableViewCell.self)
    
    messageBackgroundView.layer.cornerRadius = UIConstants.backgroundCornerRadius
    messageBackgroundView.clipsToBounds = true
    messageBackgroundView.layer.borderWidth = 1.0
    messageBackgroundView.layer.borderColor = UIConstants.Colors.messageBorder.cgColor
  }
  
  func setViewModel(_ vm: ChatDigitalGoodPostMessageViewModelProtocol, handler: @escaping Chat.MessageActionHandler) {
    self.handler = handler
    viewModel = vm
  }
}

extension ChatDigitalGoodPostMessageContainerTableViewCell: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel?.numberOfSections() ?? 0
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.numberOfItemsInSection(section) ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let itemVMType = viewModel?.itemAt(indexPath) else {
      return UITableViewCell()
    }
    
    switch itemVMType {
    case .description(let vm):
      let cell = tableView.dequeueReusableCell(cell: ChatDigitalGoodPostMessageContentDescriptionTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: itemActionHandler)
      return cell
    case .downloadAction:
      let cell = tableView.dequeueReusableCell(cell: ChatDigitalGoodPostMessageContentDownloadActionTableViewCell.self, for: indexPath)
      cell.setViewModel(handler: itemActionHandler)
      return cell
    case .invoiceStatus(let vm):
      let cell = tableView.dequeueReusableCell(cell: ChatDigitalGoodPostMessageContentInvoiceStatusTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    }
  }
}

extension ChatDigitalGoodPostMessageContainerTableViewCell {
  fileprivate func itemActionHandler(_ cell: UITableViewCell, action: Chat.MessageActions) {
    guard let _ = tableView.indexPath(for: cell) else {
      return
    }
    
    handler?(self, action)
  }
}

fileprivate enum UIConstants {
  enum itemCellsEstimatedHeights {
    static let comment: CGFloat = 10.0
  }
  
  static let backgroundCornerRadius: CGFloat = 12
  
  enum Colors {
    static let messageBorder = UIColor.bluePibble
  }
}
