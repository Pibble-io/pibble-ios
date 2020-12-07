//
//  PostsFeedContentCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 02.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import AVKit
import UIKit

class PostsFeedContentContainerTableViewCell: UITableViewCell, DequeueableCell {
  fileprivate let doubleTapAnimationDuration: TimeInterval = 0.3
  fileprivate let doubleTapHideAnimationDelay: TimeInterval = 0.2
  fileprivate let doubleTapHideAnimationDuration: TimeInterval = 0.15
  
  fileprivate var doubleTapAnimationFullDuration: TimeInterval {
    return 2 * doubleTapAnimationDuration + doubleTapHideAnimationDelay
  }
  fileprivate var lastDoubleTapAnimationDate: Date?
  
  @IBOutlet weak var videoIcon: UIImageView!
  @IBOutlet weak var durationLabel: UILabel!
  
  @IBOutlet weak var videoStatusContainerView: UIView!
  
  
  @IBOutlet weak var pageLabel: UILabel!
  @IBOutlet weak var contentCollectionView: UICollectionView!
  @IBOutlet weak var playPauseButton: UIButton!
  @IBOutlet weak var commerceVerificationErrorIconImageView: UIImageView!
  
  @IBOutlet weak var upvoteIconLargeImageView: UIImageView!
  
  @IBOutlet weak var muteSoundImageView: UIImageView!
  
  @IBOutlet weak var soundInfoMessageContainerView: UIView!
  @IBOutlet weak var soundInfoLabel: UILabel!
  
  @IBOutlet weak var soundInfoContainerView: UIView!
  
  @IBAction func playPauseAction(_ sender: Any) {
    contentCollectionView.visibleCells.forEach {
      if let videoCell = $0 as? PostsFeedVideoContentCollectionViewCell {
//        let playingState = videoCell.changePlayingState()
        videoCell.changePlayingState { [weak self] in
          guard let strongSelf = self else {
            return
          }
          strongSelf.setVideoIconAndDurationFor($0, vm: strongSelf.viewModel)
        }
      }
    }
  }
  
  fileprivate var videoDurationTimer: Timer? {
    didSet {
      oldValue?.invalidate()
    }
  }
  
  fileprivate var currentDurationTimeinterval: TimeInterval = 0.0 {
    didSet {
      
      if currentDurationTimeinterval.isLessThanOrEqualTo(0.0) {
        videoDurationTimer = nil
      }
      
      durationLabel.text = max(0.0, currentDurationTimeinterval).formattedMinutesSecondsTimeString
    }
  }
  
  fileprivate var itemLayout: PostsFeed.ItemLayout =  PostsFeed.ItemLayout.defaultLayout() {
    didSet {
      //contentCollectionView.collectionViewLayout.invalidateLayout()
    }
  }
  
  fileprivate var viewModel: PostsFeedContentViewModelProtocol? {
    didSet {
      contentCollectionView.reloadData()
    }
  }
  
  
  fileprivate var actionHandler: PostsFeed.ActionsTableViewCellHandler?
  fileprivate var isSoundInfoContainerViewAnimating: Bool = false
  
  //MARK:- private properties
  
  fileprivate lazy var doubleTapGestureRecognizer: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandler(_:)))
    gesture.delegate = self
    gesture.numberOfTapsRequired = 2
    return gesture
  }()
  
  fileprivate lazy var tapGestureRecognizer: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
    gesture.delegate = self
    gesture.numberOfTapsRequired = 1
    
    gesture.require(toFail: doubleTapGestureRecognizer)
    
    return gesture
  }()
  
  override func prepareForReuse() {
    super.prepareForReuse()
    videoDurationTimer = nil
    contentCollectionView.setContentOffset(CGPoint.zero, animated: false)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    contentCollectionView.addGestureRecognizer(doubleTapGestureRecognizer)
    contentCollectionView.addGestureRecognizer(tapGestureRecognizer)
    
    upvoteIconLargeImageView.alpha = 0.0
    
    contentCollectionView.delegate = self
    contentCollectionView.dataSource = self
    contentCollectionView.registerCell(PostsFeedVideoContentCollectionViewCell.self)
    contentCollectionView.registerCell(PostsFeedImageContentCollectionViewCell.self)
    pageLabel.layer.cornerRadius = 5.0
    pageLabel.clipsToBounds = true
    
    
    muteSoundImageView.setCornersToCircleByHeight()
    soundInfoMessageContainerView.setCornersToCircleByHeight()
    
    guard let layout = contentCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
      return
    }
   
    layout.sectionInset = UIEdgeInsets.zero
    layout.minimumLineSpacing = 0.0
    layout.minimumInteritemSpacing = 0.0
    contentCollectionView.contentInset = UIEdgeInsets.zero
  }
  
  func currentVisibleContentItemIndex() -> Int? {
    guard let indexPath = contentCollectionView.indexPathsForVisibleItems.first else {
      return nil
    }
    
    guard let vm = viewModel,
      indexPath.item < vm.numberOfItemsInSection(indexPath.section) else {
        return nil
    }
    
    return indexPath.item
  }
  
  func currentVisibleContentItemViewModel() -> PostsFeed.ContentViewModelType? {
    guard let indexPath = contentCollectionView.indexPathsForVisibleItems.first else {
      return nil
    }
    
    guard let vm = viewModel,
      indexPath.item < vm.numberOfItemsInSection(indexPath.section) else {
      return nil
    }
    
    return vm.itemViewModelAt(indexPath)
  }
  
  func setViewModel(_ vm: PostsFeedContentViewModelProtocol, layout: PostsFeed.ItemLayout, actionHandler: @escaping PostsFeed.ActionsTableViewCellHandler) {
    self.actionHandler = actionHandler
    itemLayout = layout
    viewModel = vm
    pageLabel.isHidden = vm.content.count <= 1
    let idx = IndexPath(item: 0, section: 0)
    setPageForIndexPath(idx)
    setVerificationErrorIconFor(idx)
    setVideoIconPresentationFor(idx)
  }
}

extension PostsFeedContentContainerTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return itemLayout.size
  }
  
  func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    contentCollectionView.visibleCells.forEach {
      if let videoCell = $0 as? PostsFeedVideoContentCollectionViewCell {
        videoCell.pause() { _ in }
        setVideoIconAndDurationFor(nil, vm: viewModel)
      }
    }
  }
  
  fileprivate func setVerificationErrorIconFor(_ indexPath: IndexPath) {
    guard let vm = viewModel else {
      return
    }
    
    guard indexPath.item < vm.numberOfItemsInSection(indexPath.section) else {
      return
    }
    
    let itemViewModelType = vm.itemViewModelAt(indexPath)
    
    switch itemViewModelType {
    case .image(let itemViewModel):
      commerceVerificationErrorIconImageView.alpha = itemViewModel.shouldPresentVerificationWarning ? 1.0 : 0.0
    case .video(_):
      commerceVerificationErrorIconImageView.alpha = 0.0
    }
  }
  
  fileprivate func setPageForIndexPath(_ indexPath: IndexPath) {
    let itemsCount = contentCollectionView.numberOfItems(inSection: indexPath.section)
    let itemNumber = indexPath.item + 1
    pageLabel.text = " \(itemNumber)/\(itemsCount) "
  }
  
  fileprivate func setVideoIconAndDurationFor(_ playingState: VideoPlayingState?, vm: PostsFeedContentViewModelProtocol?) {
    guard let playingState = playingState else {
      videoDurationTimer = nil
      muteSoundImageView.alpha = 0.0
      soundInfoMessageContainerView.alpha = 0.0
      return
    }
    
    switch playingState {
    case .paused(let currentTime, let duration, _):
      durationLabel.isHidden = true
      videoIcon.isHidden = false
      videoDurationTimer = nil
      currentDurationTimeinterval = (duration - currentTime)
    case .playing(let currentTime, let duration, let soundStatus):
      durationLabel.isHidden = false
      videoIcon.isHidden = true
      AppLogger.debug("playing")
      currentDurationTimeinterval = (duration - currentTime)
      
      muteSoundImageView.alpha = 0.0
      soundInfoMessageContainerView.alpha = 0.0
      
      let hideDurationDelay = min(currentDurationTimeinterval, 3.0)
      
      videoDurationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (_) in
        self?.currentDurationTimeinterval -= 1.0
//        DispatchQueue.main.async {
//          self?.currentDurationTimeinterval -= 1.0
//        }
      })
      
      durationLabel.alpha = 0.0
      UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: { [weak self] in
        self?.durationLabel.alpha = 1.0
      }) {[weak self] (_) in
        UIView.animate(withDuration: 0.3, delay: hideDurationDelay, options: .curveLinear, animations: { [weak self] in
          self?.durationLabel.alpha = 0.0
        }) { (_) in }
      }
      
      switch soundStatus {
      case .hasSound(let isMuted):
        muteSoundImageView.image = isMuted ?
          UIImage(imageLiteralResourceName: "PostsFeed-MuteSound") :
          UIImage(imageLiteralResourceName: "PostsFeed-MuteSound-active")
          
        soundInfoLabel.text = ""
        vm?.shouldPresentHelpForCurrentUserRequestClojure() { [weak self] shouldPresentHelpForCurrentUser in
          guard shouldPresentHelpForCurrentUser else {
            self?.isSoundInfoContainerViewAnimating = true
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: { [weak self] in
              self?.muteSoundImageView.alpha = 1.0
            }) { [weak self] (_) in
              UIView.animate(withDuration: 0.3, delay: 3.0, options: .curveLinear, animations: { [weak self] in
                self?.muteSoundImageView.alpha = 0.0
              }) { [weak self] (_) in
                self?.isSoundInfoContainerViewAnimating = false
              }
            }
            return
          }
          
          self?.soundInfoLabel.text = vm?.soundHelpInfo ?? ""
          self?.isSoundInfoContainerViewAnimating = true
          
          UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: { [weak self] in
            self?.muteSoundImageView.alpha = 1.0
            self?.soundInfoMessageContainerView.alpha = 1.0
          }) {[weak self] (_) in
            UIView.animate(withDuration: 0.3, delay: 3.0, options: .curveLinear, animations: { [weak self] in
              self?.muteSoundImageView.alpha = 0.0
              self?.soundInfoMessageContainerView.alpha = 0.0
            }) { [weak self] (_) in
              self?.isSoundInfoContainerViewAnimating = false
            }
          }
        }
      case .noSound:
        muteSoundImageView.image = UIImage(imageLiteralResourceName: "PostsFeed-NoSound")
        soundInfoLabel.text = vm?.noSoundInfo ?? ""
        
        isSoundInfoContainerViewAnimating = true
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: { [weak self] in
          self?.muteSoundImageView.alpha = 1.0
          self?.soundInfoMessageContainerView.alpha = 1.0
        }) {[weak self] (_) in
          UIView.animate(withDuration: 0.3, delay: 3.0, options: .curveLinear, animations: { [weak self] in
            self?.muteSoundImageView.alpha = 0.0
            self?.soundInfoMessageContainerView.alpha = 0.0
          }) { [weak self] (_) in
            self?.isSoundInfoContainerViewAnimating = false
          }
        }
      }
    }
  }
  
  fileprivate func setVideoIconPresentationFor(_ indexPath: IndexPath) {
    guard let vm = viewModel else {
      videoStatusContainerView.alpha = 0.0
      muteSoundImageView.isHidden = true
      soundInfoMessageContainerView.isHidden = true
      return
    }
    
    guard indexPath.item < vm.numberOfItemsInSection(indexPath.section) else {
      videoStatusContainerView.alpha = 0.0
      muteSoundImageView.isHidden = true
      soundInfoMessageContainerView.isHidden = true
      return
    }
    
    guard case .video = vm.itemViewModelAt(indexPath) else {
      videoStatusContainerView.alpha = 0.0
      muteSoundImageView.isHidden = true
      soundInfoMessageContainerView.isHidden = true
      return
    }
    
    videoStatusContainerView.alpha = 1.0
    
    videoIcon.isHidden = true
    durationLabel.isHidden = true
    
    muteSoundImageView.isHidden = false
    soundInfoMessageContainerView.isHidden = false
    
  }
  
  fileprivate func getCentralCell() -> UICollectionViewCell? {
    let center = convert(contentCollectionView.center, to: contentCollectionView)
    guard let centerCellIndexPath = contentCollectionView.indexPathForItem(at: center) else {
      return nil
    }
    
    return contentCollectionView.cellForItem(at: centerCellIndexPath)
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let center = convert(contentCollectionView.center, to: contentCollectionView)
    guard let centerCellIndexPath = contentCollectionView.indexPathForItem(at: center) else {
      return
    }
    
    setPageForIndexPath(centerCellIndexPath)
    
    UIView.animate(withDuration: 0.1) { [weak self] in
      self?.setVideoIconPresentationFor(centerCellIndexPath)
      self?.setVerificationErrorIconFor(centerCellIndexPath)
    }
    
    if let cell = contentCollectionView.cellForItem(at: centerCellIndexPath),
      let videoCell = cell as? PostsFeedVideoContentCollectionViewCell {
       
      let playingState = videoCell.play() { [weak self] in
        guard let strongSelf = self else {
          return
        }
        strongSelf.setVideoIconAndDurationFor($0, vm: strongSelf.viewModel)
      }
      
    }
  }
  
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel?.numberOfSections() ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel?.numberOfItemsInSection(section) ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
    guard indexPath.section == 0 && indexPath.item == 0 &&
      collectionView.numberOfItems(inSection: 0) == 1 else {
        return
    }
    
//    if let videoCell = cell as? PostsFeedVideoContentCollectionViewCell {
//      videoCell.play()
//    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if let videoCell = cell as? PostsFeedVideoContentCollectionViewCell {
      let _ = videoCell.pause() { _ in }
      setVideoIconAndDurationFor(nil, vm: viewModel)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let vm = viewModel else {
      return UICollectionViewCell()
    }
    
    let itemViewModelType = vm.itemViewModelAt(indexPath)
    switch itemViewModelType {
    case .image(let itemVM):
      let cell = collectionView.dequeueReusableCell(cell: PostsFeedImageContentCollectionViewCell.self, for: indexPath)
      cell.setViewModel(itemVM, layout: itemLayout)
      return cell
      
    case .video(let itemVM):
      let cell = collectionView.dequeueReusableCell(cell: PostsFeedVideoContentCollectionViewCell.self, for: indexPath)
      cell.setViewModel(itemVM, layout: itemLayout)
      cell.play() { [weak self] in
        self?.setVideoIconAndDurationFor($0, vm: vm)
      }
      
      return cell
    }
  }
}


//MARK:- UITapGestureRecognizer

extension PostsFeedContentContainerTableViewCell {
  @objc func doubleTapHandler(_ sender: UITapGestureRecognizer) {
    let sinceLastAction = lastDoubleTapAnimationDate?.timeIntervalSinceNow ?? doubleTapAnimationFullDuration
    
    guard !abs(sinceLastAction).isLess(than: doubleTapAnimationFullDuration) else {
      return
    }
    
    lastDoubleTapAnimationDate = Date()
    upvoteIconLargeImageView.bubbleAnimateWithAppearance(duration: doubleTapAnimationDuration,
                                                         scale: 2.3,
                                                         hideDuration: doubleTapHideAnimationDuration,
                                                         hideDelay: doubleTapHideAnimationDelay)
   
    actionHandler?(self, .upvoteInPlace)
  }
  
  @objc func tapHandler(_ sender: UITapGestureRecognizer) {
    guard let cell = getCentralCell(),
      let videoCell = cell as? PostsFeedVideoContentCollectionViewCell
    else {
      return
    }
    
    let soundStatus = videoCell.muteAction()
    switch soundStatus {
    case .hasSound(let isMuted):
      muteSoundImageView.image = isMuted ?
        UIImage(imageLiteralResourceName: "PostsFeed-MuteSound") :
        UIImage(imageLiteralResourceName: "PostsFeed-MuteSound-active")
    case .noSound:
      muteSoundImageView.image = UIImage(imageLiteralResourceName: "PostsFeed-NoSound")
    }
    
    guard !isSoundInfoContainerViewAnimating else {
      return
    }
    
    
    muteSoundImageView.alpha = 1.0
    UIView.animate(withDuration: 1.0) { [weak self] in
      self?.muteSoundImageView.alpha = 0.0
    }
  }
}

extension PostsFeedContentContainerTableViewCell {
//  override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//    return true
//  }
}
