//
//  UIViewNibExtentions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 23.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// Usage: Subclass your UIView from NibLoadView to automatically load a xib with the same name as your class

@IBDesignable
class NibLoadingView: UIView {
  @IBOutlet weak var view: UIView!
  
  func setupView() {
    
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    nibSetup()
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    nibSetup()
    setupView()
  }
  
  private func nibSetup() {
    backgroundColor = .clear
    
    view = loadViewFromNib()
    view.frame = bounds
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.translatesAutoresizingMaskIntoConstraints = true
    
    addSubview(view)
  }
  
  private func loadViewFromNib() -> UIView {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
    let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
    return nibView
  }
  
}


