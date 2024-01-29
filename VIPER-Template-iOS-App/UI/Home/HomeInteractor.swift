//
//  HomeInteractor.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation

//MARK: - Declaration of functions presenter to deal with
protocol HomePresenterToInteractor {
  
}

//MARK: - Declaration of basics
final class HomeInteractor {
  var presenter: HomeInteractorToPresenter?
  var networkManager = NetworkingManager.shared
}

//MARK: - Realization of functionality
extension HomeInteractor: HomePresenterToInteractor {
  
}
