//
//  CaffeineTests.swift
//  CaffeineTests
//
//  Created by Emad A. on 22/04/2016.
//
//

import XCTest
import CoreLocation
@testable import Caffeine

class CaffeineTests: XCTestCase {
    
    let service = Service()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testServiceToGetVenues() {
        let expectation = expectationWithDescription("data task expectation")
        
        service.exploreVenues(CLLocationCoordinate2D(latitude: 40.7,longitude: -74), section: "cafe") { venues, error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
}
