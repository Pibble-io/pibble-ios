//
//  CreatePostHelpModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 26/09/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - CreatePostHelpRouter API
protocol CreatePostHelpRouterApi: RouterProtocol {
  func routeToPickReward(delegate: PostHelpRewardPickDelegateProtocol)
}

//MARK: - CreatePostHelpView API
protocol CreatePostHelpViewControllerApi: ViewControllerProtocol {
  func reloadData()
  
  func setHelpText(_ text: String)
  func setCreatePostHelpButtonEnabled(_ enabled: Bool)
  
  func performHideAnimation(_ complete: @escaping () -> Void)
}

//MARK: - CreatePostHelpPresenter API
protocol CreatePostHelpPresenterApi: PresenterProtocol {
  func handleHideAction()
  
  func helpTypesNumberOfSections() -> Int
  func helpTypesNumberOfItemsInSection(_ section: Int) -> Int
  func helpTypesViewModelAt(_ indexPath: IndexPath) -> CreatePostHelpTypeItemViewModelProtocol
  
  func handleCreatePostHelpAction() 
  
  func rewardsNumberOfSections() -> Int
  func rewardsNumberOfItemsInSection(_ section: Int) -> Int
  func rewardsViewModelAt(_ indexPath: IndexPath) -> CreatePostHelpRewardItemViewModelProtocol
  
  func handleHelpTypeSelectionAt(_ indexPath: IndexPath)
  func handleRewardSelectionAt(_ indexPath: IndexPath)
  
  func handleHelpTextChange(_ text: String)
  
  func presentReload()
}

//MARK: - CreatePostHelpInteractor API
protocol CreatePostHelpInteractorApi: InteractorProtocol {
  var draft: MutablePostHelpDraftProtocol { get }
  
  var rewards: [CreatePostHelp.Reward] { get }
  var helpTypes: [CreatePostHelp.HelpType] { get }
  
  func initialFetchData()
}

protocol CreatePostHelpTypeItemViewModelProtocol {
  var title: String { get }
}

protocol CreatePostHelpRewardItemViewModelProtocol {
  var amount: String { get }
  var isSelected: Bool { get }
}

protocol MutablePostHelpDraftProtocol: class {
  var helpDescription: String { get set }
  var reward: CreatePostHelp.Reward? { get set }
  
  var canBePosted: Bool { get }
  var createPostHelpDraft: CreatePostHelpProtocol? { get }
}

protocol CreatePostHelpDelegateProtocol: class {
  func shouldCreatePostHelpWith(_ draft: CreatePostHelpProtocol)
}
