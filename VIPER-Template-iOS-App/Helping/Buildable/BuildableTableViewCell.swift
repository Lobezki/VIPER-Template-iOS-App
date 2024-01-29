//
//  BuildableTableViewCell.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

class BuildableTableViewCell<View, Object>: UITableViewCell where View: UIView {
  var mainView: View
  
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
     self.mainView = View()
     super.init(style: style, reuseIdentifier: reuseIdentifier)
     contentView.addSubview(mainView)
     mainView.fillSuperview()
    selectionStyle = .none
   }
  
   @available (*, unavailable) required init?(coder aDecoder: NSCoder) {
     fatalError("required init not implemented")
   }
  
  func config(with object: Object) { }
}
