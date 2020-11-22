//
//  NetworkManager.swift
//  CoreML-ImageDetector
//
//  Created by Maid Mehic on 22/11/2020.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {
    static let shared = NetworkManager() //singleton
    private init () {}

    private let wikipediaBaseURL = "https://en.wikipedia.org/w/api.php"
    
    func getWikiPost(term: String, onCompletion: ((String?, URL?, Error?) -> Void)? = nil) {
        let parameters: [String:String] =
            [
                "format":"json",
                "action":"query",
                "prop":"extracts|pageimages",
                "exintro":"",
                "explaintext":"",
                "redirects":"1",
                "indexpageids":"",
                "titles":term,
                "pithumbsize":"500"
            ]
        
        Alamofire.request(wikipediaBaseURL, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                let json: JSON = JSON(response.result.value!)
                let pageId = json["query"]["pageids"][0].stringValue
                let wikiExtract = json["query"]["pages"][pageId]["extract"].stringValue
                let thumbnail = json["query"]["pages"][pageId]["thumbnail"]["source"].url
                                
                if onCompletion != nil {onCompletion!(wikiExtract, thumbnail, nil)}
            } else {
                if onCompletion != nil {onCompletion!(nil, nil, response.error)}
            }
        }
    }
}
