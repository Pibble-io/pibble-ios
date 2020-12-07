//
//  UpVoteModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

//MARK: - UpVoteRouter API
protocol UpVoteRouterApi: RouterProtocol {
}

//MARK: - UpVoteView API
protocol UpVoteViewControllerApi: ViewControllerProtocol {
  func setViewModel(_ vm: UpVote.UpVoteViewModel?, animated: Bool)
  func setInputViewHidden(_ hidden: Bool, animated: Bool)
}

//MARK: - UpVotePresenter API
protocol UpVotePresenterApi: PresenterProtocol {
  var viewModel: UpVote.UpVoteViewModel? { get }
  
  var isPromoted: Bool { get }
  func handleHideAction()
  func handleVoteAction()
  func handleLikeAction()
  
  func handleSliderChangeValue(_ value: Float)
  func handleChangeValue(_ value: String)
  func handleChangeValueToMin()
  func handleChangeValueToMax()
  
  func presentUpvotingData(_ upvoting: UpVote.UpVoteModel)
}

//MARK: - UpVoteInteractor API
protocol UpVoteInteractorApi: InteractorProtocol {
  var selectedAmount: Int { get }
  func fetchInitialData()
  func setUpvoteValue(_ value: Int)
  func setValueToMin()
  func setValueToMax()
}

protocol UpVoteDelegateProtocol: class {
  func isPromoted() -> Bool
  func shouldUpVoteWithAmount(_ amount: Int)
}
