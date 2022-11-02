//
//  ImageItem.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 02.11.2022.
//

import Foundation
import MessageKit


struct ImageItem: MediaItem{
    var url: URL? /// The url where the media is located.
    var image: UIImage? /// The image.
    var placeholderImage: UIImage /// A placeholder image for when the image is obtained asynchronously.
    var size: CGSize /// The size of the media item.
}
