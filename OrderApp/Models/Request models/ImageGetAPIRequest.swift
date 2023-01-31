//
//  ImageGetAPIRequest.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-31.
//

import UIKit

struct ImageGetAPIRequest: APIRequest {
    
    typealias Response = UIImage
    
    let baseURL: String
    
    private var imageURL: URL? {
        URL(string: baseURL)
    }
    
    var urlRequest: URLRequest? {
        guard let imageURL = imageURL else {
            return nil
        }
        return URLRequest(url: imageURL)
    }
    
    func decodeResponse(data: Data) throws -> Response {
        guard let image = UIImage(data: data) else {
            throw ResponseError.imageDataMissing
        }
        return image
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
