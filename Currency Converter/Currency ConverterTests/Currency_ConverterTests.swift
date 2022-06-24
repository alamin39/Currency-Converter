//
//  Currency_ConverterTests.swift
//  Currency ConverterTests
//
//  Created by Al-Amin on 13/6/22.
//

import XCTest
@testable import Currency_Converter

class Currency_ConverterTests: XCTestCase {
    
    var sut: URLSession!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = URLSession(configuration: .default)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testSaveLastServiceCalledDate() {
        XCTAssertNil( UserDefaults.standard.value(forKey: "serviceCallDate") )
    }
    
    func testValidApiCallGetsHTTPStatusCode200() throws {
        
        let urlString =
            "https://openexchangerates.org/api/latest.json?app_id=fe4030fd00d748f692aea54cd102a2db"
        let url = URL(string: urlString)!
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = sut.dataTask(with: url) { _, response, error in
            
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            }
            else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                }
                else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
    }
    
    
    func testApiCallCompletes() throws {
        
        let urlString = "https://openexchangerates.org/api/latest.json?app_id=fe4030fd00d748f692aea54cd102a2db"
        let url = URL(string: urlString)!
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        let dataTask = sut.dataTask(with: url) { _, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testPerformanceExample() throws {
        self.measure {
            
        }
    }
}
