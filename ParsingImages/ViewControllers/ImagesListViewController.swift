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
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageCell
        let image = images[indexPath.row]
        cell.configure(with: image)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        265
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let image = images[indexPath.row]
        let imageVC = segue.destination as! ImageViewController
        imageVC.image = image
    }
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
}
