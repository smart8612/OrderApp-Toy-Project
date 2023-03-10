//
//  NetworkController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import Foundation

class NetworkController {
    
    func send<Request: APIRequest>(request: Request) async throws -> Request.Response {
        guard let urlRequest = request.urlRequest else {
            throw APIRequestError.invalidApiURL
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        try request.verify(response: response)
        let decodedResponse = try request.decodeResponse(data: data)
        
        return decodedResponse
    }
    
    enum APIRequestError: Error {
        case invalidApiURL
    }
    
}
