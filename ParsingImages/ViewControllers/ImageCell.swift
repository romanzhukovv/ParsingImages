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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with image: Image) {
        ownerLabel.text?.append(contentsOf: image.user.name)
        likesLabel.text?.append(contentsOf: String(image.likes))
        
        guard let url = URL(string: image.urls.small) else { return }
        getImage(from: url) { result in
            switch result {
            case .success(let image):
                self.smallImage.image = image
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getImage(from url: URL, completion: @escaping(Result<UIImage, Error>) -> Void){
        NetworkManager.shared.fetchImage(from: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
