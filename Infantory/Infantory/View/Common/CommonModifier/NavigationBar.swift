//
//  NavigationBar.swift
//  Infantory
//
//  Created by 김성훈 on 2023/09/22.
//

import SwiftUI

struct NavigationBar: ViewModifier {
    @Environment(\.dismiss) var dismiss
    let title: String
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    .foregroundColor(.infanMain)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
    }
}
