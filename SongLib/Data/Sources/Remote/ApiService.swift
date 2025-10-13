//
//  ApiService.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

protocol ApiServiceProtocol {
    func fetch<T: Decodable>(endpoint: Endpoint) async throws -> T
}

class ApiService: ApiServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw ApiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.invalidResponse
        }
        
        switch httpResponse.statusCode {
            case 200...299:
                break
                
            case 400:
                throw ApiError.badRequest
            case 401:
                throw ApiError.unauthorized
            case 403:
                throw ApiError.forbidden
            case 404:
                throw ApiError.notFound
            case 422:
                throw ApiError.unprocessableEntity
            case 429:
                throw ApiError.rateLimited
            case 500...599:
                throw ApiError.serverError(
                    statusCode: httpResponse.statusCode
                )
            default:
                throw ApiError.unexpectedStatusCode(
                    statusCode: httpResponse.statusCode
                )
            }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw ApiError.decodingError(error)
        }
    }
    
    private func decodeErrorDetails(from data: Data) -> ErrorDetails? {
        return try? JSONDecoder().decode(ErrorDetails.self, from: data)
    }
}

enum ApiError: Error {
    case invalidURL
    case invalidResponse
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case unprocessableEntity
    case rateLimited
    case serverError(statusCode: Int)
    case unexpectedStatusCode(statusCode: Int)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
            case .invalidURL:
                return "The provided URL is invalid"
            case .invalidResponse:
                return "Received an invalid response from the server"
            case .badRequest:
                return "Bad request - the server could not understand the request"
            case .unauthorized:
                return "Unauthorized - authentication is required"
            case .forbidden:
                return "Forbidden - access to the resource is denied"
            case .notFound:
                return "The requested resource was not found on our server"
            case .unprocessableEntity:
                return "Unprocessable entity - the request was well-formed but contains semantic errors"
            case .rateLimited:
                return "Rate limited - too many requests"
            case .serverError(let statusCode):
                return "Server error (HTTP \(statusCode))"
            case .unexpectedStatusCode(let statusCode):
                return "Unexpected status code: \(statusCode)"
            case .decodingError(let error):
                return "Failed to decode response: \(error)"
        }
    }
}

struct ErrorDetails: Decodable {
    let message: String?
    let code: String?
    let details: [String]?
    
    enum CodingKeys: String, CodingKey {
        case message, code, details
        case error = "error"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        message = try? container.decode(String.self, forKey: .message)
        code = try? container.decode(String.self, forKey: .code)
        details = try? container.decode([String].self, forKey: .details)
    }
}

extension Endpoint {
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var body: Encodable? {
        return nil
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
