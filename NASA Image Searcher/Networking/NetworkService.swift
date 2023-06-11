//
//  NetworkService.swift
//  NASA Image Searcher
//
//  Created by Adam Zuspan on 6/5/23.
//

import Foundation

class NetworkService {
    private let baseURL = "https://images-api.nasa.gov/"
    
    //MARK: Build URL
    private func buildURL(path: String, queryItems: [URLQueryItem] = []) throws -> URL {
        var urlComponents = URLComponents(string: baseURL + path)
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else {
            throw APIError.invalidURL
        }
        return url
    }
    
    //MARK: Handle Response
    private func handleNetworkResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?) throws -> T {
        if let error = error {
            throw APIError.networkError(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError(NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil))
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.networkError(NSError(domain: NSURLErrorDomain, code: httpResponse.statusCode, userInfo: nil))
        }
        
        guard let responseData = data else {
            throw APIError.networkError(NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil))
        }
        
        do {
            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(T.self, from: responseData)
            return apiResponse
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    //MARK: Make API Request
    func makeAPIRequest<T: Decodable>(path: String, queryItems: [URLQueryItem] = []) async throws -> T {
        let url = try buildURL(path: path, queryItems: queryItems)
        let (data, response) = try await URLSession.shared.data(from: url)
        
        return try handleNetworkResponse(data: data, response: response, error: nil)
    }
}

extension NetworkService {
    enum APIError: LocalizedError, Error {
        case invalidURL
        case badRequest
        case networkError(Error)
        case decodingError(Error)
    }
}

extension NetworkService.APIError {
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "Bad Request"
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Invalid URL: Error is \(error.localizedDescription)"
        case .decodingError(let error):
            return "Could not decode network response: Error is \(error.localizedDescription)"
        }
    }
}
