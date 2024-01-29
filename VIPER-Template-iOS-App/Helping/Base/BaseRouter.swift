//
//  BaseRouter.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

protocol BaseRouterProtocol {
  var appManager: AppManager? { get set }
  var view: Modulable? { get set }
  func open(_ viewController: UIViewController?, completion: VoidClosure?, embeded: Bool)
  func open(_ viewController: UIViewController?, with coordinator: UINavigationControllerDelegate, completion: VoidClosure?)
  func close(completion: VoidClosure?)
  func navigationBuilded(for viewController: UIViewController, title: String) -> UIViewController
}

extension BaseRouterProtocol {
  var viewController: UIViewController? {
    return view?.viewController
  }
  
  func open(_ viewController: UIViewController?, completion: VoidClosure?, embeded: Bool = false) {
    guard let viewController = viewController else {
      fatalError("ViewController does not exist")
    }
    
    if self.viewController?.navigationController != nil && !embeded {
      self.viewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
      self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    } else {
      self.viewController?.present(viewController, animated: true, completion: completion)
    }
  }
  
  func open(_ viewController: UIViewController?, with coordinator: UINavigationControllerDelegate, completion: VoidClosure?) {
    guard let viewController = viewController else {
      fatalError("ViewController does not exist")
    }
    
    guard let navigationController = self.viewController?.navigationController else {
      print("UINavigationController is not defined, using default \"present\" animation")
      self.viewController?.present(viewController, animated: true, completion: completion)
      return
    }
    
    navigationController.delegate = coordinator
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func close(completion: VoidClosure?) {
    guard let viewController = viewController else {
      fatalError("ViewController does not exist")
    }
    viewController.dismiss(animated: true, completion: completion)
  }
  
  func navigationBuilded(for viewController: UIViewController, title: String) -> UIViewController {
    let nav = UINavigationController(rootViewController: viewController)
    viewController.title = title
    return nav
  }
}

class BaseRouter: BaseRouterProtocol {
  var view: Modulable?
  var appManager: AppManager?
}
