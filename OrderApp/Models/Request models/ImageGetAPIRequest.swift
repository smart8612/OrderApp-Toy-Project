//
//  ImageGetAPIRequest.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-31.
//

import Foundation

struct ImageGetAPIRequest: APIRequest {
    
    typealias Response = Data
    
    let baseURL: String
    
    private var imageURL: URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.port = 8080
        return urlComponents?.url
    }
    
    var urlRequest: URLRequest? {
        guard let imageURL = imageURL else {
            return nil
        }
        return URLRequest(url: imageURL)
    }
    
    func decodeResponse(data: Data) throws -> Response {
        return data
    }
    
    func verify(response: URLResponse) throws -> Bool {
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ResponseError.imageDataMissing
        }
        return true
    }
    
    enum ResponseError: Error, LocalizedError {
        case imageDataMissing
    }
    
}
