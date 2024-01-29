//
//  HomeBuilder.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation

final class HomeBuilder: BaseBuilder {
  static func create() -> (presenter: HomeInputs, view: Modulable, router: BaseRouter) {
    let view = HomeViewController()
    let presenter = HomePresenter()
    let interactor = HomeInteractor()
    let router = HomeRouter()

    view.presenter = presenter
    
    presenter.view = view
    presenter.interactor = interactor
    presenter.router = router
    
    interactor.presenter = presenter
    
    router.view = view

    return (presenter, view, router)
  }
}
