//
//  TopBannerInfoViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit
import WebKit

//MARK: TopBannerInfoView Class
final class TopBannerInfoViewController: ViewController {
  
  @IBOutlet weak var navigationBarTitleLabel: UILabel!
  
  @IBOutlet weak var webViewContainer: UIView!
  var webView: WKWebView!
  
  override func loadView() {
    super.loadView()
    let webConfiguration = WKWebViewConfiguration()
    webView = WKWebView(frame: .zero, configuration: webConfiguration)
    webView.uiDelegate = self
    webViewContainer.addSubview(webView)
    
  }
  
  @IBAction func backAction(_ sender: Any) {
    guard webView.canGoBack else {
      presenter.handleHideAction()
      return
    }
    
    webView.goBack()
  }
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    webView.frame = webViewContainer.bounds
  }
}

extension TopBannerInfoViewController: WKUIDelegate {
  
}

//MARK: - TopBannerInfoView API
extension TopBannerInfoViewController: TopBannerInfoViewControllerApi {
  func setNavigationBarTitle(_ title: String) {
    navigationBarTitleLabel.text = title
  }
  
  func setWebViewUrl(_ url: URL) {
    let request = URLRequest(url: url)
    webView.load(request)
  }
  
}

// MARK: - TopBannerInfoView Viper Components API
fileprivate extension TopBannerInfoViewController {
  var presenter: TopBannerInfoPresenterApi {
    return _presenter as! TopBannerInfoPresenterApi
  }
}
