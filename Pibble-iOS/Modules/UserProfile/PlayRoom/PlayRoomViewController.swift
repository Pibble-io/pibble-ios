//
//  PlayRoomViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit
import WebKit

//MARK: PlayRoomView Class
final class PlayRoomViewController: ViewController {
  
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
  
  @IBAction func backAction(_ sender: Any) {
    guard webView.canGoBack else {
      presenter.handleHideAction()
      return
    }
    
    webView.goBack()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    webView.frame = webViewContainer.bounds
  }
}

extension PlayRoomViewController: WKUIDelegate {
  
}

//MARK: - PlayRoomView API
extension PlayRoomViewController: PlayRoomViewControllerApi {
  func setNavigationBarTitle(_ title: String) {
    navigationBarTitleLabel.text = title
  }
  
  func setWebViewUrl(_ url: URL) {
    let request = URLRequest(url: url)
    webView.load(request)
  }
}

// MARK: - PlayRoomView Viper Components API
fileprivate extension PlayRoomViewController {
  var presenter: PlayRoomPresenterApi {
    return _presenter as! PlayRoomPresenterApi
  }
}
