//
//  OnboardingViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 04/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: OnboardingView Class
final class OnboardingViewController: ViewController {
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet var pageIndicatorViews: [DesignableCorneredView]!
  @IBOutlet weak var finishOnboardingButton: UIButton!
  @IBOutlet weak var stackView: UIStackView!
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  
  fileprivate lazy var titles: [String] = {
    return [Onboarding.Strings.One.title.localize(),
     Onboarding.Strings.Two.title.localize(),
     Onboarding.Strings.Three.title.localize(),
     Onboarding.Strings.Four.title.localize()]
  }()
  
  fileprivate lazy var subtitles: [String] = {
    return [Onboarding.Strings.One.subtitle.localize(),
            Onboarding.Strings.Two.subtitle.localize(),
            Onboarding.Strings.Three.subtitle.localize(),
            Onboarding.Strings.Four.subtitle.localize()]
  }()
  
  @IBAction func finishOnboardingAction(_ sender: Any) {
    presenter.handeFinishOnboardingAction()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAppearance()
    setSelectedPage(0)
    setTitlesForPage(0, animated: false)
    setButtonStateForPage(0, animated: false)
  }
}

//MARK: - OnboardingView API
extension OnboardingViewController: OnboardingViewControllerApi {
}

// MARK: - OnboardingView Viper Components API
fileprivate extension OnboardingViewController {
  var presenter: OnboardingPresenterApi {
    return _presenter as! OnboardingPresenterApi
  }
}

extension OnboardingViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    setSelectedPage(page)
    setTitlesForPage(page, animated: false)
    setButtonStateForPage(page, animated: true)
  }
}

extension OnboardingViewController {
  fileprivate func setButtonStateForPage(_ page: Int, animated: Bool) {
    let lastPage = pageIndicatorViews.count - 1
    let alpha: CGFloat = page == lastPage ? 1.0 : 0.0
    let hidden = !(page == lastPage)
    
    guard animated else {
      finishOnboardingButton.alpha = alpha
      finishOnboardingButton.isHidden = hidden
      return
    }
    
    if !hidden {
      finishOnboardingButton.isHidden = false
    }
    
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.finishOnboardingButton.alpha = alpha
    }) { [weak self] (_) in
      self?.finishOnboardingButton.isHidden = hidden
    }
  }
  
  
  fileprivate func setTitlesForPage(_ page: Int, animated: Bool) {
    guard animated else {
      titleLabel.text = titles[page]
      subtitleLabel.text = subtitles[page]
      return
    }

    titleLabel.fadeTransition(0.3)
    subtitleLabel.fadeTransition(0.3)

    titleLabel.text = titles[page]
    subtitleLabel.text = subtitles[page]
  }
  
  fileprivate func setSelectedPage(_ page: Int) {
    pageIndicatorViews
      .enumerated()
      .forEach {
        $0.element.backgroundColor = $0.offset == page ?
          UIConstants.Colors.pageSelected :
          UIConstants.Colors.pageDeselected
    }
  }
  
  fileprivate func setupView() {
    scrollView.delegate = self
  }
  
  fileprivate func setupAppearance() {
    finishOnboardingButton.setCornersToCircleByHeight()
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let pageSelected = UIColor.bluePibble
    static let pageDeselected = UIColor.clear
  }
  
}

extension Onboarding {
  enum Strings {
    enum One: String, LocalizedStringKeyProtocol {
      case title = "Share"
      case subtitle = "Easy and Fast. Share your life"
    }
    
    enum Two: String, LocalizedStringKeyProtocol {
      case title = "Get Paid"
      case subtitle = "All social actions earn you"
    }
    
    enum Three: String, LocalizedStringKeyProtocol {
      case title = "Play Social"
      case subtitle = "More than social. It is fun!"
    }
    
    enum Four: String, LocalizedStringKeyProtocol {
      case title = "Blockchain Social"
      case subtitle = "The next social with blockchain"
    }
  }
}
