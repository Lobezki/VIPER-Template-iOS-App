//
//  SplashView.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

class SplashView: BuildableView {
  //MARK: - Subviews
  
  //MARK: - Add subviews into array
  override func addViews() {
    [].forEach{addSubview($0)}
  }
  
  //MARK: - Anchor your views
  override func anchorViews() {
    
  }
  
  //MARK: - Configure your views
  override func configureViews() {
    backgroundColor = .systemOrange
    
  }
}


