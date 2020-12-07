//
//  ResetPasswordPhonePickModuleView.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: ResetPasswordPhonePickModuleView Class
final class ResetPasswordPhonePickViewController: ViewController {
  //MARK:- IBOutlets
  @IBOutlet weak var backgroundScrollView: UIScrollView!
  
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var phoneTextField: UITextField!
  
  @IBOutlet weak var countryImageView: UIImageView!
  @IBOutlet weak var countryCodeLabel: UILabel!
  
  @IBOutlet weak var pickCountryCodeButtonLabel: UILabel!
  @IBOutlet weak var countriesTableColorBackground: UIView!
  @IBOutlet weak var countriesTableBackgroundView: UIView!
  @IBOutlet weak var verticalSeparatorView: UIView!
  @IBOutlet weak var countriesTableView: UITableView!
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var codeProgressbarView: UIView!
  //MARK:- NSLayoutConstraint
  @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var phoneProgressBarWidth: NSLayoutConstraint!
  
  @IBOutlet weak var coutntriesBackgroundViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var coutntriesBackgroundViewTopConstraint: NSLayoutConstraint!
  
  
  //MARK:- IBActions
  @IBAction func presentCountriesAction(_ sender: Any) {
    presenter.handleCountriesAction()
  }
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBAction func phoneTextFieldEditingChangeAction(_ sender: UITextField) {
    if phoneTextField == sender {
      presenter.handlePhoneValueChanged(phoneTextField.text ?? "")
      phoneProgressBarWidth.constant = phoneTextField.widthForText()
    }
  }
  
  @IBAction func nextStageAction(_ sender: Any) {
    presenter.handleNextStageAction()
  }
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    setupView()
    setupViewAppearance()
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    subscribeKeyboardNotications()
    super.viewDidAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    unsubscribeKeyboardNotications()
    super.viewWillDisappear(animated)
  }
  
  //MARK:- Properties
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }
}

//MARK: - ResetPasswordPhonePickModuleView API
extension ResetPasswordPhonePickViewController: ResetPasswordPhonePickViewControllerApi {
  func setInteractionEnabled(_ enabled: Bool) {
    nextButton.isEnabled = enabled
  }
  
  func reloadCounriesTable() {
    countriesTableView.reloadData()
  }
  
  func setPickCountryButtonPresentation(_ presentation: PhonePick.PickCountryButtonPresentation) {
    switch presentation {
    case .pickCodeButton:
      pickCountryCodeButtonLabel.isHidden = false
      countryCodeLabel.isHidden = true
      codeProgressbarView.isHidden = true
      verticalSeparatorView.isHidden = true
    case .pickedCode:
      pickCountryCodeButtonLabel.isHidden = true
      countryCodeLabel.isHidden = false
      codeProgressbarView.isHidden = false
      verticalSeparatorView.isHidden = false
      phoneTextField.becomeFirstResponder()
    }
  }
  
  func setCountriesListPresentation(_ hidden: Bool) {
    countriesTableBackgroundView.isHidden = false
    setCountriesLayoutHidden(hidden)
    
    if !hidden {
      view.endEditing(true)
    }
    
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { [weak self] (_) in
      self?.countriesTableBackgroundView.isHidden = hidden
    }
  }
  
  func setSelectedCountry(_ country: SignUpCountryViewModelProtocol)  {
    countryCodeLabel.text = country.countryCode
  }
}

// MARK: - ResetPasswordPhonePickModuleView Viper Components API

fileprivate extension ResetPasswordPhonePickViewController {
    var presenter: ResetPasswordPhonePickPresenterApi {
        return _presenter as! ResetPasswordPhonePickPresenterApi
    }
}

//MARK:- KeyboardNotificationsDelegateProtocol

extension ResetPasswordPhonePickViewController: KeyboardNotificationsDelegateProtocol {
  func keyBoardWillHide(animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    backgroundScrollView.contentInset.bottom = 0.0
    nextButtonBottomConstraint.constant = UIConstants.Constraints.bottomButton
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
   
  func keyBoardWillShowWithBottomInsets(_ bottomInsets: CGFloat, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    setCountriesListPresentation(true)
    backgroundScrollView.contentInset.bottom = bottomInsets
    nextButtonBottomConstraint.constant = UIConstants.Constraints.bottomButtonToKeyboard + bottomInsets
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
}


extension ResetPasswordPhonePickViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsIn(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SignUpCountriesTableViewCell.identifier, for: indexPath) as! SignUpCountriesTableViewCell
    let vm = presenter.itemFor(indexPath)
    cell.setViewModel(vm)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    presenter.handleSelectionAt(indexPath)
  }
}

extension ResetPasswordPhonePickViewController {
  fileprivate func setupView() {
    countriesTableView.delegate = self
    countriesTableView.dataSource = self
    countriesTableView.rowHeight = UITableView.automaticDimension
    countriesTableView.estimatedRowHeight = 64.0
    
    setCountriesLayoutHidden(true)
    nextButtonBottomConstraint.constant = UIConstants.Constraints.bottomButton
    
    backgroundImageView.image = AssetsManager.Background.auth.asset
  }
  
  fileprivate func setCountriesLayoutHidden(_ hidden: Bool) {
    coutntriesBackgroundViewHeightConstraint.priority = hidden ? .defaultHigh : .defaultLow
    coutntriesBackgroundViewTopConstraint.priority = !hidden ? .defaultHigh : .defaultLow
  }
  
  fileprivate func setupViewAppearance() {
    nextButton.clipsToBounds = true
    nextButton.layer.cornerRadius = nextButton.frame.size.height * 0.5
    
    pickCountryCodeButtonLabel.layer.cornerRadius = pickCountryCodeButtonLabel.frame.size.height * 0.5
    pickCountryCodeButtonLabel.layer.masksToBounds = true
    
    //countriesTableColorBackground.layer.cornerRadius = 10.0
    countriesTableColorBackground.layer.masksToBounds = true
    
    countriesTableBackgroundView.addShadow(shadowColor: UIColor.black, offSet: CGSize(width: 0, height: -1.0), opacity: 0.25, radius: 50.0)
  }
}


fileprivate enum UIConstants {
  enum Constraints {
    static let bottomButton: CGFloat = 30.0
    static let bottomButtonToKeyboard: CGFloat = 20.0
  }
  enum Colors {
    static let button = UIColor.purpleButtonGradient
    static let background = UIColor.pinkBackgroundGradient
    static let countriesTable = UIColor.pinkBackgroundGradient
  }
}


  
