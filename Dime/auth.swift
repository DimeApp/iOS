//
//  auth.swift
//  Dime
//
//  Created by Noah Karman on 2/3/17.
//  Copyright © 2017 Noah Karman. All rights reserved.
//

import Alamofire
import SwiftyJSON
import PromiseKit
import Foundation


class auth {
    let baseURL  = "https://thawing-woodland-86198.herokuapp.com/parse/"
    let defaults = UserDefaults.standard
    let error: String = "something bad happened!"
    
    let headers: HTTPHeaders = ["X-Parse-Application-Id": "11011011"]
    
    // Makes POST request to API that creates account, returns an access token that needs to be stored in user defaults
    // Params: username, password, name, email
    func signUp(userName: String, passWord:String, name:String, email:String) -> Promise<String>{
        let url = baseURL + "users"
        let params: Parameters = ["username": userName,
                                  "password": passWord,
                                  "email": email]
        
        return Promise<String>
            {
                fulfill,reject in
                Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: headers)
                    .validate(statusCode: 200..<300)
                    .responseJSON
                    {
                        (response) -> Void in
                        switch response.result
                        {
                        case .success:
                            if let responseDictionary: NSDictionary = response.result.value as? NSDictionary
                            {
                                if let sessionToken: String = responseDictionary["sessionToken"] as? String
                                {
                                    fulfill(sessionToken)
                                }
                            }
                        case .failure(let error):
                            reject(error)
                        }
                }
        }
    }
    
    //  Makes a post request to API to log a user in to their account, returns a sessionToken that needs to be stored until user logs out
    //  Params: email, password
    func login(email:String, passWord:String) -> Promise<String>{
        let theseHeaders: HTTPHeaders = ["X-Parse-Application-Id": "11011011"]
       // let loginUrl = baseURL + "login"
        // let params: Parameters = ["username": email, "password": passWord]
        
        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
        
        let codedEmail = email.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
        let codedPassword = passWord.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
        
        
        return Promise<String>
            {
            fulfill,reject in
                //Alamofire.request("https://thawing-woodland-86198.herokuapp.com/parse/login?username=\(codedEmail)&password=\(codedPassword)", headers: theseHeaders)
                if let theCodedEmail = codedEmail{
                    if let theCodedPassword = codedPassword{
    
                Alamofire.request("https://thawing-woodland-86198.herokuapp.com/parse/login?username="+theCodedEmail+"&password="+theCodedPassword, headers: theseHeaders)
                    .validate(statusCode: 200..<300)
                    .responseJSON
                    {
                    (response) -> Void in
                    switch response.result
                    {
                    case .success:
                        if let responseDictionary: NSDictionary = response.result.value as? NSDictionary
                        {
                            if let sessionToken = responseDictionary["sessionToken"] as? String
                            {
                                fulfill(sessionToken)
                            }
                        }
                    case .failure(let error):
                        reject(error)
                    }
                    
                    }
                }
            }
        }
    }
    
    
    // Makes a get request to the API, returns Promise of JSON object containing all charities
    func getCharities() -> Promise<JSON>{
        let url = baseURL + "classes/Charity"
        
        return Promise<JSON>
        {
            fulfill, reject in
            Alamofire.request(url, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON
            {
                (response) -> Void in
                switch response.result
                {
                case .success:
                    
                    if let result = response.result.value{
                        fulfill(JSON(result))
                    }
                    
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    // Makes a get request to the API, returns Promise of JSON object containg information on One Charity
    // Parameters: ObjectId for Charity (the charities' ID)
    func getCharity(objectId:String) -> Promise<JSON>{
        let url = baseURL + "classes/Charity" + objectId
        
        return Promise<JSON>
        {
           fulfill, reject in
            Alamofire.request(url, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON
            {
               (response) -> Void in
                switch response.result
                {
                case .success:
                    fulfill(response.result.value as! JSON)
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    // in full version, passed user's banking login info to server, will return securiry question or prompt for pin
    func getBankUserAccessToken() -> Promise<JSON>{
        let sessionToken = UserDefaults.standard.value(forKey: "sessionToken") as! String
        let url = baseURL + "functions/userAccessToken"
        let headers: HTTPHeaders = ["X-Parse-Application-Id": "11011011",
                                    "X-Parse-Session-Token": sessionToken]
//        let params: Parameters = ["username": "plaid_test",
//                                  "password": "plaid_good"]
        return Promise<JSON>
            {
                fulfill, reject in
                Alamofire.request(url, method: .post, encoding: URLEncoding.httpBody, headers: headers)
                    .validate(statusCode: 200..<300)
                    .responseJSON
                    {
                        (response) -> Void in
                        switch response.result
                        {
                        case .success:
                            
                            if let result = response.result.value{
                                fulfill(JSON(result))
                            }
                            
                        case .failure(let error):
                            reject(error)
                        }
                }
        }

        
    }
    // retrieves a JSON of transaction history from bank account
    
    func getTransactions() -> Promise<JSON>{
        let sessionToken = UserDefaults.standard.value(forKey: "sessionToken") as! String
        let url = baseURL + "functions/getTransactions"
        let headers: HTTPHeaders = ["X-Parse-Application-Id": "11011011",
                                    "X-Parse-Session-Token": sessionToken]
            return Promise<JSON>
            {
                fulfill, reject in
                Alamofire.request(url, method: .post, encoding: URLEncoding.httpBody, headers: headers)
                    .validate(statusCode: 200..<300)
                    .responseJSON
                    {
                        (response) -> Void in
                        switch response.result
                        {
                        case .success:
                            
                            if let result = response.result.value{
                                fulfill(JSON(result))
                            }
                            
                        case .failure(let error):
                            reject(error)
                        }
                }
        }

    }
    
    
    
    func getBalance() -> Promise<JSON>{
        let sessionToken = UserDefaults.standard.value(forKey: "sessionToken") as! String
        let url = baseURL + "functions/getUserBalance"
        let headers: HTTPHeaders = ["X-Parse-Application-Id": "11011011",
                                    "X-Parse-Session-Token": sessionToken]
        
        return Promise<JSON>
            {
                fulfill, reject in
                Alamofire.request(url, method: .post, encoding: URLEncoding.httpBody, headers: headers)
                    .validate(statusCode: 200..<300)
                    .responseJSON
                    {
                        (response) -> Void in
                        switch response.result
                        {
                        case .success:
                            
                            if let result = response.result.value{
                                fulfill(JSON(result))
                            }
                            
                        case .failure(let error):
                            reject(error)
                        }
                }
        }
        
    }
    
    func updateBalance(updatedBalance:Float) -> Promise<JSON>{
        let sessionToken = UserDefaults.standard.value(forKey: "sessionToken") as! String
        let url = baseURL + "functions/updateUserBalance"
        let headers: HTTPHeaders = ["X-Parse-Application-Id": "11011011",
                                    "X-Parse-Session-Token": sessionToken]
        let params: Parameters = ["balance": updatedBalance ]
        return Promise<JSON>
            {
                fulfill, reject in
                Alamofire.request(url, method: .post, parameters:params, encoding: URLEncoding.httpBody, headers: headers)
                    .validate(statusCode: 200..<300)
                    .responseJSON
                    {
                        (response) -> Void in
                        switch response.result
                        {
                        case .success:
                            
                            if let result = response.result.value{
                                fulfill(JSON(result))
                            }
                            
                        case .failure(let error):
                            reject(error)
                        }
                }
        }
        
    }
    
    func addUserCharity(updatedBalance:Float) -> Promise<JSON>{
        let sessionToken = UserDefaults.standard.value(forKey: "sessionToken") as! String
        let url = baseURL + "functions/addCharity"
        let headers: HTTPHeaders = ["X-Parse-Application-Id": "11011011",
                                    "X-Parse-Session-Token": sessionToken]
        let params: Parameters = ["charityId": "" ]
        return Promise<JSON>
            {
                fulfill, reject in
                Alamofire.request(url, method: .post, parameters:params, encoding: URLEncoding.httpBody, headers: headers)
                    .validate(statusCode: 200..<300)
                    .responseJSON
                    {
                        (response) -> Void in
                        switch response.result
                        {
                        case .success:
                            
                            if let result = response.result.value{
                                fulfill(JSON(result))
                            }
                            
                        case .failure(let error):
                            reject(error)
                        }
                }
        }
        
    }
    
    func getUserCharity() -> Promise<JSON>{
        let sessionToken = UserDefaults.standard.value(forKey: "sessionToken") as! String
        let url = baseURL + "functions/getUserCharityList"
        let headers: HTTPHeaders = ["X-Parse-Application-Id": "11011011",
                                    "X-Parse-Session-Token": sessionToken]
        let params: Parameters = ["charityId": "nah"]
        return Promise<JSON>
            {
                fulfill, reject in
                Alamofire.request(url, method: .post, parameters:params, encoding: URLEncoding.httpBody, headers: headers)
                    .validate(statusCode: 200..<300)
                    .responseJSON
                    {
                        (response) -> Void in
                        switch response.result
                        {
                        case .success:
                            
                            if let result = response.result.value{
                                fulfill(JSON(result))
                            }
                            
                        case .failure(let error):
                            reject(error)
                        }
                }
        }
        
    }
    
    

    
    
// end of class
}

