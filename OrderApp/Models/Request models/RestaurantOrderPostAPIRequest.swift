//
//  RestaurantOrderPostAPIRequest.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-28.
//

import Foundation

struct RestaurantOrderPostAPIRequest: RestaurantAPIRequest {
    typealias Response = OrderResponse
    
    private let menuIDs: [Int]
    
    private var baseOrderURL: URL? {
        baseURL?.appending(path: "order")
    }
    
    private var encodedMenuIDs: Data? {
        try? JSONEncoder().encode(["menuIds": menuIDs])
    }
    
    var urlRequest: URLRequest? {
        var request = postJsonURLRequest
        request?.url = baseOrderURL
        request?.httpBody = encodedMenuIDs
        return request
    }
    
    func decodeResponse(data: Data) throws -> Response {
        let order = try JSONDecoder().decode(Response.self, from: data)
        return order
    }
    
    func verify(response: URLResponse) throws -> Bool {
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ResponseError.orderRequestFailed
        }
        return true
    }
    
    enum ResponseError: Error, LocalizedError {
        case orderRequestFailed
    }
}
