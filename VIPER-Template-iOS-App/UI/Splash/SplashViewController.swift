//
//  SplashViewController.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

//MARK: - Define event from view
enum SplashViewEvent {
  
}

//MARK: - Define functions that will be implemented in ViewController
protocol SplashPresenterToView: AnyObject {
  func setupInitialState()
}

//MARK: - Implementation of ViewController
final class SplashViewController: BuildableViewController<SplashView> {
  var presenter: SplashViewToPresenter?

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter?.onViewLoaded()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    presenter?.onViewAppeared()
  }
}

//MARK: - Implementation of defined funtions
extension SplashViewController: SplashPresenterToView {
  func setupInitialState() {
    setupUI()
    setupActions()
  }
}

//MARK: - Private extension with additional setup
private extension SplashViewController {
  func setupUI() {
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  func setupActions() {
    
  }
}

