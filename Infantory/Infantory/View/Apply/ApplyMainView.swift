//
//  ApplyMainView.swift
//  Infantory
//
//  Created by 김성훈 on 2023/09/21.
//

import SwiftUI

struct ApplyMainView: View {
    
    @StateObject var applyViewModel: ApplyProductViewModel = ApplyProductViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    ApplyRegistrationView()
                } label: {
                    Text("임시")
                }
                Divider()
                ApplyProductListView(applyViewModel: applyViewModel)
                Divider()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: EmptyView()) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct ApplyMainView_Previews: PreviewProvider {
    static var previews: some View {
        ApplyMainView()
    }
}
