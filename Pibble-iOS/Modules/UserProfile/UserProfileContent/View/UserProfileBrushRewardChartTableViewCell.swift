//
//  UserProfileBrushRewardChartTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 15.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import SwiftChart


typealias UserProfileBrushRewardChartActionHandler = (UserProfileBrushRewardChartTableViewCell) -> Void

class UserProfileBrushRewardChartTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var chartContainerView: UIView!
  @IBOutlet weak var chartView: Chart!
  
  @IBOutlet weak var pgbColorView: UIView!
  @IBOutlet weak var prbColorView: UIView!
  @IBOutlet weak var periodButton: UIButton!
  
  @IBAction func periodSwitchAction(_ sender: Any) {
    handler?(self)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  fileprivate var handler: UserProfileBrushRewardChartActionHandler?
  
  func setViewModel(_ vm: UserProfileRewardsChartViewModelProtocol, handler: @escaping UserProfileBrushRewardChartActionHandler) {
    self.handler = handler
    
    pgbColorView.setCornersToCircle()
    prbColorView.setCornersToCircle()
    
    periodButton.setTitleForAllStates(vm.periodTitle)
    
    chartView.removeAllSeries()
    
    vm.points.forEach { seriesArr in
      let data = seriesArr.1.enumerated().map { return (x: Double($0.offset), y: Double($0.element.0)) }
      
      let series = ChartSeries(data: data)
      series.color = seriesArr.0
      chartView.add(series)
    }
    
    chartView.xLabels = vm.labelsIndexes
    chartView.xLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
      return vm.labels[labelIndex]
    }
    
    chartView.labelColor = UIConstants.Colors.labelColor
    chartView.gridColor = UIConstants.Colors.gridColor
    chartView.axesColor = UIConstants.Colors.axesColor
    
    chartView.labelFont = UIFont.AvenirNextMedium(size: 10)
    chartView.highlightLineColor = UIConstants.Colors.highlightLineColor
    chartView.bottomInset = 40.0
    chartView.topInset = 40.0
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let labelColor = UIColor.grayBlue2
    static let gridColor = UIColor.grayBlue2
    static let axesColor = UIColor.grayBlue2
    
    static let highlightLineColor = UIColor.clear
  }
}
