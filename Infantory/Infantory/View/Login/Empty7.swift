//
//  Empty7.swift
//  Infantory
//
//  Created by 김성훈 on 2023/09/20.
//

import Foundation
import SwiftUI


struct Empty7: View {
    
    @State private var isShowingLoginSheet: Bool = false
    var body: some View {
        VStack {
            Button(action: {
                isShowingLoginSheet = true
            }, label: {
                Text("로그인")
            })
        }
        .sheet(isPresented: $isShowingLoginSheet, content: {
            LoginSheetView()
        })
    }
}

struct Empty7_Previews: PreviewProvider {
    static var previews: some View {
        Empty7()
    }
}

