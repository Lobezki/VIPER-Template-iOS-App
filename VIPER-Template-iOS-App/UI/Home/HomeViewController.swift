//
//  HomeViewController.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

//MARK: - Define event from view
enum HomeViewEvent {
  
}

//MARK: - Define functions that will be implemented in ViewController
protocol HomePresenterToView: AnyObject {
  func setupInitialState()
}

//MARK: - Implementation of ViewController
final class HomeViewController: BuildableViewController<HomeView> {
  var presenter: HomeViewToPresenter?

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter?.onViewLoaded()
  }
}

//MARK: - Implementation of defined funtions
extension HomeViewController: HomePresenterToView {
  func setupInitialState() {
    setupUI()
    setupActions()
  }
}

//MARK: - Private extension with additional setup
private extension HomeViewController {
  func setupUI() {
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  func setupActions() {
    
  }
}

