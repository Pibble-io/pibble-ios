//
//  ChatDigitalGoodPostHeaderView.swift
//  Pibble
//
//  Created by Sergey Kazakov on 05/03/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class ChatDigitalGoodPostHeaderView: NibLoadingView {
  
  @IBOutlet var contentView: UIView!
  
  @IBOutlet weak var messageBackgroundView: UIView!
  
  @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
  @IBOutlet weak var tableView: UITableView!
  fileprivate var tableViewContentSizeObserver: NSKeyValueObservation?
  fileprivate var currentSelectedMediaItemIndex = 0
  
  deinit {
    tableViewContentSizeObserver = nil
  }
  
  fileprivate var handler: Chat.HeaderActionHandler?
  
  fileprivate var viewModel: ChatDigitalGoodPostHeaderViewModelProtocol? {
    didSet {
      currentSelectedMediaItemIndex = 0
      tableView.reloadData()
      setNeedsLayout()
      layoutIfNeeded()
    }
  }
  
  override func setupView() {
    super.setupView()
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
    
    tableView.registerCell(ChatDigitalGoodPostHeaderDescriptionTableViewCell.self)
    tableView.registerCell(ChatDigitalGoodPostHeaderActionTableViewCell.self)
    tableView.registerCell(ChatGoodsPostHeaderDescriptionTableViewCell.self)
    
    messageBackgroundView.layer.cornerRadius = UIConstants.backgroundCornerRadius
    messageBackgroundView.clipsToBounds = true
    messageBackgroundView.layer.borderWidth = 1.0
    messageBackgroundView.layer.borderColor = UIConstants.Colors.messageBorder.cgColor
  }
    
  func setViewModel(_ vm: ChatDigitalGoodPostHeaderViewModelProtocol, handler: @escaping Chat.HeaderActionHandler) {
    self.handler = handler
    viewModel = vm
    
    messageBackgroundView.layer.borderColor = vm.isHighligthed ?
      UIConstants.Colors.messageBorderHighlighted.cgColor :
      UIConstants.Colors.messageBorder.cgColor
  }
}

extension ChatDigitalGoodPostHeaderView: UITableViewDelegate, UITableViewDataSource {
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
    case .digitalGoodDescription(let vm):
      let cell = tableView.dequeueReusableCell(cell: ChatDigitalGoodPostHeaderDescriptionTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: descriptionCellActionsHandler)
      return cell
    case .goodsDescription(let vm):
      let cell = tableView.dequeueReusableCell(cell: ChatGoodsPostHeaderDescriptionTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: descriptionCellActionsHandler)
      return cell
    case .downloadAction(let vm):
      let cell = tableView.dequeueReusableCell(cell: ChatDigitalGoodPostHeaderActionTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: itemActionHandler)
      return cell
    case .buyAction(let vm):
      let cell = tableView.dequeueReusableCell(cell: ChatDigitalGoodPostHeaderActionTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: itemActionHandler)
      return cell
    case .showAction(let vm):
      let cell = tableView.dequeueReusableCell(cell: ChatDigitalGoodPostHeaderActionTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: itemActionHandler)
      return cell
    case .purchaseStatus(let vm):
      let cell = tableView.dequeueReusableCell(cell: ChatDigitalGoodPostHeaderActionTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: itemActionHandler)
      return cell
    }
  }
}

extension ChatDigitalGoodPostHeaderView {
  fileprivate func descriptionCellActionsHandler(_ cell: UITableViewCell, action: Chat.HeaderDescriptionActions) {
    guard let _ = tableView.indexPath(for: cell) else {
      return
    }
    
    switch action {
    case .selectedMediItemAt(let index):
      currentSelectedMediaItemIndex = index
    }
  }
  
  fileprivate func itemActionHandler(_ cell: UITableViewCell) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    guard let itemVMType = viewModel?.itemAt(indexPath) else {
      return
    }
    
    switch itemVMType {
    case .digitalGoodDescription(_):
      break
    case .goodsDescription(_):
      break
    case .downloadAction:
      handler?(self, .download)
    case .buyAction:
      handler?(self, .buy)
    case .showAction:
      handler?(self, .show(mediaItemIndex: currentSelectedMediaItemIndex))
    case .purchaseStatus(_):
      break
    }
  }
}



fileprivate enum UIConstants {
  enum itemCellsEstimatedHeights {
    static let comment: CGFloat = 10.0
  }
  
  static let backgroundCornerRadius: CGFloat = 4
  
  enum Colors {
    static let messageBorderHighlighted = UIColor.bluePibble
    static let messageBorder = UIColor.gray222
  }
}
