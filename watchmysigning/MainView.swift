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
                Text(viewModel.selectedAddress)
                    .padding()
                Text(viewModel.txHashSigned)
                    .padding()
                    .foregroundColor(.blue)
                Text(viewModel.errorMessage)
                    .padding()
                    .foregroundColor(.red)
                NavigationLink("Sign") {
                    SignTransactionView(address: viewModel.selectedAddress)
                }
                NavigationLink("Start Listen Tx") {
                    ListenTransactionView(type: .tx)
                }
                NavigationLink("Start Listen Message") {
                    ListenTransactionView(type: .message)
                }
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
