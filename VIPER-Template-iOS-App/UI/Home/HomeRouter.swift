//
//  HomeRouter.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

//MARK: - Declaration of functionality presenter to deal with
protocol HomeRoute {
  
}

//MARK: - Realization of funtionality
extension HomeRoute where Self: BaseRouter {

}

//MARK: - Presenter will know about routes through this class
final class HomeRouter: BaseRouter, HomeRouter.Routes {
  typealias Routes = HomeRoute
}

