//
//  PostsFeedHomeTopGroupsHeaderView.swift
//  Pibble
//
//  Created by Sergey Kazakov on 17/07/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PostsFeedHomeTopGroupsHeaderView: NibLoadingView {
  fileprivate static let bannerMessageAnimationKey = "bannerMessageAnimationKey"
  
  @IBOutlet var contentView: UIView!
  
  @IBOutlet weak var collectionContainerView: UIView!
  
  @IBOutlet weak var bannerContainerView: UIView!
  
  @IBOutlet weak var footerContainerView: UIView!
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var bannerImageView: UIImageView!
  
  @IBOutlet weak var timerLabel: UILabel!
  
  @IBOutlet weak var leaderboardButton: UIButton!
  
  @IBOutlet weak var bottomSeparatorView: UIView!
  
  @IBOutlet weak var bottomSectionView: UIView!
  
  @IBOutlet weak var bannerMessageContainerView: UIView!
  
  @IBOutlet weak var bannerMessageLabel: UILabel!
  
  @IBOutlet weak var bottomSectionTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    
  @IBAction func showLeaderboardAction(_ sender: Any) {
    handler?(self, .showLeaderboard)
  }
  
  @IBAction func showTopBannerInfo(_ sender: Any) {
    handler?(self, .showTopBannerInfo)
  }
  
  
  fileprivate var handler: PostsFeed.TopGroupsHeaderActionHandler?
  
  fileprivate var timer: Timer? {
    didSet {
      oldValue?.invalidate()
    }
  }
  
  fileprivate var viewModel: PostsFeedHomeTopGroupsHeaderViewModelProtocol? {
    didSet {
      guard let newViewModelValue = viewModel else {
        collectionView.reloadData()
        return
      }
      
      guard let oldViewModelValue = oldValue else {
        collectionView.reloadData()
        return
      }
      
      let updates = newViewModelValue.diffWithPrevious(oldViewModelValue)
      collectionView.performBatchUpdates({
        updates.forEach {
          switch $0 {
          case .reloadData:
            break
          case .beginUpdates:
            break
          case .endUpdates:
            break
          case .insert(let idx):
            collectionView.insertItems(at: idx)
          case .delete(let idx):
            collectionView.deleteItems(at: idx)
          case .insertSections(let idx):
            collectionView.insertSections(IndexSet(idx))
          case .deleteSections(let idx):
            collectionView.deleteSections(IndexSet(idx))
          case .updateSections(let idx):
            collectionView.reloadSections(IndexSet(idx))
          case .moveSections(let from, let to):
            collectionView.moveSection(from, toSection: to)
          case .update(let idx):
            collectionView.reloadItems(at: idx)
          case .move(let from, let to):
            collectionView.moveItem(at: from, to: to)
          }
        }
      })
    }
  }
  
  override func setupView() {
    super.setupView()
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.allowsSelection = true
    collectionView.registerCell(PostsFeedTopGroupCollectionViewCell.self)
    backgroundColor = UIColor.clear
    bannerHeightConstraint.constant = ceil(contentView.bounds.width / 2.05)
  }
  
  
  func animateBannerMessageIfNeeded() {
    guard let vm = viewModel else {
      return
    }
    
    guard vm.shouldShowBannerMessage else {
      return
    }
    
    animateBannerMessage()
  }
  
  func setViewModel(_ vm: PostsFeedHomeTopGroupsHeaderViewModelProtocol, handler: @escaping PostsFeed.TopGroupsHeaderActionHandler) {
    viewModel = vm
    self.handler = handler
    
    bannerImageView.setCachedImageOrDownload(vm.bannerImageURLString)
    bannerHeightConstraint.constant = ceil(contentView.bounds.width / 2.05)
    bottomSectionTopConstraint.constant = vm.shouldShowBanner ? 0.0 : -bottomSectionView.frame.height

    
    bannerMessageLabel.text = vm.bannerMessage
    
    bannerMessageContainerView.alpha = vm.shouldShowBannerMessage ? 1.0 : 0.0
    bottomSeparatorView.alpha = vm.shouldShowFooter ? 1.0 : 0.0
    bannerContainerView.alpha = vm.shouldShowBanner ? 1.0 : 0.0
    footerContainerView.alpha = vm.shouldShowFooter ? 1.0 : 0.0
    
    removeBannerMessageAnimation()
  
    guard vm.shouldShowFooter,
      let expirationDate = vm.expirationDate
    else {
      timer = nil
      timerLabel.text = ""
      return
    }
    
    let timerLabelFunc = vm.timerLabelForTimeInterval
    timerLabel.text = timerLabelFunc(expirationDate.timeIntervalSinceNow)
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] (_) in
      self?.timerLabel.text = timerLabelFunc(expirationDate.timeIntervalSinceNow)
    })
  }
}



extension PostsFeedHomeTopGroupsHeaderView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 80, height: 100)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel?.numberOfItemsInSection(section) ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let viewModel = viewModel else {
      return UICollectionViewCell()
    }
    
    let itemVM = viewModel.itemViewModelAt(indexPath)
    let cell = collectionView.dequeueReusableCell(cell: PostsFeedTopGroupCollectionViewCell.self, for: indexPath)
    cell.setViewModel(itemVM, handler: handleSelection)
    return cell
  }
  
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel?.numberOfSections() ?? 0
  }
  

  fileprivate func handleSelection(_ cell: UICollectionViewCell) {
    guard let indexPath = collectionView.indexPath(for: cell) else {
      return
    }
    
    handler?(self, .selectionAt(indexPath))
  }
  
  fileprivate func animateBannerMessage() {
    guard bannerMessageLabel.layer.animation(forKey: PostsFeedHomeTopGroupsHeaderView.bannerMessageAnimationKey) == nil else {
      return
    }
    
    let bannerMessageWidth = bannerMessageLabel.bounds.width
    let bannerMessageContainerViewWidth = bannerMessageContainerView.bounds.size.width
    let offset = (bannerMessageWidth +
      (bannerMessageLabel.frame.origin.x * 2)) - bannerMessageContainerViewWidth
    
    if offset > 0 {
      let velocity: CGFloat = 20.0
      let duration = Double(offset / velocity)
      
      let slidingAnimation = CABasicAnimation(keyPath: "transform.translation.x")
      
      slidingAnimation.fromValue = 0.0
      slidingAnimation.toValue = -offset
      slidingAnimation.duration = duration
      slidingAnimation.repeatCount = Float.infinity
      slidingAnimation.autoreverses = true
      bannerMessageLabel.layer.add(slidingAnimation, forKey: PostsFeedHomeTopGroupsHeaderView.bannerMessageAnimationKey)
    }
  }
  
  fileprivate func removeBannerMessageAnimation() {
    guard let _ = bannerMessageLabel.layer.animation(forKey: PostsFeedHomeTopGroupsHeaderView.bannerMessageAnimationKey) else {
      return
    }
    
    bannerMessageLabel.layer.removeAnimation(forKey: PostsFeedHomeTopGroupsHeaderView.bannerMessageAnimationKey)
  }
}

