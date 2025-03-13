//
//  APIConstants.swift
//  FlywiesTask
//
//  Created by Manikanta on 3/3/25.
//

import Foundation

struct APIConstants {
    
    enum BaseURL: String {
        case signUp = "https://back-end.dually.app/api/api/v1/"
        case login = "https://dually.app/api/api/v1/"
    }
    
    struct Endpoints {
        static let signUp = "user/signup"
        static let login = "user/loginWithPhone"
    }
    
    static func getFullURL(for endpoint: String, baseURL: BaseURL) -> String {
        return baseURL.rawValue + endpoint
    }
}
