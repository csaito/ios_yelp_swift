//
//  YelpClient.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

import AFNetworking
import BDBOAuth1Manager

// You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
let yelpConsumerKey = "SHHP7EFpCciYUMDHVumqLA"
let yelpConsumerSecret = "hIeHDz8zkpAxIcAymyfuXwx1ado"
let yelpToken = "-5h3eV4W5GSuuovZuzgzG6f4Lk7-LoP9"
let yelpTokenSecret = "MOZheIhfH7UrNTGlFYghpR3NFms"


enum YelpSortMode: Int {
    case bestMatched = 0, distance, highestRated
}

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    //MARK: Shared Instance
    
    static let sharedInstance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        let baseUrl = URL(string: "https://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(_ term: String, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
        return searchWithTerm(term, sort: nil, categories: nil, deals: nil, limit: nil, offset: nil, radius: nil, completion: completion)
    }
    
    func searchWithTerm(_ term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, limit: Int?, offset: Int?, radius: Int?, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        
        // Default the location to San Francisco
        var parameters: [String : AnyObject] = ["ll": "37.785771,-122.406165" as AnyObject]
        
        if term != "" {
            parameters["term"] = term as AnyObject
        }
        
        if sort != nil {
            parameters["sort"] = sort!.rawValue as AnyObject?
        }
        
        if categories != nil && categories!.count > 0 {
            parameters["category_filter"] = (categories!).joined(separator: ",") as AnyObject?
        }
        
        if deals != nil {
            parameters["deals_filter"] = deals! as AnyObject?
        }
        
        if offset != nil && offset! > 0 {
            parameters["offset"] = offset! as AnyObject?
            
            // Yelp API doesn't seem to like limit without offset
            if limit != nil && limit! > 0 {
                parameters["limit"] = limit! as AnyObject?
            }
            
        }
        
        if (radius != nil && radius! > 0) {
            parameters["radius_filter"] = radius! as AnyObject?
        }
        
        NSLog("parameters \(parameters)");
        
        return self.get("search", parameters: parameters,
                        success: { (operation: AFHTTPRequestOperation, response: Any) -> Void in
                            if let response = response as? [String: Any]{
            
                                //NSLog("response \(response)")
                                let dictionaries = response["businesses"] as? [NSDictionary]
                                if dictionaries != nil {
                                    completion(Business.businesses(array: dictionaries!), nil)
                                }
                            }
                        },
                        failure: { (operation: AFHTTPRequestOperation?, error: Error) -> Void in
                            completion(nil, error)
                        })!
    }
    
    
    func searchWithTerm(_ term: String, searchSettings: YelpSearchSettings, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
        return self.searchWithTerm(
            term,
            sort: searchSettings.sort,
            categories: searchSettings.categories,
            deals: searchSettings.deals,
            limit: searchSettings.limit,
            offset: searchSettings.offset,
            radius: searchSettings.radius,
            completion: completion
        )
    }
}
