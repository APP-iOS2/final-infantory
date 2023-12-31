//
//  ApplyLogoCell.swift
//  Infantory
//
//  Created by 윤경환 on 2023/09/26.
//

import SwiftUI

struct ApplyLogoCell: View {
    var body: some View {
        HStack {
            Text("Infantory")
                .font(.infanTitle)
                .foregroundColor(.infanDarkGray)
            Spacer()
            Button {
                // SearchView 검색창 (네비게이션으로 변경해야할 것 같습니다.)
            } label: {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.infanBlack)
            }
            Button {
                // alramView 알람창 (네비게이션으로 변경 해야할 것 같습니다.)
            } label: {
                Image(systemName: "bell.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.infanDarkGray)
            }
        }
        .padding([.horizontal, .bottom])
    }
}

struct ApplyLogoCell_Previews: PreviewProvider {
    static var previews: some View {
        ApplyLogoCell()
    }
}
