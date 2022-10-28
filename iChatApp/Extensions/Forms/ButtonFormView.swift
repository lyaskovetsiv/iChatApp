//
//  ButtonFormView.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 10.10.2022.
//

import UIKit
import SnapKit

class ButtonFormView: UIView {
    
    init(label: UILabel, button: UIButton){
        
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        self.addSubview(button)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(label.snp.bottom).inset(-5)
            make.height.equalTo(60)
        }
        
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("This initializer is not provided")
    }

}
