//
//  BuildableCollectionViewCell.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

class BuildableCollectionViewCell<View, Object>: UICollectionViewCell where View: UIView {
  var mainView: View
  
  override init(frame: CGRect) {
    self.mainView = View()
    super.init(frame: frame)
    contentView.addSubview(mainView)
    mainView.fillSuperview()
  }
  
  @available (*, unavailable) required init?(coder aDecoder: NSCoder) {
    fatalError("required init not implemented")
  }
  
  func config(with object: Object) { }
}
