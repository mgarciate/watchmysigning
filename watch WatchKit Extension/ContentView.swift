//
//  ContentView.swift
//  watch WatchKit Extension
//
//  Created by mgarciate on 23/4/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.txHashSigned)
            Text(viewModel.errorMessage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("Apple Watch Series 7 - 41mm")
    }
}
