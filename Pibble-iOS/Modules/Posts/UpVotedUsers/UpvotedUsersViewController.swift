//
//  UpvotedUsersViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: UpvotedUsersView Class
final class UpvotedUsersViewController: ViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var bottomSlideOutContainerView: UIView!
  @IBOutlet weak var bottomSlideOutContentView: UIView!
  
  @IBOutlet weak var backgroundDimView: UIView!
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var contentContainerView: UIView!
 
  @IBOutlet weak var contentCollapsedConstraint: NSLayoutConstraint!
  @IBOutlet weak var contentExtendedConstraint: NSLayoutConstraint!
  
  //MARK:- Properties
  
  fileprivate var cachedCellsSizes: [IndexPath: CGSize] = [:]
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAppearance()
    setContentViewHidden(true, animated: false) {}
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setContentViewHidden(false, animated: true) {}
  }
  
  @IBAction func hideAction(_ sender: Any) {
    setContentViewHidden(true, animated: true) { [weak self]  in
      self?.presenter.handleHideAction()
    }
  }
}


//MARK: - UpvotedUsersView API
extension UpvotedUsersViewController: UpvotedUsersViewControllerApi {
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

// MARK: - UpvotedUsersView Viper Components API
fileprivate extension UpvotedUsersViewController {
  var presenter: UpvotedUsersPresenterApi {
    return _presenter as! UpvotedUsersPresenterApi
  }
}

extension UpvotedUsersViewController {
  fileprivate func setContentViewHidden(_ hidden: Bool, animated: Bool, complete: @escaping () -> Void) {
    let alpha: CGFloat = hidden ? 0.0 : 0.4
    
    guard animated else {
      contentExtendedConstraint.priority = hidden ? .defaultLow : .defaultHigh
      contentCollapsedConstraint.priority = !hidden ? .defaultLow : .defaultHigh
      
      backgroundDimView.alpha = alpha
      complete()
      return
    }
    
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.contentExtendedConstraint.priority = hidden ? .defaultLow : .defaultHigh
      self?.contentCollapsedConstraint.priority = !hidden ? .defaultLow : .defaultHigh
      
      self?.backgroundDimView.alpha = alpha
      self?.bottomSlideOutContainerView.layoutIfNeeded()
    }) { (_) in
      complete()
    }
  }
  
  fileprivate func setBackgroundImageView() {
    backgroundImageView.image = presentingViewController?.view.takeSnapshot()
  }
  
  fileprivate func setupView() {
    tableView.registerCell(UpvotedUsersTableViewCell.self)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UIConstants.itemCellsEstimatedHeight
    
    tableView.contentInset.bottom = UIConstants.bottomContentOffset
    
  }
  
  func setupAppearance() {
    bottomSlideOutContentView.layer.cornerRadius = 12.0
    bottomSlideOutContentView.clipsToBounds = true
    
    setBackgroundImageView()
  }
}

extension UpvotedUsersViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewModel = presenter.itemViewModelAt(indexPath)
    let cell = tableView.dequeueReusableCell(cell: UpvotedUsersTableViewCell.self, for: indexPath)
    cell.setViewModel(viewModel, handler: itemsActionHandler)
    return cell
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
}

extension UpvotedUsersViewController {
  fileprivate func itemsActionHandler(_ cell: UITableViewCell, aciton: UpvotedUsers.ItemsAction) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    presenter.handleActionAt(indexPath, aciton: aciton)
  }
}


fileprivate enum UIConstants {
  static let bottomContentOffset: CGFloat = 60
  static let itemCellsEstimatedHeight: CGFloat = 60
}

