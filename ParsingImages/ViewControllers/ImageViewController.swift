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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        guard let url = URL(string: image.urls.full) else { return }
        
        DispatchQueue.global().async {
            NetworkManager.shared.fetchImage(from: url) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        self.fullImage.image = UIImage(data: image)
                        self.activityIndicator.stopAnimating()
                        self.downloadDate.text = "\(Date())"
                    case .failure(let error):
                        print(error)
                    }
                }
                
            }
        }
    }
    
    
}

