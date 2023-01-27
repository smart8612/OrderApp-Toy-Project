//
//  NetworkController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import Foundation

class NetworkController {
    
    func send<Request: APIRequest>(request: Request) async throws -> Request.Response {
        let (data, response) = try await URLSession.shared.data(for: request.urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIRequestError.itemNotFound
        }
        
        let decodedResponse = try request.decodeResponse(data: data)
        
        return decodedResponse
    }
    
    enum APIRequestError: Error {
        case itemNotFound
    }
    
}
