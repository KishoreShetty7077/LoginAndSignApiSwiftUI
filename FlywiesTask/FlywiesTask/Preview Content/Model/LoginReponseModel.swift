//
//  LoginReponseModel.swift
//  FlywiesTask
//
//  Created by Manikanta on 3/3/25.
//

import Foundation

struct LoginResponse: Decodable {
    let status: Int
    let message: String?
    let data: UserData
}

struct UserData: Decodable {
    let id: String
    let email: String
}
