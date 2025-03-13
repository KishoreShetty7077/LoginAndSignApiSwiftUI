//
//  LoginView.swift
//  FlywiesTask
//
//  Created by Manikanta on 3/3/25.
//

import SwiftUI

enum ScreenType: String {
    case login = "LOGIN"
    case signUp = "Register"
}

enum SocialLoginType: String {
    case google = "Google"
    case facebook = "Facebook"
}

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                if viewModel.isLoading {
                    ProgressView("Loading...")  // Loader
                        .padding()
                } else {
                    Image("loginIcon")
                        .frame(width: 94, height: 86)
                    
                    Text(viewModel.screenType == .login ? "Log In" : "Create Your Account")
                        .font(.system(size: 24))
                    
                    Text(viewModel.screenType == .login ?
                         "Enter your registered email & password" :
                            "Enter your details to get an account")
                    .foregroundStyle(.secondary)
                    
                    textfieldsView
                    
                    loginButton
                    
                    dividerView
                    
                    socialMediaButtons()
                    
                    Spacer()
                    
                    registerButtonView
                }
            }
            .padding()
            .alert(viewModel.alertMessage ?? "", isPresented: $viewModel.isShowAlert) {
                Button(role: .cancel) {
                    viewModel.isShowAlert = false
                } label: {
                    Text("Ok")
                }
            }

        }
    }

    var textfieldsView: some View {
        VStack {
            customTextField("Email", text: $viewModel.email)
            passwordField("Password", text: $viewModel.password, showPassword: $viewModel.showPassword)

            if viewModel.screenType == .signUp {
                passwordField("Confirm Password", text: $viewModel.confirmPassword, showPassword: $viewModel.showConfirmPassword)

                Spacer().frame(height: 10)

                HStack {
                    CustomCheckbox(isChecked: $viewModel.isAccepted, label: "Agree with our Terms & Conditions")
                    Spacer()
                }
            } else {
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Text("Forgot Password?")
                            .foregroundStyle(Color(red: 0/255, green: 0/255, blue: 0/255, opacity: 0.6))
                    }
                }
            }
        }
    }

    var loginButton: some View {
        Button(action: {
            
            if viewModel.screenType == .login {
                self.viewModel.callLoginApi()
            } else {
                self.viewModel.callSignUpApi()
            }
            
        }) {
            Text(viewModel.screenType.rawValue)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                
        }
        .padding(.horizontal, 10)
        .background(Color(red: 4/255, green: 132/255, blue: 179/255, opacity: 1))
        .cornerRadius(5)

    }

    var dividerView: some View {
        HStack {
            Divider()
                .frame(width: 20, height: 1)
                .background(.black)
                
            Text("or")
            
            Divider()
                .frame(width: 20, height: 1)
                .background(.black)
                
        }
    }

    func socialMediaButtons() -> some View {
        VStack(spacing: 8) {
            SocialLoginButton(provider: .google) {
                viewModel.handleLogin(provider: .google)
            }
            .padding(.horizontal, 10)

            SocialLoginButton(provider: .facebook) {
                viewModel.handleLogin(provider: .facebook)
            }
            .padding(.horizontal, 10)
        }
    }

    var registerButtonView: some View {
        HStack {
            Text(viewModel.screenType == .login ? "New user? " : "Already have an account?")
                .foregroundStyle(.secondary)

            Button {
                viewModel.toggleScreenType()
            } label: {
                Text(viewModel.screenType == .login ? "Register" : "Login")
                    //.foregroundColor(.blue)
                    .foregroundStyle(Color(red: 4/255, green: 132/255, blue: 179/255))
            }
        }
    }

    func customTextField(_ placeholder: String, text: Binding<String>) -> some View {
        HStack {
            if viewModel.screenType == .login {
                Image(systemName: "envelope")
                    .foregroundColor(.secondary)
            }
            TextField(placeholder, text: text)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(5)
    }

    func passwordField(_ placeholder: String, text: Binding<String>, showPassword: Binding<Bool>) -> some View {
        HStack {
            if viewModel.screenType == .login {
                Image(systemName: "lock")
                    .foregroundColor(.secondary)
            }
            if showPassword.wrappedValue {
                TextField(placeholder, text: text)
            } else {
                SecureField(placeholder, text: text)
            }
            Button { showPassword.wrappedValue.toggle() } label: {
                Image(systemName: showPassword.wrappedValue ? "eye.slash" : "eye")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(5)
    }
}


#Preview {
    LoginView()
}

struct SocialLoginButton: View {
    let provider: SocialLoginType
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(provider.rawValue)
                    .resizable()
                    .frame(width: 24, height: 24)

                Text("Login With \(provider.rawValue)")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
        }
    }
}


struct CustomCheckbox: View {
    
    @Binding var isChecked: Bool
    let label: String

    var body: some View {
        HStack {
            Button(action: { isChecked.toggle() }) {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(isChecked ? Color(red: 4/255, green: 132/255, blue: 179/255, opacity: 1) : Color(red: 217/255, green: 217/255, blue: 217/255, opacity: 1))
                
            }
            Text(label)
                .font(.system(size: 12))
        }
    }
}
