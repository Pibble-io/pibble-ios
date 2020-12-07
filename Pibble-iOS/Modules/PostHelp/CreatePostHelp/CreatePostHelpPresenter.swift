//
//  CreatePostHelpPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 26/09/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - CreatePostHelpPresenter Class
final class CreatePostHelpPresenter: Presenter {
  fileprivate weak var delegate: CreatePostHelpDelegateProtocol?
  
  fileprivate var helpTypes: [[CreatePostHelp.HelpType]] {
    return [interactor.helpTypes]
  }
  
  fileprivate var rewards: [[CreatePostHelp.Reward]] {
    return [interactor.rewards]
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    interactor.initialFetchData()
    viewController.setCreatePostHelpButtonEnabled(interactor.draft.canBePosted)
  }
  
  init(delegate: CreatePostHelpDelegateProtocol) {
    self.delegate = delegate
  }
}

// MARK: - CreatePostHelpPresenter API
extension CreatePostHelpPresenter: CreatePostHelpPresenterApi {
  func handleCreatePostHelpAction()  {
    guard let creationDraft = interactor.draft.createPostHelpDraft else {
      return
    }
    
    viewController.performHideAnimation() { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.router.dismiss()
      strongSelf.delegate?.shouldCreatePostHelpWith(creationDraft)
    }
  }
  
  func handleHelpTextChange(_ text: String) {
    interactor.draft.helpDescription = text
    
    viewController.setCreatePostHelpButtonEnabled(interactor.draft.canBePosted)
  }
  
  func handleHelpTypeSelectionAt(_ indexPath: IndexPath) {
    let helpItem = helpTypes[indexPath.section][indexPath.item]
    switch helpItem {
    case .predefinedText(let text):
      interactor.draft.helpDescription = text
    }
    
    
    viewController.setHelpText(interactor.draft.helpDescription)
    viewController.setCreatePostHelpButtonEnabled(interactor.draft.canBePosted)
  }
  
  func handleRewardSelectionAt(_ indexPath: IndexPath) {
    let rewardItem = rewards[indexPath.section][indexPath.item]
    
    switch rewardItem {
    case .predefinedAmount(_):
      interactor.draft.reward = rewardItem
      viewController.reloadData()
      viewController.setCreatePostHelpButtonEnabled(interactor.draft.canBePosted)
    case .amount(_):
      router.routeToPickReward(delegate: self)
    }
    
  }
  
  func presentReload() {
    viewController.reloadData()
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func helpTypesNumberOfSections() -> Int {
    return helpTypes.count
  }
  
  func helpTypesNumberOfItemsInSection(_ section: Int) -> Int {
    return helpTypes[section].count
  }
  
  func helpTypesViewModelAt(_ indexPath: IndexPath) -> CreatePostHelpTypeItemViewModelProtocol {
    let helpItem = helpTypes[indexPath.section][indexPath.item]
    return CreatePostHelp.TypeItemViewModel(helpType: helpItem)
  }
  
  func rewardsNumberOfSections() -> Int {
    return rewards.count
  }
  
  func rewardsNumberOfItemsInSection(_ section: Int) -> Int {
    return rewards[section].count
  }
  
  func rewardsViewModelAt(_ indexPath: IndexPath) -> CreatePostHelpRewardItemViewModelProtocol {
    let rewardItem = rewards[indexPath.section][indexPath.item]
    let isSelected = interactor.draft.reward.map { $0 == rewardItem } ?? false
    
    return CreatePostHelp.RewardItemViewModel(reward: rewardItem, isSelected: isSelected)
  }
}

// MARK: - CreatePostHelp Viper Components
fileprivate extension CreatePostHelpPresenter {
  var viewController: CreatePostHelpViewControllerApi {
    return _viewController as! CreatePostHelpViewControllerApi
  }
  var interactor: CreatePostHelpInteractorApi {
    return _interactor as! CreatePostHelpInteractorApi
  }
  var router: CreatePostHelpRouterApi {
    return _router as! CreatePostHelpRouterApi
  }
}


//MARK:- PostHelpRewardPickDelegateProtocol

extension CreatePostHelpPresenter: PostHelpRewardPickDelegateProtocol {
  func shouldPostHelpRewardPickWithAmount(_ amount: Int) {
    interactor.draft.reward = .amount(amount)
    viewController.reloadData()
    viewController.setCreatePostHelpButtonEnabled(interactor.draft.canBePosted)
  }
}
