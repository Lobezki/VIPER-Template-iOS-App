//
//  UITableView+Extensions.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

extension UITableView {
  func dequeue<CellType: UITableViewCell>(cellOfType type: CellType.Type, for indexPath: IndexPath) -> CellType? {
    return dequeueReusableCell(withIdentifier: type.reuseId, for: indexPath) as? CellType
  }
  
  func dequeueSupplementaryView<SupplementaryType: UIView>(viewOfType type: SupplementaryType.Type) -> SupplementaryType? {
    return dequeueReusableHeaderFooterView(withIdentifier: type.reuseId) as? SupplementaryType
  }
  
  func register<CellType: UITableViewCell>(cell: CellType.Type) {
    register(cell, forCellReuseIdentifier: cell.reuseId)
  }
  
  func registerSupplementaryView<SupplementaryType: UIView>(view: SupplementaryType.Type) {
    register(view, forHeaderFooterViewReuseIdentifier: view.reuseId)
  }
}
