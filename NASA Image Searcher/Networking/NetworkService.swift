//
//  NetworkService.swift
//  NASA Image Searcher
//
//  Created by Adam Zuspan on 6/5/23.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case badRequest
    case networkError(Error)
    case decodingError(Error)
}
class NetworkService {
    private let baseURL = "https://images-api.nasa.gov/"
    
    //MARK: Build URL
    private func buildURL(path: String, queryItems: [URLQueryItem] = []) throws -> URL {
        var urlComponents = URLComponents(string: baseURL + path)
        var fullQueryItems = queryItems
        fullQueryItems.append(URLQueryItem(name: "media_type", value: "image"))
        urlComponents?.queryItems = fullQueryItems
        
        guard let url = urlComponents?.url else {
            throw APIError.invalidURL
        }
        return url
    }
    
    private func handleNetworkResponse(data: Data?, response: URLResponse?, error: Error?) throws -> SearchedDataListModel {
        if let error = error {
            throw APIError.networkError(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError(NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil))
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            //TODO: Handle specific HTTP status codes as needed
            throw APIError.networkError(NSError(domain: NSURLErrorDomain, code: httpResponse.statusCode, userInfo: nil))
        }
        
        guard let responseData = data else {
            throw APIError.networkError(NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil))
        }
        
        do {
            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(SearchedDataListModel.self, from: responseData)
            return apiResponse
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    //MARK: Make API Request
    func makeAPIRequest(path: String, queryItems: [URLQueryItem] = []) async throws -> SearchedDataListModel {
            let url = try buildURL(path: path, queryItems: queryItems)
            
            let (data, response) = try await URLSession.shared.data(from: url)
            return try handleNetworkResponse(data: data, response: response, error: nil)
        }
}
