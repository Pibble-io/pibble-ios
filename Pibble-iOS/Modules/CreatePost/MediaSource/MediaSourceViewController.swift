//
//  MediaSourceViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 09.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: MediaSourceView Class
final class MediaSourceViewController: ViewController {
  
  //MARK:- IBOutlets
  @IBOutlet weak var librarySourceButton: UIButton!
  @IBOutlet weak var photoSourceButton: UIButton!
  @IBOutlet weak var videoSourceButton: UIButton!
  
  @IBOutlet weak var containerView: UIView!
  
  @IBOutlet var sourceButtons: [UIButton]!
  
  @IBOutlet var segmentSelectorViewZeroWidthConstraints: [NSLayoutConstraint]!
  @IBOutlet var segmentSelectorViewFullWidthConstraints: [NSLayoutConstraint]!
  
  fileprivate let segments: [MediaSource.Segments] = [.library, .photo, .video]
  //MARK:- IBActions
  
  @IBAction func sourceSelectionAction(_ sender: UIButton) {
    guard let idx = sourceButtons.index(of: sender) else {
      return
    }
    
    let selectedSegment = segments[idx]
    setSelectedSegment(selectedSegment)
    presenter.handlePresentMediaSourceModeFor(selectedSegment)
  }
  
//  @IBAction func libraryModeAction(_ sender: UIButton) {
//    deselectAllButtons()
//    sender.isSelected = true
//    presenter.handlePresentMediaSourceModeFor(.library)
//  }
//
//  @IBAction func photoModeAction(_ sender: UIButton) {
//    deselectAllButtons()
//    sender.isSelected = true
//    presenter.handlePresentMediaSourceModeFor(.photo)
//  }
//
//  @IBAction func videoModeAction(_ sender: UIButton) {
//    deselectAllButtons()
//    sender.isSelected = true
//    presenter.handlePresentMediaSourceModeFor(.video)
//  }
}

//MARK: - MediaSourceView API
extension MediaSourceViewController: MediaSourceViewControllerApi {
  var submoduleContainerView: UIView {
    return containerView
  }
  
  func setSegmentSelected(_ segment: MediaSource.Segments) {
    setSelectedSegment(segment)
  }
  
  func setSegmentEnabled(_ segment: MediaSource.Segments, enabled: Bool) {
    guard let idx = segments.index(of: segment) else {
      return
    }
    
    segmentSelectorViewZeroWidthConstraints[idx].priority = enabled ? .defaultLow : .defaultHigh
    segmentSelectorViewFullWidthConstraints[idx].priority = !enabled ? .defaultLow : .defaultHigh
  }
}

// MARK: - MediaSourceView Viper Components API
fileprivate extension MediaSourceViewController {
    var presenter: MediaSourcePresenterApi {
        return _presenter as! MediaSourcePresenterApi
    }
}

//MARK:- Helpers

extension MediaSourceViewController {
  fileprivate func setSelectedSegment(_ segment: MediaSource.Segments) {
    segments.enumerated().forEach {
      let isSelected = $0.element == segment
      sourceButtons[$0.offset].isSelected = isSelected
    }
  }
  
  fileprivate func deselectAllButtons() {
    [librarySourceButton, photoSourceButton, videoSourceButton].forEach {
      $0?.isSelected = false
    }
  }
}
