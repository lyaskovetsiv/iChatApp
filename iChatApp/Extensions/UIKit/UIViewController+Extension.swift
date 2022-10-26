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
    
    func showAlert(title: String, message: String, completionBlock: @escaping()->Void = { }){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                completionBlock()
            }
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }

}
