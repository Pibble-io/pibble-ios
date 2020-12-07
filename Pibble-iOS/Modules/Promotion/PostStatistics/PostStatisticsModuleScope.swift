//
//  PostStatisticsModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 18/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum PostStatistics {
  fileprivate static let numberToStringsFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
    formatter.numberStyle = NumberFormatter.Style.decimal
    return formatter
  }()
  
  fileprivate static func toStringWithFormatter(_ number: Int) -> String {
    let number = NSNumber(value: number)
    return PostStatistics.numberToStringsFormatter.string(from: number) ?? ""
  }
  
  struct PostStatsBudgetViewModel: PromotionPostStatsBudgetViewModelProtocol {
    let budgetAmount: String
    let progress: Double
    let usedBudgetProgress: String
    let leftBudgetProgress: String
    let totalBudgetAmount: String
    let usedBudgetAmount: String
    let leftBudgetAmount: String
    
    init(promotionStats: PromotionStatisticsProtocol, promotionCurrency: BalanceCurrency) {
      budgetAmount = "\(toStringWithFormatter(promotionStats.promotionBudget)) \(promotionCurrency.symbol)"
      if promotionStats.promotionBudget > 0 {
        progress = Double(promotionStats.promotionBudgetSpent) / Double(promotionStats.promotionBudget)
      } else {
        progress = 0.0
      }
      
      let stringFormat = "%.0f"
      let usedProgress =  "\(String(format: stringFormat, progress * 100.0))%"
      let leftProgress =  "\(String(format: stringFormat, (1.0 - progress) * 100.0))%"
      
      usedBudgetProgress = Strings.Budget.used.localize(value: usedProgress)
      leftBudgetProgress = Strings.Budget.left.localize(value: leftProgress)
      totalBudgetAmount = budgetAmount
      usedBudgetAmount = "\(toStringWithFormatter(promotionStats.promotionBudgetSpent)) \(promotionCurrency.symbol)"
      leftBudgetAmount = "\(toStringWithFormatter(promotionStats.promotionBudgetLeft)) \(promotionCurrency.symbol)"
    }
  }
  
  struct PostStatsChartBarViewModel: PromotionPostStatsChartBarViewModelProtocol {
    static let detailedDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "MMM d"
      return formatter
    }()
    
    static let compactDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "d"
      return formatter
    }()
    
    let barColor: UIColor
    let titleColor: UIColor
    let relativeValue: Double
    let value: String
    let title: String
    
    init(engagement: EngagementType, maxValue: Int) {
      barColor = UIConstants.Colors.engagementBarColor
      titleColor = UIConstants.Colors.engagementTitleColor
      
      let correctedMax = max(maxValue, 1)
      relativeValue = Double(engagement.value) / Double(correctedMax)
      value = "\(engagement.value)"
      title = engagement.title
    }
    
    init(impression: ImpressionsProtocol, maxValue: Int, shouldShowDetailedDate: Bool) {
      barColor = UIConstants.Colors.impressionsBarColor
      titleColor = UIConstants.Colors.impressionsTitleColor
      
      let correctedMax = max(maxValue, 1)
      relativeValue = Double(impression.impressionsCount) / Double(correctedMax)
      value = "\(impression.impressionsCount)"
      
      title = shouldShowDetailedDate ?
        PostStatsChartBarViewModel.detailedDateFormatter.string(from: impression.impressionsDate):
        PostStatsChartBarViewModel.compactDateFormatter.string(from: impression.impressionsDate)
    }
  }
  
  struct PostEngagementChartContainerViewModel: PostStatisticsChartContainerViewModelProtocol {
    let title: String
    let value: String
    let barsViewModels: [PromotionPostStatsChartBarViewModelProtocol]
    
    init(postStats: EngagementStatisticsProtocol) {
      title = Strings.Sections.engage.localize()
      let engagements = postStats.engagements
      let sumValue = engagements
        .map { $0.value }
        .reduce(0, +)
      let maxEngagementValue = engagements
        .map { $0.value }
        .max() ?? 0
      
      value = "\(sumValue)"
      barsViewModels = engagements.map { PostStatsChartBarViewModel(engagement: $0, maxValue: maxEngagementValue) }
    }
  }
  
  struct PostImpressionsChartContainerViewModel: PromotionPostStatsChartContainerViewModelProtocol {
    static let impressionHistoryLimit = 5
    
    let title: String
    let value: String
    let barsViewModels: [PromotionPostStatsChartBarViewModelProtocol]
    
    init(promotionStats: PromotionStatisticsProtocol) {
      title = Strings.Sections.impressions.localize()
      
      
      let impressions = promotionStats.impressionsHistory.count <= PostImpressionsChartContainerViewModel.impressionHistoryLimit ?
        promotionStats.impressionsHistory :
        Array(promotionStats.impressionsHistory.suffix(PostImpressionsChartContainerViewModel.impressionHistoryLimit))
      
      let sumValue = impressions
        .map { $0.impressionsCount }
        .reduce(0, +)
      
      let maxValue = impressions
        .map { $0.impressionsCount }
        .max() ?? 0
      
      value = "\(sumValue)"
      barsViewModels = impressions.enumerated()
        .map { PostStatsChartBarViewModel(impression: $0.element,
                                          maxValue: maxValue,
                                          shouldShowDetailedDate: $0.offset == 0) }
    }
  }
  
  struct PostStatsHeaderViewModel: PromotionPostStatsHeaderViewModelProtocol {
    static let dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "MMM d"
      return formatter
    }()
    
    let date: String
    
    init(promotionStats: PromotionStatisticsProtocol) {
      guard let startDate = promotionStats.statisticsStartDate.toDateWithCommonFormat(),
        let endDate = promotionStats.statisticsEndDate.toDateWithCommonFormat()
        else {
          date = ""
          return
      }
      
      let startDateString = PostStatsHeaderViewModel.dateFormatter.string(from: startDate)
      let endDateString = PostStatsHeaderViewModel.dateFormatter.string(from: endDate)
      
      date = "\(startDateString) - \(endDateString)"
    }
    
  }
  
  struct AmountsViewModel: PostStatisticsAmountsViewModelProtocol {
    let totalImpressionsAmount: String
    
    let profileViewsAmount: String
    
    init(postStats: EngagementStatisticsProtocol) {
      totalImpressionsAmount = "\(postStats.postImpressionsCount)"
      profileViewsAmount = "\(postStats.postUserProfileEngagement)"
    }
  }
}

extension PostStatistics {
  enum Strings {
    enum Budget: String, LocalizedStringKeyProtocol {
      case used = "Used %"
      case left = "Left %"
    }
    
    enum Sections: String, LocalizedStringKeyProtocol {
      case engage = "Engage"
      case impressions = "Impression"
    }
  }
}


fileprivate enum UIConstants {
  enum Colors {
    static let engagementBarColor = UIColor.yellowEngagementBar
    static let engagementTitleColor = UIColor.black
    
    static let impressionsBarColor = UIColor.greenImpressionBar
    static let impressionsTitleColor = UIColor.gray168
  }
}
