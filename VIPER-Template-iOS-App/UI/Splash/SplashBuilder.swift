//
//  SplashBuilder.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation

final class SplashBuilder: BaseBuilder {
  static func create() -> (presenter: SplashInputs, view: Modulable, router: BaseRouter) {
    let view = SplashViewController()
    let presenter = SplashPresenter()
    let interactor = SplashInteractor()
    let router = SplashRouter()

    view.presenter = presenter
    
    presenter.view = view
    presenter.interactor = interactor
    presenter.router = router
    
    interactor.presenter = presenter
    
    router.view = view

    return (presenter, view, router)
  }
}
