//
//  UIViewController+Extension.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 25.10.2022.
//

import Foundation
import UIKit

extension UIViewController{
    
    func configure<T: ConfiguringCell, U: Hashable>(collectionView: UICollectionView, cellType: T.Type, with value: U, for indexPath: IndexPath)->T{
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else
        { fatalError("Unable to dequeue cellType")}
        cell.configure(with: value)
        return cell
    }
    
}
