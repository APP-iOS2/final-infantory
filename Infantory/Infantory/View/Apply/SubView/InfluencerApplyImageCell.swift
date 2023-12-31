//
//  InfluencerApplyImageCell.swift
//  Infantory
//
//  Created by 윤경환 on 2023/09/26.
//

import SwiftUI

struct InfluencerApplyImageCell: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                Image("Influencer1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 130)
                    .cornerRadius(10)
                Image("Shose1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 130)
                    .cornerRadius(10)
                Image("Influencer1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 130)
                    .cornerRadius(10)
                Image("Shose1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 130)
                    .cornerRadius(10)
            }
        }
    }
}

struct InfluencerApplyImageCell_Previews: PreviewProvider {
    static var previews: some View {
        InfluencerApplyImageCell()
    }
}
