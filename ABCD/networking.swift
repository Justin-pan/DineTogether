//
//  networking.swift
//  ABCD
//
//  Created by XCodeClub on 2018-07-03.
//  Copyright © 2018 Sarar Raad. All rights reserved.
//

import Foundation

struct User: Codable {
    let _id : String
    let email : String
    let fullName: String
    let description: String
    let preference: String
}

struct Posting: Codable {
    let _id : String
    let email: String
    let fullName: String
    let date: String
    let time: Int
    let distance: Int
    let latitude: Double
    let longitude: Double
    let preference: String
}
struct recievingFriend : Codable{
    let friendName : String
    let friendId : String
}
struct sendingFriend : Codable{
    let userId : String
    let friendName : String
    let friendId : String
}
//enumeration defines common type for a group of related values and enables you to work with those values in a type safe way
//in this case, the enum describes cases of a result (success, failure) with a value
enum Result<Value> {
    case success(Value)
    case failure(Error)
}

//function for getting posts with HTTP get request
func getPosts(completion: ((Error?) -> Void)?) {
    //Creating the url which will be used for the GET request
    var urlComponents = URLComponents()
    //request scheme
    urlComponents.scheme = "https"
    //request host
    urlComponents.host = "radiant-lowlands-29508.herokuapp.com"
    //request path
    urlComponents.path = "/test"
    //create the url, guard used for maintainability, transfers program control out of scope if conditions not met
    guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
    
    //create the request
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    //configurations for the URLSession
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    //sending the request and dealing with the response
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        guard responseError == nil else{
            completion?(responseError!)
            return
        }
        //API's usually respond with the data you sent
        if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
            print("response: ", utf8Representation)
        }else{
            print("No readable data recieved in response")
        }
    }
    
    task.resume()
}
//completion block that returns an error if something goes wrong
func submitPost(post: Posting, completion: ((Result<[Posting]>) -> Void)?) {
    //Creating the url which will be used for the GET request
    var urlComponents = URLComponents()
    //request scheme
    urlComponents.scheme = "https"
    //request host
    urlComponents.host = "radiant-lowlands-29508.herokuapp.com"
    //request path
    urlComponents.path = "/makePost"
    //create the url, guard used for maintainability, transfers program control out of scope if conditions not met
    guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
    //create post request with the created url
    var request = URLRequest(url: url)
    //post http method
    request.httpMethod = "POST"
    //request headers
    var headers = request.allHTTPHeaderFields ?? [:]
    //header is Content-Type and application/json
    headers["Content-Type"] = "application/json"
    //the request made has these headers/
    //these headers will let the server know that the request body is JSON encoded
    request.allHTTPHeaderFields = headers
    //instantiating the encoder
    let encoder = JSONEncoder()
    do{
        let jsonData = try encoder.encode(post)
        request.httpBody = jsonData
        //set httprequest body
        print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        
    }catch{
        completion?(.failure(error))
    }
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    //URL session data task with the request made
    let task = session.dataTask(with: request){ (responseData, response, responseError) in
            if let error = responseError {
                completion?(.failure(error))
            } else if let jsonData = responseData {
                // Now we have jsonData, Data representation of the JSON returned to us
                // from our URLRequest...
                
                // Create an instance of JSONDecoder to decode the JSON data to our
                // Codable struct
                let decoder = JSONDecoder()
                
                do {
                    // We would use Post.self for JSON representing a single Post
                    // object, and [Post].self for JSON representing an array of
                    // Post objects
                    let posts = try decoder.decode([Posting].self, from: jsonData)
                    completion?(.success(posts))
                } catch {
                    if let data = responseData, let str = String(data: data, encoding: String.Encoding.utf8){
                        print("Print Server data:- " + str)
                    }
                    completion?(.failure(error))
                }
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                completion?(.failure(error))
            }
        }
    task.resume()
    }


func signInUser(user: User, completion: ((Result<User>) -> Void)?){
    //Creating the url which will be used for the GET request
    var urlComponents = URLComponents()
    //request scheme
    urlComponents.scheme = "https"
    //request host
    urlComponents.host = "radiant-lowlands-29508.herokuapp.com"
    //request path
    urlComponents.path = "/signin"
    //create the url, guard used for maintainability, transfers program control out of scope if conditions not met
    guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
    //create post request with the created url
    var request = URLRequest(url: url)
    //post http method
    request.httpMethod = "POST"
    //request headers
    var headers = request.allHTTPHeaderFields ?? [:]
    //header is Content-Type and application/json
    headers["Content-Type"] = "application/json"
    //the request made has these headers/
    //these headers will let the server know that the request body is JSON encoded
    request.allHTTPHeaderFields = headers
    //instantiating the encoder
    let encoder = JSONEncoder()
    do{
        let jsonData = try encoder.encode(user)
        request.httpBody = jsonData
        //set httprequest body
        print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        
    }catch{
        completion?(.failure(error))
    }
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    //URL session data task with the request made
    let task = session.dataTask(with: request){(responseData, response, responseError) in
        DispatchQueue.main.async {
            if let error = responseError {
                completion?(.failure(error))
            } else if let jsonData = responseData {
                // Now we have jsonData, Data representation of the JSON returned to us
                // from our URLRequest...
                
                // Create an instance of JSONDecoder to decode the JSON data to our
                // Codable struct
                let decoder = JSONDecoder()
                
                do {
                    // We would use Post.self for JSON representing a single Post
                    // object, and [Post].self for JSON representing an array of
                    // Post objects
                    let posts = try decoder.decode(User.self, from: jsonData)
                    completion?(.success(posts))
                } catch {
                    completion?(.failure(error))
                }
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                completion?(.failure(error))
            }
        }
    }
    task.resume()
}
func getGraph(completion : ((Result<[Double]>) -> Void)?){
    //Creating the url which will be used for the GET request
    var urlComponents = URLComponents()
    //request scheme
    urlComponents.scheme = "https"
    //request host
    urlComponents.host = "radiant-lowlands-29508.herokuapp.com"
    //request path
    urlComponents.path = "/getTimeStats"
    guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
    //create the request
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    //configurations for the URLSession
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    //sending the request and dealing with the response
    let task = session.dataTask(with: request){(responseData, response, responseError) in
        if let error = responseError{
            completion?(.failure(error))
        }else if let data = responseData{
            do {
                let graphArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [Double]
                print("This is graph array \(graphArray)")
                completion?(.success(graphArray))
            }catch{
                completion?(.failure(error))
            }
        }
    }
    task.resume()
}
func updatePreference(user: User, completion: ((Error?) -> Void)?){
    //Creating the url which will be used for the GET request
    var urlComponents = URLComponents()
    //request scheme
    urlComponents.scheme = "https"
    //request host
    urlComponents.host = "radiant-lowlands-29508.herokuapp.com"
    //request path
    urlComponents.path = "/updatePreference/"
    //create the url, guard used for maintainability, transfers program control out of scope if conditions not met
    guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
    //create post request with the created url
    var request = URLRequest(url: url)
    //post http method
    request.httpMethod = "POST"
    //request headers
    var headers = request.allHTTPHeaderFields ?? [:]
    //header is Content-Type and application/json
    headers["Content-Type"] = "application/json"
    //the request made has these headers/
    //these headers will let the server know that the request body is JSON encoded
    request.allHTTPHeaderFields = headers
    //instantiating the encoder
    let encoder = JSONEncoder()
    do{
        let jsonData = try encoder.encode(user)
        request.httpBody = jsonData
        //set httprequest body
        print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        
    }catch{
        completion?(error)
    }
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    //URL session data task with the request made
    let task = session.dataTask(with: request){(responseData, response, responseError) in
        DispatchQueue.main.async {
            if let error = responseError {
                completion?(error)
            }
        }
    }
    task.resume()
}
func sendFriend(friend: sendingFriend, completion : ((Error?) -> Void)?){
    //Creating the url which will be used for the GET request
    var urlComponents = URLComponents()
    //request scheme
    urlComponents.scheme = "https"
    //request host
    urlComponents.host = "radiant-lowlands-29508.herokuapp.com"
    //request path
    urlComponents.path = "/updateFriends/"
    //create the url, guard used for maintainability, transfers program control out of scope if conditions not met
    guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
    //create post request with the created url
    var request = URLRequest(url: url)
    //post http method
    request.httpMethod = "POST"
    //request headers
    var headers = request.allHTTPHeaderFields ?? [:]
    //header is Content-Type and application/json
    headers["Content-Type"] = "application/json"
    //the request made has these headers/
    //these headers will let the server know that the request body is JSON encoded
    request.allHTTPHeaderFields = headers
    //instantiating the encoder
    let encoder = JSONEncoder()
    do{
        let jsonData = try encoder.encode(friend)
        request.httpBody = jsonData
        //set httprequest body
        print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        
    }catch{
        completion?(error)
    }
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    //URL session data task with the request made
    let task = session.dataTask(with: request){(responseData, response, responseError) in
        DispatchQueue.main.async {
            if let error = responseError {
                completion?(error)
            }
        }
    }
    task.resume()
}
func getFriends(user: User, completion : ((Result<[recievingFriend]>) -> Void)?){
    //Creating the url which will be used for the GET request
    var urlComponents = URLComponents()
    //request scheme
    urlComponents.scheme = "https"
    //request host
    urlComponents.host = "radiant-lowlands-29508.herokuapp.com"
    //request path
    urlComponents.path = "/findMyFriends/"
    //create the url, guard used for maintainability, transfers program control out of scope if conditions not met
    guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
    //create post request with the created url
    var request = URLRequest(url: url)
    //post http method
    request.httpMethod = "POST"
    //request headers
    var headers = request.allHTTPHeaderFields ?? [:]
    //header is Content-Type and application/json
    headers["Content-Type"] = "application/json"
    //the request made has these headers/
    //these headers will let the server know that the request body is JSON encoded
    request.allHTTPHeaderFields = headers
    //instantiating the encoder
    //instantiating the encoder
    let encoder = JSONEncoder()
    do{
        let jsonData = try encoder.encode(user)
        request.httpBody = jsonData
        //set httprequest body
        print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        
    }catch{
        completion?(.failure(error))
    }
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    //URL session data task with the request made
    let task = session.dataTask(with: request){(responseData, response, responseError) in
        DispatchQueue.main.async {
            if let error = responseError {
                completion?(.failure(error))
            } else if let jsonData = responseData {
                // Now we have jsonData, Data representation of the JSON returned to us
                // from our URLRequest...
                
                // Create an instance of JSONDecoder to decode the JSON data to our
                // Codable struct
                let decoder = JSONDecoder()
                do {
                    let friends = try decoder.decode([recievingFriend].self, from: jsonData)
                    completion?(.success(friends))
                } catch {
                    completion?(.failure(error))
                }
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                completion?(.failure(error))
            }
        }
    }
    task.resume()
}
