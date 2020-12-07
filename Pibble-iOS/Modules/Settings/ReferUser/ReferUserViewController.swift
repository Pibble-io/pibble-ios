//
//  ReferUserViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 17/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: ReferUserView Class
final class ReferUserViewController: ViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  
  @IBOutlet weak var scrollViewBottonContraint: NSLayoutConstraint!
  @IBOutlet weak var contentStackView: UIStackView!
  
  @IBOutlet weak var headerView: UIView!
  
  @IBOutlet weak var inviteCodeView: UIView!
  
  @IBOutlet weak var registeredUsersView: UIView!
  
  @IBOutlet weak var registerUserView: UIView!
  
  //MARK:- IBOutlets - HeaderView
  
  @IBOutlet weak var headerTitleLabel: UILabel!
  
  @IBOutlet weak var headerSUbtitleLabel: UILabel!
  
  //MARK:- IBOutlets - InviteView
  @IBOutlet weak var usernameCopiedBackgroundView: UIView!
  
  @IBOutlet weak var usernameBackgroundView: UIView!
  @IBOutlet weak var usernameLabel: UILabel!
  
  @IBOutlet weak var copyUsernameButton: UIButton!
  
  @IBOutlet weak var inviteButton: UIButton!
  
  @IBOutlet weak var copyUsernameBackgroundView: UIView!
  
  @IBOutlet weak var inviteBackgroundView: UIView!
  
  //MARK:- IBOutlets - RegisteredUsersView
  
  @IBOutlet weak var inviteBonusAmountLabel: UILabel!
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  //MARK:- IBOutlets - RegisterUserView
  
  @IBOutlet weak var registerUserTextFieldBackgroundView: UIView!
  
  @IBOutlet weak var registerUserTextField: UITextField!
  
  @IBOutlet weak var registerButton: UIButton!
  
  @IBOutlet weak var registerButtonBackgroundView: UIView!
  
  
  //MARK:- IBActions
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBAction func copyAction(_ sender: Any) {
    presenter.handleCopyAction()
    
    usernameCopiedBackgroundView.alpha = 1.0
    usernameCopiedBackgroundView.isHidden = false
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.usernameCopiedBackgroundView.alpha = 0.0
    }) { [weak self] (_) in
      self?.usernameCopiedBackgroundView.isHidden = true
    }
  }
  
  @IBAction func inviteAction(_ sender: Any) {
    presenter.handleInviteAction()
  }
  
  @IBAction func registerAction(_ sender: Any) {
    presenter.handleRegisterAction()
  }
  
  @IBAction func registerTextFieldEditingChangedAction(_ sender: UITextField) {
    presenter.handleRegisteredUsernameChange(sender.text ?? "")
  }
  
  //MARK:- Properties
  
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []

  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupLayout()
    setupAppearance()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    subscribeKeyboardNotications()
    setRegisteredUsersViewPresentationHidden(!presenter.hasRegisteredUsers)
  }
 
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeKeyboardNotications()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setRegisteredUsersViewPresentationHidden(true)
    setRegisterOwnerUserViewPresentationHidden(true)
  }
}

//MARK: - ReferUserView API
extension ReferUserViewController: ReferUserViewControllerApi {
  func showReferralUserRegistrationSuccessAlertWith(_ message: String) {
    let alertController = UIAlertController(title: nil, message: message, safelyPreferredStyle: .alert)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let okAction = UIAlertAction(title: ReferUser.Strings.okAlertAction.localize(), style: .cancel) {(action) in
      
    }
     
    alertController.addAction(okAction)
    
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
  
  fileprivate func setRegisteredUsersViewPresentationHidden(_ hidden: Bool) {
    guard registeredUsersView.isHidden != hidden else {
      return
    }
    guard hidden else {
      UIView.animate(withDuration: 0.3) { [weak self] in
        self?.registeredUsersView.alpha = 1.0
        self?.registeredUsersView.isHidden = false
  
        self?.contentStackView.layoutIfNeeded()
      }
      return
    }
    
    registeredUsersView.alpha = 0.0
    registeredUsersView.isHidden = true
  }
  
  fileprivate func setRegisterOwnerUserViewPresentationHidden(_ hidden: Bool) {
    guard registerUserView.isHidden != hidden else {
      return
    }
    
    guard hidden else {
      UIView.animate(withDuration: 0.3) {
        self.registerUserView.alpha = 1.0
        self.registerUserView.isHidden = false
        
        self.contentStackView.layoutIfNeeded()
      }
      return
    }
    
    registerUserView.alpha = 0.0
    registerUserView.isHidden = true
  }
  
  func setReferralUserId(_ referralId: String, isEnabled: Bool) {
    registerUserTextField.isUserInteractionEnabled = isEnabled
    registerUserTextField.text = referralId
    registerButton.isEnabled = isEnabled
    
    setRegisterOwnerUserViewPresentationHidden(false)
  }
  
  func setReferralInfoViewModel(_ vm: ReferralInfoViewModelProtocol) {
    headerTitleLabel.text = vm.headerTitle
    headerSUbtitleLabel.text = vm.headerSubtitle
    inviteBonusAmountLabel.text = vm.inviteAmount
    usernameLabel.text = vm.inviteReferralId
  }
  
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
    setRegisteredUsersViewPresentationHidden(!presenter.hasRegisteredUsers)

    let updates = batchUpdates
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
    }) { (_) in
      
    }
    
    batchUpdates = []
  }
  
  
  func reloadData() {
    setRegisteredUsersViewPresentationHidden(!presenter.hasRegisteredUsers)
    collectionView.reloadData()
  }
  
}

// MARK: - ReferUserView Viper Components API
fileprivate extension ReferUserViewController {
  var presenter: ReferUserPresenterApi {
    return _presenter as! ReferUserPresenterApi
  }
}



//Helpers

extension ReferUserViewController {
  func setupAppearance() {
    
    copyUsernameBackgroundView.setCornersToCircleByHeight()
    inviteBackgroundView.setCornersToCircleByHeight()
    registerButtonBackgroundView.setCornersToCircleByHeight()
    
    usernameBackgroundView.layer.borderColor = UIConstants.Colors.inputs.cgColor
    usernameBackgroundView.layer.borderWidth = 1.0
    usernameBackgroundView.layer.cornerRadius = UIConstants.BorderCornerRadius.inviteReferralIdBackground
    
    
    registerUserTextFieldBackgroundView.layer.borderColor = UIConstants.Colors.inputs.cgColor
    registerUserTextFieldBackgroundView.layer.borderWidth = 1.0
    registerUserTextFieldBackgroundView.layer.cornerRadius = UIConstants.BorderCornerRadius.inviteReferralIdBackground
    
    
    registerButtonBackgroundView.layer.borderColor = UIConstants.Colors.inputs.cgColor
    registerButtonBackgroundView.layer.borderWidth = 1.0
    
    copyUsernameBackgroundView.layer.borderColor = UIConstants.Colors.buttonsBorder.cgColor
    copyUsernameBackgroundView.layer.borderWidth = 1.0
    
    inviteBackgroundView.layer.borderColor = UIConstants.Colors.buttonsBorder.cgColor
    inviteBackgroundView.layer.borderWidth = 1.0
    
    registerButtonBackgroundView.layer.borderColor = UIConstants.Colors.buttonsBorder.cgColor
    registerButtonBackgroundView.layer.borderWidth = 1.0
    
  }
  
  func setupView() {
    collectionView.delegate = self
    collectionView.dataSource = self
  }
  
  func setupLayout() {
    guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
      return
    }
    
    layout.itemSize = CGSize(width: 120 , height: 120)
    //layout.estimatedItemSize = CGSize(width: 100.0, height: 30.0)
    layout.sectionInset = UIEdgeInsets.zero
    layout.minimumLineSpacing = 0.0
    layout.minimumInteritemSpacing = 0.0
    
//    collectionView.contentInset.top = 25
  }
}

extension ReferUserViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return presenter.numberOfSections()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = presenter.itemViewModelAt(indexPath)
    let cell = collectionView.dequeueReusableCell(cell: ReferUserCollectionViewCell.self, for: indexPath)
    cell.setViewModel(item)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    presenter.handleWillDisplayItem(indexPath)
  }
  
  func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    presenter.handleDidEndDisplayItem(indexPath)
  }
}

//MARK:- KeyboardNotificationsDelegateProtocol

extension ReferUserViewController: KeyboardNotificationsDelegateProtocol {
  func keyBoardWillShowWithBottomInsets(_ bottomInsets: CGFloat, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    scrollViewBottonContraint.constant = bottomInsets
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
  
  func keyBoardWillHide(animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    scrollViewBottonContraint.constant = 0.0
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
}

fileprivate enum UIConstants {
  enum BorderCornerRadius {
    static let registerUserTextField: CGFloat = 11.0
    static let inviteReferralIdBackground: CGFloat = 11.0
  }
  
  enum Colors {
    static let buttonsBorder = UIColor.gray240
    static let inputs = UIColor.gray191
  }
}

