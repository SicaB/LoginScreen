//
//  LoginView.swift
//  LoginScreen
//
//  Created by Sacha Behrend on 02/11/2021.
//

import SwiftUI
import Combine


struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    @State private var keyboardClosed: Bool = true
    @State private var vStackPadding: CGFloat = 0.0
    
    var body: some View {
        ZStack(){
            GeometryReader() {
                geometry in
                if(UIDevice.isIPhone){
                    Image("primaryCircle")
                        .resizable()
                        .padding(.bottom, 50)
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                } else {
                        Image("primaryCircleIpad")
                        .resizable()
                        .padding(.bottom, 50)
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                            
                       
                    
                }
            }
            .ignoresSafeArea(.keyboard)
            VStack() {
                
                Image("logo")
                VStack(spacing: 22){
                    Spacer()
            
                    TextFields(viewModel: viewModel)
                        
                    if(viewModel.faceIDAvailable()){
                        FaceIdView()
                    }
                    ForgotLoginView()
                    Spacer()

                    // Sets the opacity of the button depending on the textfields being empty or not
                    if (viewModel.password.isEmpty || viewModel.email.isEmpty) {
                        ButtonView()
                            .opacity(0.4)
                    } else {
                        ButtonView()
                            .opacity(1)
                    }
                }
                
            }
            .padding(.horizontal, self.vStackPadding)
        }
        .onAppear {
            
           // viewModel.authenticate()
            if(UIDevice.isIPhone){
                self.vStackPadding = 0.0
                // Forcing the rotation to portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                // And making sure it stays that way
                AppDelegate.orientationLock = .portrait
            } else {
                self.vStackPadding = 150
                
            }

            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) { (noti) in
                self.keyboardClosed = false
                
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                self.keyboardClosed = true
            }
            
        }
        .onDisappear {
            // Unlocking the rotation when leaving the view
            AppDelegate.orientationLock = .all
        }
        .background(Image("bg")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
        )
    }
}

struct TextFields: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        
        TextField("", text: $viewModel.email)
            .placeholder(when: viewModel.email.isEmpty) {
                Text(viewModel.emailPlaceholder).foregroundColor(Color("lightGrayBlue"))
                    .font(.system(size: 16, weight: .light, design: .default))
            }
            .frame(height: 45)
            .padding(.leading, 25)
            .background(Color(.white))
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color("lightGrayBlue"), lineWidth: 1)
            )
            .padding(.horizontal, 30)
            .foregroundColor(Color(.gray))
            .keyboardType(.emailAddress)
        
        SecureField("", text: $viewModel.password)
            .placeholder(when: viewModel.password.isEmpty) {
                Text(viewModel.passwordPlaceholder)
                    .foregroundColor(Color("lightGrayBlue"))
                    .font(.system(size: 16, weight: .light, design: .default))
            }
            .frame(height: 45)
            .padding(.leading, 25)
            .background(Color(.white))
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color("lightGrayBlue"), lineWidth: 1)
            )
            .padding(.horizontal, 30)
            .foregroundColor(Color(.gray))
    }
}

struct FaceIdView: View {
    var body: some View {
        
        HStack() {
            Image("face_id_login")
            
            Text("Log ind med Face ID")
                .foregroundColor(Color(.white))
                .font(.system(size: 16, weight: .medium, design: .default))
        }
        .onTapGesture {
            // TODO: log in with face id
        }
    }
}

struct ForgotLoginView: View {
    var body: some View {
        Text("Glemt login?")
            .foregroundColor(Color(.white))
            .font(.system(size: 16, weight: .medium, design: .default))
            .onTapGesture {
                // TODO: Glemt login
            }
    }
}

struct ButtonView: View {
    var body: some View {
        Button{
            // TODO: Log the customer in
        } label: {
            Text("Log ind")
                .frame(maxWidth: .infinity, minHeight: 50)
                .foregroundColor(Color(.white))
                .background(BackgroundColor())
                .cornerRadius(25)
                .padding(.horizontal, 25)
//                .animation(.spring())
                .padding(.bottom, 50)
        }
    }
}

struct BackgroundColor: View {
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color("strongPink"), Color("reddishPink")]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

extension UIDevice {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
            
        }
    }
}
