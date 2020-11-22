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
    
    func getWikiPost(term: String, onCompletion: ((String?, Error?) -> Void)? = nil) {
        let parameters: [String:String] =
            [
                "format":"json",
                "action":"query",
                "prop":"extracts",
                "exintro":"",
                "explaintext":"",
                "redirects":"1",
                "indexpageids":"",
                "titles":term
            ]
        
        Alamofire.request(wikipediaBaseURL, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                let json: JSON = JSON(response.result.value!)
                let pageId = json["query"]["pageids"][0].stringValue
                
                //                let wikiTitle = json["query"]["pages"][pageId]["title"]
                let wikiExtract = json["query"]["pages"][pageId]["extract"].stringValue
                
                if onCompletion != nil {onCompletion!(wikiExtract, nil)}
            } else {
                if onCompletion != nil {onCompletion!(nil, response.error)}
            }
        }
    }
}
