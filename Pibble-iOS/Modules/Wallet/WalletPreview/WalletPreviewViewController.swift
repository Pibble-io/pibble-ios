//
//  WalletPreviewViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 15.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: WalletPreviewView Class
final class WalletPreviewViewController: ViewController {
  @IBOutlet weak var walletButton: UIButton!
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBAction func walletAction(_ sender: Any) {
    presenter.handleWalletAction()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupLayout()
    setupAppearance()
  }
}

//MARK: - WalletPreviewView API
extension WalletPreviewViewController: WalletPreviewViewControllerApi {
  func reloadData() {
//    collectionView.alpha = 0.0
    collectionView.reloadData()
//    UIView.animate(withDuration: 0.3) { [weak self] in
//      self?.collectionView.alpha = 1.0
//    }
  }
}

// MARK: - WalletPreviewView Viper Components API
fileprivate extension WalletPreviewViewController {
  var presenter: WalletPreviewPresenterApi {
    return _presenter as! WalletPreviewPresenterApi
  }
}

extension WalletPreviewViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let itemWidth = collectionView.bounds.width / UIConstants.itemsPerLineCount
    let itemHeigth = collectionView.bounds.height / UIConstants.linesCount
    return CGSize(width: itemWidth, height: itemHeigth)
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return presenter.numberOfSections()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let itemViewModel = presenter.itemViewModelAt(indexPath)
    let cell = collectionView.dequeueReusableCell(cell: WalletPreviewItemCollectionViewCell.self, for: indexPath)
    
    cell.setViewModel(itemViewModel)
    return cell
  }
}


//MARK:- Helpers

extension WalletPreviewViewController {
  fileprivate func setupView() {
    collectionView.delegate = self
    collectionView.dataSource = self
  }
  
  fileprivate func setupAppearance() {
    walletButton.layer.cornerRadius = walletButton.bounds.height * 0.5
    walletButton.clipsToBounds = true
  }
  
  fileprivate func setupLayout() {
    guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
      return
    }
    
    layout.sectionInset = UIEdgeInsets.zero
    layout.minimumLineSpacing = 0.0
    layout.minimumInteritemSpacing = 0.0
    
  }
}

fileprivate enum UIConstants {
  static let itemsPerLineCount: CGFloat = 3
  static let linesCount: CGFloat = 2
}
