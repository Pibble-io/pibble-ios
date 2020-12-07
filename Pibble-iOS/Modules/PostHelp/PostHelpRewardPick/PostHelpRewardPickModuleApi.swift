//
//  PostHelpRewardPickModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

//MARK: - PostHelpRewardPickRouter API
protocol PostHelpRewardPickRouterApi: RouterProtocol {
}

//MARK: - PostHelpRewardPickView API
protocol PostHelpRewardPickViewControllerApi: ViewControllerProtocol {
  func setViewModel(_ vm: PostHelpRewardPick.PostHelpRewardPickViewModel?, animated: Bool)
  func setInputViewHidden(_ hidden: Bool, animated: Bool)
}

//MARK: - PostHelpRewardPickPresenter API
protocol PostHelpRewardPickPresenterApi: PresenterProtocol {
  var viewModel: PostHelpRewardPick.PostHelpRewardPickViewModel? { get }
  
  func handleHideAction()
  func handleConfirmAction()
  func handleLikeAction()
  
  func handleSliderChangeValue(_ value: Float)
  func handleChangeValue(_ value: String)
  func handleChangeValueToMin()
  func handleChangeValueToMax()
  
  func presentUpvotingData(_ upvoting: PostHelpRewardPick.PostHelpRewardPickModel)
}

//MARK: - PostHelpRewardPickInteractor API
protocol PostHelpRewardPickInteractorApi: InteractorProtocol {
  var pickedAmount: Int { get }
  func fetchInitialData()
  func setPickedValue(_ value: Double)
  func setValueToMin()
  func setValueToMax()
}

protocol PostHelpRewardPickDelegateProtocol: class {
  func shouldPostHelpRewardPickWithAmount(_ amount: Int)
}
