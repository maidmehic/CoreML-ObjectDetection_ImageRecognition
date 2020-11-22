//
//  MoreVC.swift
//  CoreML-ImageDetector
//
//  Created by Maid Mehic on 21/11/2020.
//

import UIKit
import SDWebImage

class MoreVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    var searchTerm: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchQuery = searchTerm!.components(separatedBy: ",")[0]
        
        NetworkManager.shared.getWikiPost(term: searchQuery) { (extract, imageUrl, error) in
            if error == nil {
                self.labelView.text = extract
                
                if let url = imageUrl {
                    self.imageView.sd_setImage(with: url, completed: nil)
                }
            }
        }
    }
}
