//
//  ExternalLinkViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit
import WebKit

//MARK: ExternalLinkView Class
final class ExternalLinkViewController: ViewController {
  
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
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    webView.frame = webViewContainer.bounds
  }
}

extension ExternalLinkViewController: WKUIDelegate {
  
}

//MARK: - ExternalLinkView API
extension ExternalLinkViewController: ExternalLinkViewControllerApi {
  func setNavigationBarTitle(_ title: String) {
    navigationBarTitleLabel.text = title
  }
  
  func setWebViewUrl(_ url: URL) {
    let request = URLRequest(url: url)
    webView.load(request)
  }
  
}

// MARK: - ExternalLinkView Viper Components API
fileprivate extension ExternalLinkViewController {
  var presenter: ExternalLinkPresenterApi {
    return _presenter as! ExternalLinkPresenterApi
  }
}
