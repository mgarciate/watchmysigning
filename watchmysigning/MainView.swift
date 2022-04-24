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
                NavigationLink("Payments") {
                    ListenTransactionView(type: .tx)
                }
                Spacer()
                    .frame(height: 20.0)
                NavigationLink("Sign messages") {
                    ListenTransactionView(type: .message)
                }
                Spacer()
                    .frame(height: 20.0)
                NavigationLink("Sign") {
                    SignTransactionView(address: viewModel.selectedAddress)
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
