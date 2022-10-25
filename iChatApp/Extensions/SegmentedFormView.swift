//
//  SegmentedFormView.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 14.10.2022.
//

import Foundation
import UIKit
import SnapKit

class SegmentedFormView: UIView{
    
    init(label: UILabel, segmentedControl: UISegmentedControl){
        
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        self.addSubview(segmentedControl)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
        }
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).inset(-5)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        }
        
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("This initializer is not provided")
    }
    
}
