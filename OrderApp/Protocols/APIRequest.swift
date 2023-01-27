//
//  APIRequest.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import Foundation

protocol APIRequest {
    associatedtype Response
    
    var baseURL: URL? { get }
    var urlRequest: URLRequest? { get }
    func decodeResponse(data: Data) throws -> Response
    
    @discardableResult
    func verify(response: URLResponse) throws -> Bool
}

extension APIRequest {
    var postJsonURLRequest: URLRequest? {
        guard let baseURL = baseURL else {
            return nil
        }
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
    }
}
