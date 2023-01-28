//
//  APIRequest.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import Foundation

protocol APIRequest {
    associatedtype Response
    
    var urlRequest: URLRequest? { get }
    func decodeResponse(data: Data) throws -> Response
    
    @discardableResult
    func verify(response: URLResponse) throws -> Bool
}
