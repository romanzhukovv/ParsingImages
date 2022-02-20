//
//  ViewController.swift
//  ParsingImages
//
//  Created by Roman Zhukov on 19.02.2022.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet var fullImage: UIImageView!
    @IBOutlet var downloadDate: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var image: Image!
    
    private var imageURL: URL? {
        didSet {
            fullImage.image = nil
            updateImage()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        imageURL = URL(string: image.urls.full)
    }
    
    private func updateImage() {
        guard let imageURL = imageURL else { return }
        self.getImage(from: imageURL) { result in
            switch result {
            case .success(let image):
                if imageURL == self.imageURL {
                    self.fullImage.image = image
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getImage(from url: URL, completion: @escaping(Result<UIImage, Error>) -> Void){
        if let cachedImage = ImageCache.shared.object(forKey: url.absoluteString as NSString) {
            completion(.success(cachedImage))
            if let date = UserDefaults.standard.object(forKey: "\(url)") as? String {
                self.downloadDate.text = date
            }
            return
        }
        
        NetworkManager.shared.fetchImage(from: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                let date = "\(Date())"
                UserDefaults.standard.set(date, forKey: "\(url)")
                self.downloadDate.text = date
                ImageCache.shared.setObject(image, forKey: url.absoluteString as NSString)
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

