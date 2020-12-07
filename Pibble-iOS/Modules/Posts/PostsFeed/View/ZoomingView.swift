//
//  ZoomingView.swift
//  Pibble
//
//  Created by Kazakov Sergey on 19.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import AVKit

class ZoomingView: UIView {
  fileprivate let contentImageView: UIImageView = UIImageView()
  fileprivate var videoLayer: AVPlayerLayer?
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  fileprivate func setupView() {
    contentImageView.contentMode = .scaleAspectFill
    contentImageView.clipsToBounds = true
    addSubview(contentImageView)
  }
  
  override func removeFromSuperview() {
    videoLayer?.removeFromSuperlayer()
    super.removeFromSuperview()
  }
  
  func setViewModel(_ vm: PostsFeed.ContentViewModelType, initialFrame: CGRect) {
    frame = initialFrame
    contentImageView.frame = bounds
    switch vm {
    case .image(let content):
      videoLayer?.removeFromSuperlayer()
      contentImageView.setCachedImageOrDownload(content.urlString)
    case .video(let content):
      contentImageView.image = nil
      contentImageView.setCachedImageOrDownload(content.thumbnailImageUrlString)
      let newVideoLayer = AVPlayerLayer(urlString: content.urlString)
      
      videoLayer?.removeFromSuperlayer()
      videoLayer = newVideoLayer
      guard let video = videoLayer else {
        return
      }
      
      video.frame.size = bounds.size
      
      videoLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
      contentImageView.layer.addSublayer(video)
    }
  }
}
