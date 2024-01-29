//
//  BaseVIPER.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation

protocol BaseBuilder {
  associatedtype PresenterType
  static func create() -> (presenter: PresenterType, view: Modulable, router: BaseRouter)
}
