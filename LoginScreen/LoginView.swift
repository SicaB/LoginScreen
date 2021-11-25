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
    //@ObservedObject var keyboard = KeyboardResponder()
    @State private var keyboardHeight: CGFloat = 0
   // @State private var keyboardDuration: TimeInterval = 0
    @State private var opacitySettings: Double = 0.4
    @State private var keyboardOpened: Bool = false
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(){
                Image("primaryCircle")
                    .resizable()
                    .padding(.bottom, 50)
                    .scaledToFill()

                VStack() {
                    Image("logo")

                        VStack(spacing: 22){
                    Spacer()
                        .frame(height: 120)
                        
                            TextField("", text: $viewModel.email, onEditingChanged: { (editingChanged) in
                                self.viewModel.editing = editingChanged
                            })
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
//                                .modifier(TextFieldClearButton(text: $viewModel.email))
//                                .multilineTextAlignment(.leading)
                                .keyboardType(.emailAddress)
                            
                            SecureField("", text: $viewModel.password)
                                .onTapGesture {
                                    //self.viewModel.editing = true
                                }
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
                        
                        // If keyboard is not showing, show FaceID and 'glemt login'
                        if (self.keyboardHeight == 0.0){
                        FaceIdAndForgotPasswordView()
                        Spacer()
                        }
                                //.ignoresSafeArea(.keyboard)
                               //.keyboardAdaptive()
                                //.KeyboardAwarePadding()
                        }
                    Spacer()
                    
                    // Sets the opacity of the button depending on the textfields being empty or not
                    if (viewModel.password.isEmpty || viewModel.email.isEmpty) {
                        ButtonView()
                            .offset(y: -self.keyboardHeight)
                            .opacity(0.4)

                    } else {
                        ButtonView()
                            .offset(y: -self.keyboardHeight)
                            .opacity(1)
                            
                    }
                        //.keyboardAdaptive()
                        //.padding(.bottom, keyboard.currentHeight)
                    }
                
            }
            
            //.frame(width: geometry.size.width)
            .onTapGesture {
                self.viewModel.editing = false
                self.keyboardOpened = false
            }
//            .onReceive(Publishers.keyboardHeight) {
//                                self.keyboardHeight = $0
//                print(keyboardHeight)
//                            }
            .onAppear {
                // Forcing the rotation to portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                // And making sure it stays that way
                AppDelegate.orientationLock = .portrait
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { (noti) in
                    self.keyboardOpened = true
                    print(keyboardOpened)
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { (noti) in
                    self.keyboardOpened = false
                    print(keyboardOpened)
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) { (noti) in
                    let value = noti.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
                    keyboardHeight = value.height-30
                    
                }

                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                    self.keyboardHeight = 0
                }
                
            }
            .onDisappear {
                AppDelegate.orientationLock = .all // Unlocking the rotation when leaving the view
                }
            .background(Image("bg")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
            )
        }
    }
}

struct FaceIdAndForgotPasswordView: View {
    
    var body: some View {
        
        HStack(spacing: 15) {
            Image("face_id_login")
            
            Text("Log ind med Face ID")
                .foregroundColor(Color(.white))
                .font(.system(size: 16, weight: .medium, design: .default))
        }
        .onTapGesture {
            // TODO: log in with face id
        }
        
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
                    .animation(.spring())
                    .padding(.bottom, 50)
        }
    }
}

//struct TextFieldClearButton: ViewModifier {
//    @Binding var text: String
//
//    func body(content: Content) -> some View {
//        HStack {
//            content
//
//            if !text.isEmpty {
//                Button(
//                    action: { self.text = "" },
//                    label: {
//                        Image(systemName: "delete.left")
//                            .foregroundColor(Color(UIColor.opaqueSeparator))
//                    }
//                )
//            }
//        }
//    }
//}



struct BackgroundColor: View {
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color("strongPink"), Color("reddishPink")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                //.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
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
