//
//  iOSTaskTests.swift
//  iOSTaskTests
//
//  Created by eslam mohamed on 3/25/25.
//

import XCTest
@testable import iOSTask
final class iOSTaskTests: XCTestCase {

    private var viewModel: ViewModel!
    override func setUp() {
        viewModel = ViewModel()
    }
    
    override func tearDown() {
        print("Finished a test.")
    }
    
    
    func test_AllCategories_isnot_nil() {
        Task {
            var failed = false
            do {
                let result = try await viewModel.allCategories()
                XCTAssertNotNil(result)
               
            } catch {
                failed = true
                XCTAssertNil(error)
            }
           XCTAssertEqual(failed, false, "expecting failed and getting error is false")
        }
       
    }
    
    func test_subcategories_isnot_nil() {
        Task {
            var failed = false
            do {
                let result = try await viewModel.subCategories(id: 4)
                XCTAssertNotNil(result)
               
            } catch {
                failed = true
                XCTAssertNil(error)
            }
           XCTAssertEqual(failed, false, "expecting failed and getting error is false")
        }
       
    }
    
    func test_subcategories_options_isnot_nil() {
        Task {
            var failed = false
            do {
                let result = try await viewModel.subCategories(id: 2)
                XCTAssertNotNil(result)
               
            } catch {
                failed = true
                XCTAssertNil(error)
            }
           XCTAssertEqual(failed, false, "expecting failed and getting error is false")
        }
       
    }

}
