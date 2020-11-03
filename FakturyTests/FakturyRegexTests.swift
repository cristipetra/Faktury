//
//  FakturyRegexTests.swift
//  FakturyRegexTests
//
//  Created by Radosław Mariowski on 27/07/2017.
//  Copyright © 2017 Test Project. All rights reserved.
//

import XCTest
@testable import Faktury

class FakturyRegexTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_aboutblank_should_always_not_force_transition() {
        let url = URL(string: "about:blank")!
        
        XCTAssert(url.isUrlWithTransition() == false)
    }
    
    func test_password_remind_should_always_not_force_transition() {
        let cases = [ URL(string: "https://www.faktury.co/faktury/site/login?password-remind=0")!, URL(string: "https://www.faktury.co/faktury/site/login?password-remind=1")!
        ]
        
        cases.forEach {
            XCTAssert($0.isUrlWithTransition() == false)
        }
    }
    
    func test_show_invoices_should_always_not_force_transition() {
        let cases = [
            URL(string: "https://www.faktury.co/faktury/invoice?period=&type=&status=")!,
            URL(string: "https://www.faktury.co/faktury/invoice?period=&type=&status=test-status")!,
            URL(string: "https://www.faktury.co/faktury/invoice?period=&type=1&status=")!,
            URL(string: "https://www.faktury.co/faktury/invoice?period=2017&type=&status=")!,
            URL(string: "https://www.faktury.co/faktury/invoice?period=2017-10&type=&status=")!,
            URL(string: "https://www.faktury.co/faktury/invoice?period=2017-10&type=1&status=test-status")!
        ]
        
        cases.forEach {
            XCTAssert($0.isUrlWithTransition() == false)
        }
    }
    
    func test_export_to_pdf_should_show_activity_indicator() {
        let url = URL(string: "https://www.faktury.co/faktury/invoice/exportToPDF/id/58")!
    
        XCTAssert(url.isUrlWithActivityIndicator() == true)
    }
    
}
