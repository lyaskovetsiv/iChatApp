//
//  ConfiguringCell.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 19.10.2022.
//

import Foundation

protocol ConfiguringCell{
    static var reuseIdentifier: String {get}
    func configure(with value: MChat)
}
