//
//  TestThreeViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: TestThreeView Class
final class TestThreeViewController: ViewController {
  @IBOutlet weak var backgroundImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    backgroundImageView.image = AssetsManager.Background.auth.asset
  }
}

//MARK: - TestThreeView API
extension TestThreeViewController: TestThreeViewControllerApi {
}

// MARK: - TestThreeView Viper Components API
fileprivate extension TestThreeViewController {
    var presenter: TestThreePresenterApi {
        return _presenter as! TestThreePresenterApi
    }
}
