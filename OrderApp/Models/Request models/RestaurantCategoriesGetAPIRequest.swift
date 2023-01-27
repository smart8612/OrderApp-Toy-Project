//
//  RestaurantCategoriesGetAPIRequest.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import Foundation

struct RestaurantCategoriesGetAPIRequest: RestaurantAPIRequest {
    typealias Response = CategoriesResponse
    
    private var baseCategoryURL: URL? {
        baseURL?.appending(path: "categories")
    }
    
    var urlRequest: URLRequest? {
        guard let baseCategoryURL = baseCategoryURL else {
            return nil
        }
        return URLRequest(url: baseCategoryURL)
    }
    
    func decodeResponse(data: Data) throws -> CategoriesResponse {
        let categories = try JSONDecoder().decode(Response.self, from: data)
        return categories
    }
    
    enum ResponseError: Error, LocalizedError {
        case categoriesNotFound
    }
}
