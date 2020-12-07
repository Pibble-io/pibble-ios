//
//  RestorePasswordMethodModuleView.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: RestorePasswordMethodModuleView Class
final class RestorePasswordMethodViewController: ViewController {
  
  @IBOutlet weak var navigationBarTitleLabel: UILabel!
  
  @IBOutlet weak var informationTitleLabel: UILabel!
  
  @IBOutlet weak var dimView: UIView!
  
  @IBOutlet weak var smsMethodButton: UIButton!
  @IBOutlet weak var emailMethodButton: UIButton!
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBAction func smsRestoreMethodAction(_ sender: Any) {
    presenter.handleSMSRestoreMethodAction()
  }
  
  @IBAction func emailRestoreMethodAction(_ sender: Any) {
    presenter.handleEmailRestoreMethodAction()
  }
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  //MARK:- Properties
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }
  
}

//MARK: - RestorePasswordMethodModuleView API
extension RestorePasswordMethodViewController: RestorePasswordMethodViewControllerApi {
  func setNavigationBarTitle(_ text: String) {
    navigationBarTitleLabel.text = text
  }
  
  func setInformationTitle(_ text: String) {
    informationTitleLabel.text = text
  }
  
  func setDimViewHidden(_ hidden: Bool) {
    dimView.isHidden = hidden
  }
}

// MARK: - RestorePasswordMethodModuleView Viper Components API
fileprivate extension RestorePasswordMethodViewController {
  var presenter: RestorePasswordMethodPresenterApi {
    return _presenter as! RestorePasswordMethodPresenterApi
  }
}


fileprivate extension RestorePasswordMethodViewController {
  func setupView() {
    smsMethodButton.clipsToBounds = true
    smsMethodButton.layer.cornerRadius = smsMethodButton.frame.size.height * 0.5
    emailMethodButton.clipsToBounds = true
    emailMethodButton.layer.cornerRadius = emailMethodButton.frame.size.height * 0.5
   
    backgroundImageView.image = AssetsManager.Background.auth.asset
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let button = UIColor.purpleButtonGradient
    static let background = UIColor.pinkBackgroundGradient
  }
}
