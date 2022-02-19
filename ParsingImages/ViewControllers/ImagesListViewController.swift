//
//  ImagesListViewCellTableViewController.swift
//  ParsingImages
//
//  Created by Roman Zhukov on 19.02.2022.
//

import UIKit

class ImagesListViewController: UITableViewController {
    private var images: [Image] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImages()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        images.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
        let image = images[indexPath.row]
        cell.textLabel?.text = image.id
        cell.detailTextLabel?.text = "456456"
        
        guard let url = URL(string: image.urls.small) else { return cell }
        getImage(from: url) { result in
            switch result {
            case .success(let image):
                cell.imageView?.image = image
            case .failure(let error):
                print(error)
            }
        }
        
        return cell
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ImagesListViewController {
    private func fetchImages() {
        NetworkManager.shared.fetchData { result in
            switch result {
            case .success(let images):
                self.images = images
                self.tableView.reloadData()
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
