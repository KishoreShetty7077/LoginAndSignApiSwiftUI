//
//  LoginViewModel.swift
//  FlywiesTask
//
//  Created by Manikanta on 3/3/25.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var showPassword = false
    @Published var showConfirmPassword = false
    @Published var screenType: ScreenType = .signUp
    @Published var isAccepted = false
    
    @Published var isLoading = false
    @Published var alertMessage: String?
    @Published var isShowAlert = false


    func handleLogin(provider: SocialLoginType) {
        print("\(provider.rawValue) Login Tapped")
    }

    func toggleScreenType() {
        screenType = (screenType == .signUp) ? .login : .signUp
        showPassword = false
        self.resetData()
    }
    
    func callLoginApi() {
        guard validateInputs(isSignUp: false) else { return }
        
        let params: [String: Any] = [
            "email": email,
            "password": password,
            "deviceToken": "",
            "iosDeviceToken": ""
        ]
        
        let loginURL = APIConstants.getFullURL(for: APIConstants.Endpoints.login, baseURL: .login)
        
        isLoading = true
        
        APIManager.shared.request(urlString: loginURL, method: .post, parameters: params) { [weak self] (result: Result<LoginResponse, APIError>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let response):
                        self?.alertMessage = "\(response.message ?? "Success")"
                        self?.isShowAlert = true
                        self?.resetData()
                case .failure(let error):
                    self?.alertMessage = "Login Failed: \(error.message)"
                    self?.isShowAlert = true
                }
            }
        }
    }
    
    func callSignUpApi() {
        guard validateInputs(isSignUp: false) else { return }
        
        let params: [String: Any] = [
            "email": email,
            "mobileNumber": "",
            "countryCode": "+91",
            "password": password,
            "confirmPassword": confirmPassword,
            "deviceToken": "",
            "iosDeviceToken": ""
        ]
        
        let signUpURL = APIConstants.getFullURL(for: APIConstants.Endpoints.signUp, baseURL: .signUp)
        
        isLoading = true  
        
        APIManager.shared.request(urlString: signUpURL, method: .post, parameters: params) { [weak self] (result: Result<SignUpResponse, APIError>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    print("SignUp Successful: \(response.data)")
                    self?.alertMessage = "SignUp Successful"
                    self?.isShowAlert = true
                    self?.resetData()
                    self?.screenType = .login
                case .failure(let error):
                    
                    self?.alertMessage = "SignUp Failed: \(error.message)"
                    self?.isShowAlert = true
                }
            }
        }
    }
    
    private func validateInputs(isSignUp: Bool) -> Bool {
            if email.isEmpty {
                self.alertMessage = "please enter email"
                self.isShowAlert = true
                return false
            }
            if !email.isValidEmail {
                self.alertMessage = "Enter a valid email address"
                self.isShowAlert = true
                return false
            }
            if password.isEmpty {
                self.alertMessage = "please enter password"
                self.isShowAlert = true
                return false
            }
            if !password.isValidPassword {
                self.alertMessage = "Password should contain Atleast one capitdal, one number one special charecter"
                self.isShowAlert = true
                return false
            }
            if isSignUp && password != confirmPassword {
                self.alertMessage = "Password must be the same"
                self.isShowAlert = true
                return false
            }
            return true
        }
    
    func resetData() {
        self.email = ""
        self.password = ""
        self.confirmPassword = ""

    }
}

extension String {
    var isValidEmail: Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*?&#])[A-Za-z\\d@$!%*?&#]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: self)
    }
}
