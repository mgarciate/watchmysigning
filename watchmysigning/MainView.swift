//
//  MainView.swift
//  watchmysigning
//
//  Created by mgarciate on 23/4/22.
//

import SwiftUI
import Firebase

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                NavigationLink(destination: ListenTransactionView(type: .tx)) {
                    VStack {
                        Text("Payments")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.black)
                    .cornerRadius(4)
                }
                .frame(width: 150)
                Spacer()
                    .frame(height: 20.0)
                NavigationLink(destination: ListenTransactionView(type: .message)) {
                    VStack {
                        Text("Sign messages")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.black)
                    .cornerRadius(4)
                }
                Spacer()
                    .frame(height: 20.0)
                NavigationLink(destination: SignTransactionView(address: viewModel.selectedAddress)) {
                    VStack {
                        Text("Send")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.black)
                    .cornerRadius(4)
                }
                Spacer()
            }
        }
        .onAppear() {
            Auth.auth().signInAnonymously()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
