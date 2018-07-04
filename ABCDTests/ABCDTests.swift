//
//  ABCDTests.swift
//  ABCDTests
//
//  Created by Sarar Raad on 2018-07-01.
//  Copyright © 2018 Sarar Raad. All rights reserved.
//

import XCTest
@testable import ABCD

class ABCDTests: XCTestCase {
    var sessionUnderTest: URLSession!
    enum Result<Value> {
        case success(Value)
        case failure(Error)
    }
    struct Posting: Codable {
        let _id : String
        let email: String
        let fullName: String
        let time: String
        let distance: Int
        let latitude: Double
        let longitude: Double
    }
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sessionUnderTest = nil
        super.tearDown()
    }
    
    func testCallToHerokuApp() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let url = URL(string: "https://radiant-lowlands-29508.herokuapp.com/displayall")
        let promise = expectation(description: "Status code: 200, data available")
        let dataTask = sessionUnderTest.dataTask(with: url!){(responseData, response, responseError) in
            if let error = responseError{
                XCTFail("Error: \(error)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode{
                if statusCode == 200{
                    XCTAssertEqual(statusCode, 200)
                    if let jsonData = responseData{
                        let decoder = JSONDecoder()
                        do {
                            let posts = try decoder.decode([Posting].self, from: jsonData)
                            promise.fulfill()
                        } catch {
                            XCTFail("Error: \(error)")
                        }
                    }
                }
            }
        
        }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
