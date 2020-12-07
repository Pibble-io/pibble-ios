//
//  SearchResultTagDetailContentViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: SearchResultTagDetailContentView Class
final class SearchResultTagDetailContentViewController: ViewController {
  
  //MARK:- IBOutlets
  
  @IBOutlet weak var contentView: UIView!
  
  
  @IBOutlet weak var tagImageView: UIImageView!
  
  @IBOutlet weak var postedCountLabel: UILabel!
  @IBOutlet weak var postedTitleLabel: UILabel!
  
  @IBOutlet weak var followButton: UIButton!
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
  
  //MARK:- IBActions
  
  @IBAction func followTagAction(_ sender: Any) {
    presenter.handleFollowAction()
  }
  
  //MARK:- Private properties
  
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
  
  
  //MARK:- Delegates
  
  weak var embedableDelegate: EmbedableViewControllerDelegate?
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAppearance()
    setupLayout()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    collectionView.shouldFireContentOffsetChangesNotifications = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    collectionView.shouldFireContentOffsetChangesNotifications = false
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    preferredContentSize = contentSize
  }
}

//MARK: - SearchResultTagDetailContentView API
extension SearchResultTagDetailContentViewController: SearchResultTagDetailContentViewControllerApi {
  func updateCollection(_ updates: CollectionViewModelUpdate) {
    if case CollectionViewModelUpdate.reloadData = updates {
      batchUpdates = []
      collectionView.reloadData()
      return
    }
    
    guard case CollectionViewModelUpdate.endUpdates = updates else {
      batchUpdates.append(updates)
      return
    }

    let updates = batchUpdates
    //without animation to avoid cells layout issues due to dynamic cell size
    
    UIView.performWithoutAnimation { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      
      strongSelf.collectionView.performBatchUpdates({
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
      }) { [weak self] (_) in
        guard let strongSelf = self else {
          return
        }
        //strongSelf.preferredContentSize = strongSelf.contentSize
        strongSelf.embedableDelegate?.handleContentSizeChange(strongSelf, contentSize: strongSelf.contentSize)
      }
      
      strongSelf.batchUpdates = []
    }
  }
  
  
  func setTagViewModel(_ vm: SearchResultTagDetailViewModelProtocol?, animated: Bool) {
    guard let viewModel = vm else {
      guard animated else {
        contentView.alpha = 0.0
        return
      }
      UIView.animate(withDuration: 0.3) { [weak self] in
        self?.contentView.alpha = 0.0
      }
      return
    }
    
    
    tagImageView.image = viewModel.imagePlaceholder
    tagImageView.setCachedImageOrDownload(viewModel.imageURLString)
    postedCountLabel.text = viewModel.countString
    postedTitleLabel.text = viewModel.countTitleString
    followButton.setTitleForAllStates(viewModel.followStatus)
    
    let followButtonTitleColor = viewModel.isFollowed ? UIConstants.Colors.highlightedButtonTitle :  UIConstants.Colors.unHighlightedButtonTitle
    let followButtonBorderColor = viewModel.isFollowed ? UIConstants.Colors.highlightedButtonBorder :  UIConstants.Colors.unHighlightedButtonBorder
    
    followButton.setTitleColor(followButtonTitleColor, for: .normal)
    followButton.layer.borderColor = followButtonBorderColor.cgColor
    
    guard animated else {
      contentView.alpha = 1.0
      return
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.contentView.alpha = 1.0
    }
    
    embedableDelegate?.handleContentSizeChange(self, contentSize: contentSize)
  }
}

// MARK: - SearchResultTagDetailContentView Viper Components API

fileprivate extension SearchResultTagDetailContentViewController {
    var presenter: SearchResultTagDetailContentPresenterApi {
        return _presenter as! SearchResultTagDetailContentPresenterApi
    }
}

//MARK:- Helpers

extension SearchResultTagDetailContentViewController {
  fileprivate func setupView() {
    collectionView.registerCell(PostsFeedTagCollectionViewCell.self)
    collectionView.registerViewAsHeader(SearchResultTagDetailRelatedTagSectionHeaderReusableView.self)
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
  }
  
  fileprivate func setupAppearance() {
    tagImageView.setCornersToCircle()
    followButton.layer.borderWidth = 1.0
    followButton.layer.cornerRadius = 7.0
  }
  
  fileprivate func setupLayout() {
    embedableDelegate?.handleContentSizeChange(self, contentSize: contentSize)
    
    guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
      return
    }
    
    layout.itemSize = UICollectionViewFlowLayout.automaticSize
    layout.estimatedItemSize = CGSize(width: 100.0, height: 30.0)
    layout.sectionInset = UIEdgeInsets.zero
    layout.minimumLineSpacing = 10.0
    layout.minimumInteritemSpacing = 5.0
  }
}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource

extension SearchResultTagDetailContentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return presenter.numberOfSections()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let vm = presenter.itemViewModelAt(indexPath)
    let cell = collectionView.dequeueReusableCell(cell: PostsFeedTagCollectionViewCell.self, for: indexPath)
    cell.setViewModel(vm) { _ in  }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    guard collectionView.numberOfItems(inSection: section) > 0 else {
      return CGSize.zero
    }
    
    return CGSize(width: 80, height: collectionView.bounds.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    guard case UICollectionView.elementKindSectionHeader = kind else {
      return UICollectionReusableView()
    }
    
    let footerView = collectionView.dequeueReusableSupplementaryView(SearchResultTagDetailRelatedTagSectionHeaderReusableView.self, kind: .header, for: indexPath)
    
    return footerView
  }
}

extension SearchResultTagDetailContentViewController: EmbedableViewController {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    embedableDelegate?.handleDidScroll(self, childScrollView: scrollView)
  }
  
  func setBouncingEnabled(_ enabled: Bool) {
    collectionView.bounces = enabled
    collectionView.alwaysBounceVertical = enabled
  }
  
  var contentSize: CGSize {
    return contentView.bounds.size
  }
  
  func setScrollingEnabled(_ enabled: Bool) {  }
  
}

fileprivate enum UIConstants {
  enum Colors {
    static let highlightedButtonTitle = UIColor.bluePibble
    static let unHighlightedButtonTitle = UIColor.black
    
    static let highlightedButtonBorder = UIColor.bluePibble
    static let unHighlightedButtonBorder = UIColor.gray213
  }
}
