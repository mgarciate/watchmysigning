//
//  MainView.swift
//  watch WatchKit Extension
//
//  Created by mgarciate on 23/4/22.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("My address")
                Text(viewModel.selectedAddress)
                NavigationLink("Sign") {
                    SignTransactionView(address: viewModel.selectedAddress)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewDevice("Apple Watch Series 7 - 41mm")
    }
}
