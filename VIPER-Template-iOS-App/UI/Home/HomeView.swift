//
//  HomeView.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

class HomeView: BuildableView {
  //MARK: - Subviews
  let displayView = UIView()
  let controlsView = UIView()
  
  //MARK: - Add subviews into array
  override func addViews() {
    [displayView, controlsView].forEach{addSubview($0)}
  }
  
  //MARK: - Anchor your views
  override func anchorViews() {
    displayView
      .anchorTop(safeAreaLayoutGuideAnyIOS.topAnchor, 0)
      .anchorBottom(centerYAnchor, 10)
      .anchorLeft(leftAnchor, 10)
      .anchorRight(rightAnchor, 10)
    
    controlsView
      .anchorTop(centerYAnchor, 10)
      .anchorBottom(safeAreaLayoutGuideAnyIOS.bottomAnchor, 0)
      .anchorLeft(leftAnchor, 10)
      .anchorRight(rightAnchor, 10)
  }
  
  //MARK: - Configure your views
  override func configureViews() {
    backgroundColor = .darkGray
    
    displayView.backgroundColor = .grapefruit
    controlsView.backgroundColor = .slate
  }
}


