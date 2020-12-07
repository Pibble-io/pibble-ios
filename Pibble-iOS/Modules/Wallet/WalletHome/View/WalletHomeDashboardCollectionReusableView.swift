//
//  WalletHomeDashboardCollectionReusableView.swift
//  Pibble
//
//  Created by Kazakov Sergey on 23.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class WalletHomeDashboardCollectionReusableView: UICollectionReusableView, DequeueableView {
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var dashboardIconImageView: UIImageView!
  @IBOutlet var backgroundViews: [UIView]!
  
  @IBOutlet var currencyLabels: [UILabel]!
  @IBOutlet var amountLabels: [UILabel]!
  
  @IBOutlet weak var gradientBackground: GradientView!
  
//  override func draw(_ rect: CGRect) {
//    super.draw(rect)
//
//    gradientBackground.layer.sublayers?.forEach {
//      $0.frame = gradientBackground.bounds
//    }
//  }
//  
  override func awakeFromNib() {
    super.awakeFromNib()
    gradientBackground
      .addBackgroundGradientWith(UIConstants.Colors.walletDashboardGradient,
                                 direction: .horizontal)

    containerView.layer.cornerRadius = UIConstants.cornerRadius
    containerView.clipsToBounds = true
    
    backgroundViews.forEach {
      $0.layer.cornerRadius = UIConstants.cornerRadius
      $0.clipsToBounds = true
    }
    
    dashboardIconImageView.setCornersToCircleByHeight()
  }
  
  func updateBackgroundViewOffset(_ contentOffset: CGPoint) {
    let maxOffset: CGFloat = 22.0
    let offsetStep: CGFloat = 60.0
    
    backgroundViews
      .reversed()
      .enumerated()
      .forEach {
        var minOffset = -offsetStep * CGFloat($0.offset + 1)
        minOffset = max(minOffset, -$0.element.bounds.height)

        let correctedOffset = contentOffset.y * 0.5 * CGFloat($0.offset + 1)
        let translationY = max(minOffset, min(maxOffset, correctedOffset))
        
        $0.element.transform = CGAffineTransform(translationX: 0.0, y: translationY)
    }
  }
  
  func setViewModel(_ vm: WalletHomeDashboardViewModelProtocol) {
    zip(zip(currencyLabels, amountLabels), vm.balances).forEach {
      let currencyLabel = $0.0.0
      let amountLabel = $0.0.1
      
      currencyLabel.text = $0.1.currency
      amountLabel.text = $0.1.balance
    }
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let walletDashboardGradient = UIColor.blueGradient
  }
  
  static let cornerRadius: CGFloat = 5.0
  static let buttonsCornerRadius: CGFloat = 5.0
}
