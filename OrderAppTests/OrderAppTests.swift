//
//  OrderAppTests.swift
//  OrderAppTests
//
//  Created by JeongTaek Han on 2023-01-27.
//

import XCTest
@testable import OrderApp

final class OrderAppTests: XCTestCase {
    
    private var restaurantController: RestaurantController!

    override func setUpWithError() throws {
        self.restaurantController = RestaurantController.shared
    }

    override func tearDownWithError() throws {
        self.restaurantController = nil
    }
    
    func test_id_is_5_submitOrder_return_int() async throws {
        let result = try await self.restaurantController.submitOrder(forMenuIDs: [5])
        XCTAssertEqual(result, 5)
    }

    func test_fetchCategories_return_string_array_with_contents() async throws {
        let result = try await self.restaurantController.fetchCategories()
        XCTAssertFalse(result.isEmpty)
    }
    
    func test_appetizers_fetchMenuItems_return_menuItem_array_with_contents() async throws {
        let result = try await self.restaurantController.fetchMenuItems(forCategory: "appetizers")
        XCTAssertFalse(result.isEmpty)
    }
    
    func test_salads_fetchMenuItems_return_menuItem_array_with_contents() async throws {
        let result = try await self.restaurantController.fetchMenuItems(forCategory: "salads")
        XCTAssertFalse(result.isEmpty)
    }
    
    func test_soups_fetchMenuItems_return_menuItem_array_with_contents() async throws {
        let result = try await self.restaurantController.fetchMenuItems(forCategory: "soups")
        XCTAssertFalse(result.isEmpty)
    }
    
    func test_sandwiches_fetchMenuItems_return_menuItem_array_with_contents() async throws {
        let result = try await self.restaurantController.fetchMenuItems(forCategory: "sandwiches")
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_entrees_fetchMenuItems_return_menuItem_array_with_contents() async throws {
        let result = try await self.restaurantController.fetchMenuItems(forCategory: "entrees")
        XCTAssertFalse(result.isEmpty)
    }
    
    func test_desserts_fetchMenuItems_return_menuItem_array_with_contents() async throws {
        let result = try await self.restaurantController.fetchMenuItems(forCategory: "desserts")
        XCTAssertTrue(result.isEmpty)
    }
    
}
