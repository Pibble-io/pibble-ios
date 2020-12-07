//
//  TagPickInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 20.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - TagPickInteractor Class
final class TagPickInteractor: Interactor {
  fileprivate let postingService: PostingServiceProtocol
  fileprivate var tags: [[TagProtocol]] = [[]]

  private(set) var separatedTags: [String] = []
 
  fileprivate var performSearchObject = DelayBlockObject()
  
  init(postingService: PostingServiceProtocol) {
    self.postingService = postingService
  }
}

// MARK: - TagPickInteractor API
extension TagPickInteractor: TagPickInteractorApi {
  func setInitialTags(_ tags: [String]) {
    separatedTags = tags
    presenter.presentCurrentTagsString(joinedTagsString(separatedTags))
  }
  
  func selectItemAt(_ indexPath: IndexPath) {
    let selectedTag = tags[indexPath.section][indexPath.item]
    
    if separatedTags.count > 0 {
      separatedTags.removeLast()
    }
    
    separatedTags.append(selectedTag.cleanTagString)
    
    presenter.presentCurrentTagsString(joinedTagsString(separatedTags))
    tags = [[]]
    presenter.presentTagsCollection()
  }
  
  func numberOfSections() -> Int {
    return tags.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return tags[section].count
  }
  
  func itemViewModelFor(_ indexPath: IndexPath) -> TagProtocol {
    return tags[indexPath.section][indexPath.item]
  }
  
  func searchTagsFor(_ text: String) {
    separatedTags = parseSearchString(text).map { String($0)}
    guard let lastTag = separatedTags.last else {
      return
    }
    
    let lastTagString = String(lastTag)
    guard lastTagString.count > 0 else {
      return
    }
    
    scheduleSearchFor(lastTagString)
  }
  
  func scheduleSearchFor(_ tag: String) {
    performSearchObject.cancel()
    performSearchObject.scheduleAfter(delay: 0.45) { [weak self] in
      self?.performSearchFor(tag)
    }
  }
  
  func performSearchFor(_ tag: String) {
    postingService.searchTag(tag) { [weak self] in
      switch $0 {
      case .success(let tags):
        self?.tags = [tags]
        self?.presenter.presentTagsCollection()
      case .failure(let err):
        self?.presenter.handleError(err)
      }
    }
  }
}

// MARK: - Interactor Viper Components Api
fileprivate extension TagPickInteractor {
    var presenter: TagPickPresenterApi {
        return _presenter as! TagPickPresenterApi
    }
}

extension TagPickInteractor {
  func parseSearchString(_ string: String) -> [Substring] {
    return string
            .replacingOccurrences(of: "#", with: " ")
            .replacingOccurrences(of: ",", with: " ")
            .split(separator: " ")
  }
  
  func joinedTagsString(_ tags: [String]) -> String {
    return "\(tags.joined(separator: " ")) "
  }
}

