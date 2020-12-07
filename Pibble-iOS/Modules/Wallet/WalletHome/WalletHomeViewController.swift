//
//  WalletHomeViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 23.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: WalletHomeView Class
final class WalletHomeViewController: ViewController {
  @IBOutlet weak var profileHeaderView: WalletProfileHeaderView!
  
  @IBOutlet weak var profileHeaderViewHeight: NSLayoutConstraint!
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handeHideAction()
  }
  
 
  //MARK:- Properties
  
  fileprivate var headersForIndexPath: [IndexPath: WalletHomeDashboardCollectionReusableView] = [:]
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAppearance()
  }
}

//MARK:- Helpers

extension WalletHomeViewController {
  fileprivate func setupAppearance() {
    guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
      return
    }
    
    layout.sectionHeadersPinToVisibleBounds = false
    layout.sectionInset.top = UIConstants.CollectionView.sectionSpacing
    layout.minimumLineSpacing = UIConstants.CollectionView.columnsInnerSpacing
    layout.minimumInteritemSpacing = UIConstants.CollectionView.columnsInnerSpacing
    layout.sectionInset.left = UIConstants.CollectionView.columnsLeftInset
    layout.sectionInset.right = UIConstants.CollectionView.columnsLeftInset
    
    collectionView.contentInset.top = UIConstants.CollectionView.collectionTopInset
  }
  
  fileprivate var itemSize: CGSize {
    let space = (UIConstants.CollectionView.columnsInnerSpacing * CGFloat(UIConstants.CollectionView.numberOfColumns - 1)) +  UIConstants.CollectionView.columnsLeftInset + UIConstants.CollectionView.columnsRigthInset
    
    let width = (collectionView.bounds.width - space) / CGFloat(UIConstants.CollectionView.numberOfColumns)
    return CGSize(width: floor(width), height: UIConstants.CollectionView.itemHeight)
  }
  
  fileprivate func setupView() {
    collectionView.dataSource = self
    collectionView.delegate = self
  }
}

//MARK: - WalletHomeView API

extension WalletHomeViewController: WalletHomeViewControllerApi {
  func setProfile(_ vm: WalletProfileHeaderViewModelProtocol?, animated: Bool) {
    profileHeaderView.setViewModel(vm)
    
    profileHeaderViewHeight.constant = vm == nil ? UIConstants.Constraints.headerViewMinHeight :
      UIConstants.Constraints.headerViewMaxHeight
    
    guard vm != nil else {
      return
    }
    
    guard animated else {
      return
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.view.layoutIfNeeded()
    }
  }
    
  func reloadData() {
    let sections: [Int] = Array(0..<collectionView.numberOfSections)
    collectionView.reloadSections(IndexSet(sections))
  }
}

// MARK: - WalletHomeView Viper Components API

fileprivate extension WalletHomeViewController {
  var presenter: WalletHomePresenterApi {
    return _presenter as! WalletHomePresenterApi
  }
}

//MARK:- UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension WalletHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return itemSize
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    presenter.handleSelectionAt(indexPath)
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return presenter.numberOfSections()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let vm = presenter.itemAt(indexPath)
    let cell =  collectionView.dequeueReusableCell(cell: WalletHomeActionCollectionViewCell.self, for: indexPath)
    
    cell.setViewModel(vm)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    guard let _ = presenter.itemHeaderAt(section) else {
      return CGSize.zero
    }
    
    return CGSize(width: collectionView.bounds.width, height: UIConstants.CollectionView.headerHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    guard case UICollectionView.elementKindSectionHeader = kind else {
      return UICollectionReusableView()
    }
    
    guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WalletHomeDashboardCollectionReusableView.reuseIdentifier, for: indexPath) as? WalletHomeDashboardCollectionReusableView else {
      
      return UICollectionReusableView()
    }
    
    if let headerVM = presenter.itemHeaderAt(indexPath.section) {
      headerView.setViewModel(headerVM)
    }
    headersForIndexPath[indexPath] = headerView
    return headerView
  }
 
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let contentOffset = CGPoint(x: scrollView.contentOffset.x - scrollView.contentInset.left,
                                y: scrollView.contentOffset.y + scrollView.contentInset.top)
    headersForIndexPath.values.forEach {
      $0.updateBackgroundViewOffset(contentOffset)
    }
  }
}

//MARK:- UIConstants

fileprivate enum UIConstants {
  enum Constraints {
    static let headerViewMaxHeight: CGFloat = 64.0
    static let headerViewMinHeight: CGFloat = 1.0
  }
  
  enum CollectionView {
    static let itemHeight: CGFloat = 103.0
    static let columnsInnerSpacing: CGFloat = 13.0
    static let columnsLeftInset: CGFloat = 13.0
    static let columnsRigthInset: CGFloat = 13.0
    static let sectionSpacing: CGFloat = 20.0
    static let collectionTopInset: CGFloat = 10.0
    static let headerHeight: CGFloat = 218.0
    static let numberOfColumns = 2
  }
  
  enum Colors {
    static let walletDashboardGradient = UIColor.blueGradient
  }
  
  static let cornerRadius: CGFloat = 5.0
}
