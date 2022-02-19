//
//  ImgeCache.swift
//  ParsingImages
//
//  Created by Roman Zhukov on 20.02.2022.
//

import UIKit

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
