//
//  SignUpResponseModel.swift
//  FlywiesTask
//
//  Created by Manikanta on 3/3/25.
//

import Foundation

struct SignUpResponse: Decodable {
    let status: Int?
    let data: SignUpData?
}

struct SignUpData: Decodable {
    let user: User?
}

struct User: Decodable {
    let userId: String?
    let email: String?
}
