//
//  ChatRoomsViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 16/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit
import SwipeCellKit

//MARK: ChatRoomsView Class

class ChatRoomsContentViewController: ViewController {
  @IBOutlet weak var tableView: UITableView!
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.shouldFireContentOffsetChangesNotifications = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    tableView.shouldFireContentOffsetChangesNotifications = false
  }
  
  //MARK:- Properties
  
  fileprivate var cachedCellsSizes: [IndexPath: CGSize] = [:]
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
  
//  fileprivate let panInteractionController = PanGestureSlideInteractionController(isRightEdge: false)
  
//  fileprivate lazy var pan: UIPanGestureRecognizer = {
//    let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
////    gesture.delegate = self
//    return gesture
//  }()
  
  
  //MARK:- methods
  
  func setNavBarViewModel(_ vm: ChatRoomsNavigationBarViewModelProtocol) {
    
  }
}

//MARK: - ChatRoomsView API

extension ChatRoomsContentViewController: ChatRoomsViewControllerApi {
  func showConfirmLeaveAlert() {
    let alertController = UIAlertController(title: ChatRooms.Strings.Alerts.leaveRoomAlertTitle.localize(), message: ChatRooms.Strings.Alerts.leaveRoomAlertMessage.localize(), safelyPreferredStyle: .alert)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let leave = UIAlertAction(title: ChatRooms.Strings.Alerts.leaveRoomAlertConfirm.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleConfirmLeaveCurrentSelectedRoom()
    }
    
    let cancel = UIAlertAction(title: ChatRooms.Strings.Alerts.leaveRoomAlertCancel.localize(), style: .default) {(action) in
      
    }
    
    alertController.addAction(cancel)
    alertController.addAction(leave)
    
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
    
  }
  
  func setNavigationBarViewModel(_ vm: ChatRoomsNavigationBarViewModelProtocol) {
    setNavBarViewModel(vm)
  }
  
  func reloadData() {
    tableView.reloadData()
  }
  
  func updateCollection(_ updates: CollectionViewModelUpdate) {
    if case CollectionViewModelUpdate.reloadData = updates {
      batchUpdates = []
      tableView.reloadData()
      return
    }
    
    guard case CollectionViewModelUpdate.endUpdates = updates else {
      batchUpdates.append(updates)
      return
    }
    
    tableView.beginUpdates()
    batchUpdates.forEach {
      switch $0 {
      case .reloadData:
        break
      case .beginUpdates:
        break
      case .endUpdates:
        break
      case .insert(let idx):
        tableView.insertRows(at: idx, with: .fade)
      case .delete(let idx):
        tableView.deleteRows(at: idx, with: .fade)
      case .insertSections(let idx):
        tableView.insertSections(IndexSet(idx), with: .fade)
      case .deleteSections(let idx):
        tableView.deleteSections(IndexSet(idx), with: .fade)
      case .updateSections(let idx):
        tableView.reloadSections(IndexSet(idx), with: .fade)
      case .moveSections(let from, let to):
        tableView.moveSection(from, toSection: to)
      case .update(let idx):
        tableView.reloadRows(at: idx, with: .fade)
      case .move(let from, let to):
        tableView.moveRow(at: from, to: to)
      }
    }
    
    tableView.endUpdates()
    batchUpdates = []
  }
}

// MARK: - ChatRoomsView Viper Components API
fileprivate extension ChatRoomsContentViewController {
  var presenter: ChatRoomsPresenterApi {
    return _presenter as! ChatRoomsPresenterApi
  }
}

//MARK:- Helpers

extension ChatRoomsContentViewController: GestureInteractionControllerDelegateProtocol {
  func hideAction() {
    presenter.handleHideAction()
  }
  
  func handlePresentActionWith(_ transition: GestureInteractionController) {
    presenter.handleHideAction()
  }
}

extension ChatRoomsContentViewController {
//  @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
//    panInteractionController.handleGesture(gestureRecognizer)
//    gestureRecognizer.setTranslation(CGPoint.zero, in: view)
//  }
  
  fileprivate func setupView() {
//    panInteractionController.delegate = self
//    view.addGestureRecognizer(pan)
//    transitionsController.dismissalAnimator?.interactiveTransitioning = panInteractionController
//
    tableView.registerCell(ChatRoomsItemTableViewCell.self)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UIConstants.itemCellsEstimatedHeight
    
    tableView.contentInset.bottom = UIConstants.bottomContentOffset
  }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ChatRoomsContentViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewModel = presenter.itemViewModelAt(indexPath)
    switch viewModel {
    case .loadingPlaceholder:
      return UITableViewCell()
    case .chatRoom(let vm):
      let cell = tableView.dequeueReusableCell(cell: ChatRoomsItemTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      cell.delegate = self
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cachedCellsSizes[indexPath] = cell.frame.size
    presenter.handleWillDisplayItem(indexPath)
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cachedCellsSizes[indexPath] = cell.frame.size
    presenter.handleDidEndDisplayItem(indexPath)
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return cachedCellsSizes[indexPath]?.height ?? UIConstants.itemCellsEstimatedHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    presenter.handleSelectActionAt(indexPath)
  }
}

//MARK:- SwipeTableViewCellDelegate
extension ChatRoomsContentViewController: SwipeTableViewCellDelegate {
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else {
      return nil
    }
    
    let viewModelType = presenter.itemViewModelAt(indexPath)
    
    switch viewModelType {
    case .loadingPlaceholder:
      return nil
    case .chatRoom(let vm):
      var actions: [SwipeAction] = []
      
      if vm.canBeLeaved {
        let action = SwipeAction(style: .destructive, title: vm.leaveTitle) { [weak self] action, indexPath in
          self?.presenter.handleLeaveRoomActionAt(indexPath)
        }
        
        action.backgroundColor = UIConstants.Colors.leaveRoomBackground
        actions.append(action)
      }
      
      if vm.canBeMuted {
        let action = SwipeAction(style: .destructive, title: vm.muteTitle) { [weak self] action, indexPath in
          self?.presenter.handleMuteActionAt(indexPath)
        }
        
        action.backgroundColor = UIConstants.Colors.muteRoomBackground
        actions.append(action)
      }
      
      return actions
    }
  }
}

//MARK:- UIConstants

fileprivate enum UIConstants {
  static let bottomContentOffset: CGFloat = 60
  static let itemCellsEstimatedHeight: CGFloat = 60
  
  enum Colors {
    static let leaveRoomBackground = UIColor.destructivePink
    static let muteRoomBackground = UIColor.gray191
  }
}
