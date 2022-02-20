//
//  ImageCell.swift
//  ParsingImages
//
//  Created by Roman Zhukov on 20.02.2022.
//

import UIKit

class ImageCell: UITableViewCell {
    @IBOutlet var smallImage: UIImageView!
    @IBOutlet var ownerLabel: UILabel!
    @IBOutlet var likesLabel: UILabel!
    
    private var imageURL: URL? {
        didSet {
            smallImage.image = nil
            updateImage()
        }
    }
    
    func configure(with image: Image) {
        ownerLabel.text = "\(image.user.name)"
        likesLabel.text = "❤️\(image.likes)"
        
        imageURL = URL(string: image.urls.small)
    }
    
    private func updateImage() {
        guard let imageURL = imageURL else { return }
        self.getImage(from: imageURL) { result in
            switch result {
            case .success(let image):
                if imageURL == self.imageURL {
                    self.smallImage.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getImage(from url: URL, completion: @escaping(Result<UIImage, Error>) -> Void){
        if let cachedImage = ImageCache.shared.object(forKey: url.absoluteString as NSString) {
            completion(.success(cachedImage))
            return
        }
        
        NetworkManager.shared.fetchImage(from: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                ImageCache.shared.setObject(image, forKey: url.absoluteString as NSString)
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
