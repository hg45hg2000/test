//
//  knock4gamesTests.swift
//  knock4gamesTests
//
//  Created by CHEN HENG Lin on 2017/5/17.
//  Copyright © 2017年 CHEN HENG Lin. All rights reserved.
//

import XCTest

@testable import knock4games
class knock4gamesTests: XCTestCase {
    var api : LoginAPI!
   
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        api = LoginAPI(name: "ken", passWord: "1213")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testApitest(){
        api.requestAPI { (LoginAPIResponseData) in
            
        }
    }
    
}
