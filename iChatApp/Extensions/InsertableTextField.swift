//
//  InsertableTextField.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 24.10.2022.
//

import Foundation
import UIKit

class InsertableTextField: UITextField{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        placeholder = "Write something there.."
        font = UIFont.systemFont(ofSize: 14)
        borderStyle = .roundedRect
        clearButtonMode = .whileEditing
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        let image = UIImage(systemName: "smiley")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.setColor(color: .systemGray)
        leftView = imageView
        leftView?.frame = CGRect(x: 0, y: 0, width: 20, height: 15)
        leftViewMode = .always
        
        let button = UIButton(type: .system)
        let buttonImage = UIImage(named: "sendMessage")
        button.setImage(buttonImage, for: .normal)
        rightView = button
        rightViewMode = .always
        rightView?.frame = CGRect(x: 0, y: 0, width: 15, height: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 12
        return rect
    }
}
