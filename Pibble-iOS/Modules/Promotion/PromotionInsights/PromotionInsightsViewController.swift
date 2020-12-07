//
//  PromotionInsightsViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 12/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: PromotionInsightsView Class
final class PromotionInsightsViewController: ViewController {
  
  @IBOutlet weak var dateHeaderView: UIView!
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var promotionPostStatsBudgetView: PromotionPostStatsBudgetView!
  
  @IBOutlet weak var promotionPostEngagementChartView: PromotionPostStatsChartContainerView!
  
  @IBOutlet weak var promotionPostImpressionChartView: PromotionPostStatsChartContainerView!
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
}

//MARK: - PromotionInsightsView API
extension PromotionInsightsViewController: PromotionInsightsViewControllerApi {
  func setViewModels(_ vms: (header: PromotionPostStatsHeaderViewModelProtocol,
                              budget: PromotionPostStatsBudgetViewModelProtocol,
                              enagements: PromotionPostStatsChartContainerViewModelProtocol,
                              impression: PromotionPostStatsChartContainerViewModelProtocol)?,
                        animated: Bool) {
    
    let alpha: CGFloat = vms == nil ? 0.0 : 1.0
    guard animated else {
      setDateViewModel(vms?.header, animated: false)
      setStatsBudgetViewModel(vms?.budget, animated: false)
      setEngagementViewModel(vms?.enagements, animated: false)
      setImpressionViewModel(vms?.impression, animated: false)
      stackView.alpha = alpha
      return
    }
    
    setDateViewModel(vms?.header, animated: false)
    setStatsBudgetViewModel(vms?.budget, animated: false)
    setEngagementViewModel(vms?.enagements, animated: false)
    setImpressionViewModel(vms?.impression, animated: false)

    UIView.animate(withDuration: 0.3) { [weak self] in
      guard let strongSelf = self else {
        return
      }

      strongSelf.stackView.alpha = alpha
    }
    
  }
  
  func setDateViewModel(_ vm: PromotionPostStatsHeaderViewModelProtocol?, animated: Bool) {
    let hidden = vm == nil
    let alpha: CGFloat = hidden ? 0.0 : 1.0
    
    if let vm = vm {
      dateLabel.text = vm.date
    }
    
    guard animated else {
      dateHeaderView.alpha = alpha
      dateHeaderView.isHidden = hidden
      return
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.dateHeaderView.alpha = alpha
      self?.dateHeaderView.isHidden = hidden
      self?.stackView.layoutIfNeeded()
    }
  }
  
  func setDateTitle(_ dateString: String?, animated: Bool) {
    let hidden = dateString == nil
    let alpha: CGFloat = hidden ? 0.0 : 1.0
    
    if let dateString = dateString {
      dateLabel.text = dateString
    }
    
    guard animated else {
      dateHeaderView.alpha = alpha
      dateHeaderView.isHidden = hidden
      return
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.dateHeaderView.alpha = alpha
      self?.dateHeaderView.isHidden = hidden
      self?.stackView.layoutIfNeeded()
    }
  }
  
  func setStatsBudgetViewModel(_ vm: PromotionPostStatsBudgetViewModelProtocol?, animated: Bool) {
    let hidden = vm == nil
    let alpha: CGFloat = hidden ? 0.0 : 1.0
    
    if let vm = vm {
      promotionPostStatsBudgetView.setViewModel(vm)
    }
    
    guard animated else {
      promotionPostStatsBudgetView.alpha = alpha
      promotionPostStatsBudgetView.isHidden = hidden
      return
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.promotionPostStatsBudgetView.alpha = alpha
      self?.promotionPostStatsBudgetView.isHidden = hidden
      self?.stackView.layoutIfNeeded()
    }
  }
  
  func setEngagementViewModel(_ vm: PromotionPostStatsChartContainerViewModelProtocol?, animated: Bool) {
    let hidden = vm == nil
    let alpha: CGFloat = hidden ? 0.0 : 1.0
    
    if let vm = vm {
      promotionPostEngagementChartView.setViewModel(vm)
    }
    
    guard animated else {
      promotionPostEngagementChartView.alpha = alpha
      promotionPostEngagementChartView.isHidden = hidden
      return
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.promotionPostEngagementChartView.alpha = alpha
      self?.promotionPostEngagementChartView.isHidden = hidden
      self?.stackView.layoutIfNeeded()
    }
  }
  
  func setImpressionViewModel(_ vm: PromotionPostStatsChartContainerViewModelProtocol?, animated: Bool) {
    let hidden = vm == nil
    let alpha: CGFloat = hidden ? 0.0 : 1.0
    
    if let vm = vm {
      promotionPostImpressionChartView.setViewModel(vm)
    }
    
    guard animated else {
      promotionPostImpressionChartView.alpha = alpha
      promotionPostImpressionChartView.isHidden = hidden
      return
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.promotionPostImpressionChartView.alpha = alpha
      self?.promotionPostImpressionChartView.isHidden = hidden
      self?.stackView.layoutIfNeeded()
    }
  }
}

// MARK: - PromotionInsightsView Viper Components API
fileprivate extension PromotionInsightsViewController {
  var presenter: PromotionInsightsPresenterApi {
    return _presenter as! PromotionInsightsPresenterApi
  }
}
