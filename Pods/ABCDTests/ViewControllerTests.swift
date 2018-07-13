//
//  ViewControllerTests.swift
//  ABCDTests
//
//  Created by jpa87 on 7/4/18.
//  Copyright © 2018 Sarar Raad. All rights reserved.
//

import XCTest
@testable import ABCD

class mockAlertAction: UIAlertAction{
    typealias Handler = ((UIAlertAction) -> Void)
    var handler: Handler?
    var mockTitle: String?
    var mockStyle: UIAlertActionStyle
    convenience init(title: String?, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Void)?){
        self.init()
        mockTitle = title
        mockStyle = style
        self.handler = handler
    }
    override init(){
        mockStyle = .default
        super.init()
    }
}
//Need to fix this unit test, test case is for testing UIAlertController, for some reason, cannot skip signin view controller and breaks
/*class ViewControllerTests: XCTestCase {
    var controllerUnderTest : FirstViewController!
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        controllerUnderTest = UIStoryboard(name: "FirstViewController", bundle: nil).instantiateInitialViewController() as! FirstViewController
        UIApplication.shared.keyWindow?.rootViewController = controllerUnderTest
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        controllerUnderTest = nil
        super.tearDown()
    }
    
    func testAlert_HasTitle(){
        controllerUnderTest.addPostsTouch(UIButton())
        XCTAssertTrue(controllerUnderTest.presentedViewController is UIAlertAction)
        XCTAssertEqual(controllerUnderTest.presentedViewController?.title, "Posting details")
    }
    func testAlert_FirstActionStoresDone(){
        controllerUnderTest.Action = mockAlertAction.self
        controllerUnderTest.addPostsTouch(UIButton)
        let alertController = controllerUnderTest.presentedViewController as! UIAlertController
        let action = alertController.actions.first as! mockAlertAction
        action.handler!(action)
        XCTAssertEqual(controllerUnderTest.actionString, "Done")
    }
}*/
