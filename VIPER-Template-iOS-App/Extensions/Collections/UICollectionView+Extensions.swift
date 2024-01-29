//
//  UICollectionView+Extensions.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import UIKit

extension UICollectionView {
  func dequeue<CellType: UICollectionViewCell>(cellOfType type: CellType.Type, for indexPath: IndexPath) -> CellType? {
    return dequeueReusableCell(withReuseIdentifier: type.reuseId, for: indexPath) as? CellType
  }
  
  func register<CellType: UICollectionViewCell>(cell: CellType.Type) {
    register(cell, forCellWithReuseIdentifier: cell.reuseId)
  }
}
