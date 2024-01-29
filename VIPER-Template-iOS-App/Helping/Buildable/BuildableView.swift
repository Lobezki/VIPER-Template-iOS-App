//
//  BuildableView.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

class BuildableView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    addViews()
    configureViews()
    anchorViews()
  }
  
  @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
    fatalError("not implemented")
  }
  
  func addViews() {

  }

  func configureViews() {

  }

  func anchorViews() {

  }

  func createToolBar() {
    
  }
}


protocol Overview: UIView {

}
