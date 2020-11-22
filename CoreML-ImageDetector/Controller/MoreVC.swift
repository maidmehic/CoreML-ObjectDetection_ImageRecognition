//
//  MoreVC.swift
//  CoreML-ImageDetector
//
//  Created by Maid Mehic on 21/11/2020.
//

import UIKit

class MoreVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    var searchTerm: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.getWikiPost(term: searchTerm!) { (extract, error) in
            self.labelView.text = extract
        }
    }
}
