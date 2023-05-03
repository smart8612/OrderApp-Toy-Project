//
//  RestaurantMenuItemsGetAPIRequest.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import Foundation

struct RestaurantMenuItemsGetAPIRequest: RestaurantAPIRequest {
    
    typealias Response = MenuResponse
    
    let categoryName: String
    
    private var baseMenuURL: URL? {
        baseURL?.appendingPathComponent("menu")
    }
    
    private var menuURLWithQuery: URL? {
        guard let baseMenuURL = baseMenuURL else {
            return nil
        }
        
        var urlComponent = URLComponents(url: baseMenuURL, resolvingAgainstBaseURL: true)
        urlComponent?.queryItems = [
            URLQueryItem(name: "category", value: categoryName)
        ]
        
        return urlComponent?.url
    }   
    
    var urlRequest: URLRequest? {
        guard let menuURLWithQuery = menuURLWithQuery else {
            return nil
        }
        
        return URLRequest(url: menuURLWithQuery)
    }
    
    func decodeResponse(data: Data) throws -> Response {
        let menuItems = try JSONDecoder().decode(Response.self, from: data)
        return menuItems
    }
    
    func verify(response: URLResponse) throws -> Bool {
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ResponseError.menuItemNotFound
        }
        return true
    }
    
    enum ResponseError: Error, LocalizedError {
        case menuItemNotFound
    }
    
}
