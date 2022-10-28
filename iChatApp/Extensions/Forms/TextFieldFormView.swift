//
//  TextFieldFormView.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 11.10.2022.
//

import UIKit
import SnapKit

class TextFieldFormView: UIView {

   init(label: UILabel, textField: UITextField) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        self.addSubview(textField)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
        }
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).inset(-5)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(30)
        }
        
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: textField.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("This initializer is not provided")
    }
    

}
