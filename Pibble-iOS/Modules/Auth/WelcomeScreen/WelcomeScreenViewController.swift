//
//  WelcomeModuleView.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: WelcomeModuleView Class
final class WelcomeScreenViewController: ViewController {
  @IBOutlet weak var continueButton: UIButton!
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBAction func switchAccountAction(_ sender: Any) {
    presenter.handleSwitchAccountAction()
  }
  //MARK:- Lyfecycle
  @IBAction func continueAction(_ sender: Any) {
    presenter.handleContinueAction()
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

//MARK: - WelcomeModuleView API
extension WelcomeScreenViewController: WelcomeScreenViewControllerApi {
}

// MARK: - WelcomeModuleView Viper Components API
fileprivate extension WelcomeScreenViewController {
    var presenter: WelcomeScreenPresenterApi {
        return _presenter as! WelcomeScreenPresenterApi
    }
}


fileprivate extension WelcomeScreenViewController {
  func setupView() {
    continueButton.clipsToBounds = true
    continueButton.layer.cornerRadius = continueButton.frame.size.height * 0.5
    
    backgroundImageView.image = AssetsManager.Background.welcome.asset
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let background = UIColor.pinkBackgroundGradient
    static let button = UIColor.purpleButtonGradient
  }
}
