//
//  Image.swift
//  ParsingImages
//
//  Created by Roman Zhukov on 19.02.2022.
//

import Foundation

struct Image: Decodable {
    let likes: Int
    let urls : Images
    let user: User
}

struct Images: Decodable {
    let small: String
    let full: String
}

struct User: Decodable {
    let name: String
}

