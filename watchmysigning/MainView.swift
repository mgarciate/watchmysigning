//
//  MainView.swift
//  watchmysigning
//
//  Created by mgarciate on 23/4/22.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.selectedAddress)
                .padding()
            Text(viewModel.txHashSigned)
                .padding()
                .foregroundColor(.blue)
            Text(viewModel.errorMessage)
                .padding()
                .foregroundColor(.red)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
