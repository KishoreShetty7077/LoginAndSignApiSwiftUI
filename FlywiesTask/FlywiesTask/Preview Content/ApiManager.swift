//
//  ApiManager.swift
//  FlywiesTask
//
//  Created by Manikanta on 3/3/25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}


enum APIError: Error {
    case invalidURL
    case requestFailed(String)
    case decodingError(String)
    
    var message: String {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .requestFailed(let msg):
                return msg  // Extract only the error message
            case .decodingError(let msg):
                return msg
            }
        }
}

class APIManager {
    static let shared = APIManager()
    private init() {}

    func request<T: Decodable>(
        urlString: String,
        method: HTTPMethod,
        parameters: [String: Any]?,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let params = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            } catch {
                completion(.failure(.requestFailed("Failed to encode request body: \(error.localizedDescription)")))
                return
            }
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error.localizedDescription)))
                return
            }

            guard let data = data else {
                completion(.failure(.requestFailed("No data received")))
                return
            }

            let responseString = String(data: data, encoding: .utf8) ?? "Invalid response"
            print("Response Data: \(responseString)")

            do {
                // Parse response as a dictionary to extract status & message
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let statusCode = jsonObject["status"] as? Int {
                    
                    if statusCode == 201 || statusCode == 200 {
                        // Decode as success response
                        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedResponse))
                    } else {
                        // Extract error message from response
                        let errorMessage = jsonObject["message"] as? String ?? "An unexpected error occurred"
                        completion(.failure(.requestFailed(errorMessage)))
                    }
                    
                } else {
                    completion(.failure(.requestFailed("Invalid response format")))
                }

            } catch {
                completion(.failure(.decodingError("Decoding failed: \(error.localizedDescription)\nResponse: \(responseString)")))
            }
        }
        task.resume()
    }
}
