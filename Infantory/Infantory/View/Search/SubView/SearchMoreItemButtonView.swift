//
//  SearchMoreItemButtonView.swift
//  Infantory
//
//  Created by 안지영 on 2023/10/13.
//

import SwiftUI

struct SearchMoreItemButtonView: View {
    
    @ObservedObject var searchStore: SearchStore
    var selectedCategory: SearchResultCategory
    @Binding var searchCategory: SearchResultCategory
    
    var body: some View {
        VStack {
            Button {
                searchStore.selectedCategory = selectedCategory
                searchCategory = selectedCategory
            } label: {
                HStack {
                    Text("\(selectedCategory.rawValue) 더보기")
                        .foregroundColor(.infanBlack)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.infanBlack)
                }
            }
            .foregroundColor(.black)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.infanLightGray.opacity(0.3))
                    .frame(width: CGFloat.screenWidth - 40, height: 54)
            )
        }
    }
}

struct SearchMoreItemButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SearchMoreItemButtonView(searchStore: SearchStore(), selectedCategory: SearchResultCategory.apply, searchCategory: .constant(.apply))
    }
}
