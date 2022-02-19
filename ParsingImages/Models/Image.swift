//
//  Image.swift
//  ParsingImages
//
//  Created by Roman Zhukov on 19.02.2022.
//

import Foundation

struct Image: Decodable {
    let id: String
    let urls : Images
}

struct Images: Decodable {
    let small: String
}

