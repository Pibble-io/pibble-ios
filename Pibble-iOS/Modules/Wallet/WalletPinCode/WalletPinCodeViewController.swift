//
//  WalletPinCodeViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: WalletPinCodeView Class
final class WalletPinCodeViewController: ViewController {
  
  //MARK:- IBOutlets
  @IBOutlet var pinCodeViews: [UIView]!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var purposeTitleLabel: UILabel!
  
  @IBOutlet weak var loadingActivityView: UIView!
  @IBOutlet weak var pickedDigitsContainerView: UIView!
  @IBOutlet weak var resetPinCodeButton: UIButton!
  
  @IBAction func resetPinCodeAction(_ sender: Any) {
    presenter.handleResetPinCodeAction()
  }
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupLayout()
    setupAppearance()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    view.superview?.endEditing(true)
  }
}

//MARK: - WalletPinCodeView API
extension WalletPinCodeViewController: WalletPinCodeViewControllerApi {
  func setRestorePincodeButtonHidden(_ hidden: Bool) {
    resetPinCodeButton.isHidden = hidden
  }
  
  func showLoaderViewHidden(_ hidden: Bool) {
    loadingActivityView.isHidden = hidden
  }
  
  func showFailAnimaion() {
    pickedDigitsContainerView.shake(count: 3, offset: 5)
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred()
  }
  
  func setPurposeTitle(_ title: String) {
    purposeTitleLabel.text = title
  }
  
  func setPickedDigits(_ digits: [Bool]) {
    for (idx, view) in pinCodeViews.enumerated() {
      var selected = false
      if idx < digits.count {
        selected = digits[idx]
      }
      
      view.backgroundColor = selected ? UIConstants.Colors.Digit.selected: UIConstants.Colors.Digit.notSelected
    }
  }
  
}

// MARK: - WalletPinCodeView Viper Components API
fileprivate extension WalletPinCodeViewController {
  var presenter: WalletPinCodePresenterApi {
    return _presenter as! WalletPinCodePresenterApi
  }
}


//MARK: - WalletPinCodeView API
extension WalletPinCodeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let viewModelType = presenter.itemViewModelFor(indexPath)
    switch viewModelType {
    case .digit(_):
      return CGSize(width: floor(collectionView.bounds.width / 3.0), height: floor(collectionView.bounds.height / 4.0))
    case .digitWithControls(_):
       return CGSize(width: collectionView.bounds.width, height: floor(collectionView.bounds.height / 4.0))
    }
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return presenter.numberOfSections()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let viewModelType = presenter.itemViewModelFor(indexPath)
    switch viewModelType {
    case .digit(let vm):
      let cell = collectionView.dequeueReusableCell(cell: WalletPinCodeDigitCollectionViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: handleActionForCell)
       return cell
    case .digitWithControls(let vm):
      let cell = collectionView.dequeueReusableCell(cell: WalletPinCodeDigitControlCollectionViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: handleActionForCell)
      return cell
    }
  }
}


//MARK:- Helpers

extension WalletPinCodeViewController {
  fileprivate func setupView() {
    collectionView.delegate = self
    collectionView.dataSource = self
  }
  
  fileprivate func setupAppearance() {
    pinCodeViews.forEach {
      $0.setCornersToCircle()
      $0.layer.borderWidth = UIConstants.BorderWidth.digitPicked
      $0.layer.borderColor = UIConstants.Colors.digitPickedBorderColor.cgColor
    }
  }
  
  fileprivate func setupLayout() {
    guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
      return
    }
    
    layout.sectionInset = UIEdgeInsets.zero
    layout.minimumLineSpacing = 0.0
    layout.minimumInteritemSpacing = 0.0
  }
  
  func handleActionForCell(_ cell: WalletPinCodeDigitCollectionViewCell) {
    guard let indexPath = collectionView.indexPath(for: cell) else {
      return
    }
    
    presenter.handlePickItemAt(indexPath)
  }
  
  func handleActionForCell(_ cell: WalletPinCodeDigitControlCollectionViewCell, actionType: WalletPinCode.ControlActions) {
   switch actionType {
    case .left:
      presenter.handleLeftControlAction()
    case .digitSelect:
      guard let indexPath = collectionView.indexPath(for: cell) else {
        return
      }
      
      presenter.handlePickItemAt(indexPath)
    case .right:
      presenter.handleRightControlAction()
    }
  }
}

fileprivate enum UIConstants {
  enum BorderWidth {
    static let digitPicked: CGFloat = 1.5
  }
  
  enum Colors {
    static let digitPickedBorderColor = UIColor.white
    
    enum Digit {
      static let selected = UIColor.white
      static let notSelected = UIColor.clear
    }
  }
}
