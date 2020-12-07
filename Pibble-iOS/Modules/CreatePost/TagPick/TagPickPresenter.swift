//
//  TagPickPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 20.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - TagPickPresenter Class
final class TagPickPresenter: Presenter {
  fileprivate weak var tagPickDelegate: TagPickDelegateProtocol?
  
  init(tagPickDelegate: TagPickDelegateProtocol) {
    self.tagPickDelegate = tagPickDelegate
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    guard let pickedTags = tagPickDelegate?.selectedTags() else {
      return
    }
    interactor.setInitialTags(pickedTags.tags)
  }
}

// MARK: - TagPickPresenter API
extension TagPickPresenter: TagPickPresenterApi {
  func handleDoneAction() {
    let tags = TagPick.PickedTags(tags: interactor.separatedTags)
    tagPickDelegate?.didSelectTags(tags)
    router.dismiss()
  }
  
  func handleSelectionAt(_ indexPath: IndexPath) {
    interactor.selectItemAt(indexPath)
  }
  
  func presentCurrentTagsString(_ string: String) {
    viewController.setCurrentTagString(string)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func presentTagsCollection() {
    viewController.reloadTagsCollection()
  }
  
  func numberOfSections() -> Int {
    return interactor.numberOfSections()
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return interactor.numberOfItemsInSection(section)
  }
  
  func itemViewModelFor(_ indexPath: IndexPath) -> TagViewModelProtocol {
      let tagItem = interactor.itemViewModelFor(indexPath)
    var presentationStyle = TagPick.ItemPresentationStyle.defaultStyle
    
    if indexPath.item == 0 {
      presentationStyle = .top
    }
    if indexPath.item == interactor.numberOfItemsInSection(indexPath.section) - 1 {
      presentationStyle = .bottom
    }
    
    if interactor.numberOfItemsInSection(indexPath.section) == 1 {
      presentationStyle = .single
    }
    
    return TagPick.TagSuggestionViewModel(title: tagItem.tagTitle, presentationStyle: presentationStyle)
  }
  
  func handleInputTextChange(_ text: String) {
    interactor.searchTagsFor(text)
  }
}

// MARK: - TagPick Viper Components
fileprivate extension TagPickPresenter {
    var viewController: TagPickViewControllerApi {
        return _viewController as! TagPickViewControllerApi
    }
    var interactor: TagPickInteractorApi {
        return _interactor as! TagPickInteractorApi
    }
    var router: TagPickRouterApi {
        return _router as! TagPickRouterApi
    }
}

fileprivate extension TagProtocol {
  var tagTitle: String {
    return "#\(cleanTagString)"
  }
}


