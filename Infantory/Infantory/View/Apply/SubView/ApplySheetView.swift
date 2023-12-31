//
//  ApplySheetView.swift
//  Infantory
//
//  Created by 안지영 on 2023/10/04.
//

import SwiftUI

struct ApplySheetView: View {
    @EnvironmentObject var loginStore: LoginStore
    @State private var tempCount: Int = 0
    @State private var applyTicketCount: String = "0"
    @State private var isShowingAlert: Bool = false
    
    @ObservedObject var applyProductStore: ApplyProductStore
    @Binding var isShowingApplySheet: Bool
    var product: ApplyProduct
    @Binding var toastMessage: String
    @Binding var isShowingToastMessage: Bool
    var body: some View {
        VStack {
            ApplyMyTicketView()
            
            HStack {
                
                Text("사용할 응모권 갯수")
                
                Spacer()
                
                Button {
                    if 0 >= Int(applyTicketCount) ?? 0 {
                        applyTicketCount = "0"
                    } else {
                        tempCount = (Int(applyTicketCount) ?? 0) - 1
                        applyTicketCount = String(tempCount)
                    }
                } label: {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.infanMain)
                }
                
                TextField("", text: $applyTicketCount)
                    .font(.infanTitle2)
                    .frame(width: 50)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .onChange(of: applyTicketCount) { newValue in
                        if let intValue = Int(newValue) {
                            if intValue > loginStore.totalApplyTicketCount {
                                applyTicketCount = String(loginStore.totalApplyTicketCount)
                            } else if intValue < 1 {
                                applyTicketCount = "0"
                            }
                        } else {
                            // 정수로 변환할 수 없는 경우 기본값 설정
                            applyTicketCount = ""
                        }
                    }
                
                Button {
                    if Int(applyTicketCount) ?? 0 >= loginStore.totalApplyTicketCount {
                        applyTicketCount = String(loginStore.totalApplyTicketCount)
                    } else {
                        tempCount = (Int(applyTicketCount) ?? 0) + 1
                        applyTicketCount = String(tempCount)
                    }
                } label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.infanMain)
                }
                
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1)
                    .fill(Color.infanDarkGray))
            .horizontalPadding()
            .frame(width: CGFloat.screenWidth, height: 80)
            
            HStack {
                Button {
                    isShowingApplySheet = false
                } label: {
                    Text("닫기")
                        .padding()
                        .font(.infanTitle2)
                        .foregroundColor(.white)
                }
                .frame(width: .screenWidth / 2 - 20)
                .background(Color.infanLightGray)
                .cornerRadius(10)
                
                Button {
                    if applyTicketCount == "0" {
                        toastMessage = "최소 1장 이상 응모해주세요."
                        isShowingToastMessage = true
                    } else {
                        isShowingAlert = true
                    }
                } label: {
                    Text("응모하기")
                        .padding()
                        .font(.infanTitle2)
                        .foregroundColor(.white)
                }
                .frame(width: .screenWidth / 2 - 20)
                .background(Color.infanMain)
                .cornerRadius(10)
            }
            .padding()
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("응모하기"),
                  message: Text("\(applyTicketCount)장 응모하시겠습니까?"),
                  primaryButton: .default(Text("취소")),
                  secondaryButton: .default(Text("응모하기")) {
                applyProductStore.addApplyTicketUserId(ticketCount: Int(applyTicketCount) ?? 0, product: product, userID: loginStore.currentUser.email, userUID: loginStore.userUid)
                toastMessage = "응모가 완료되었습니다"
                isShowingToastMessage = true
                isShowingApplySheet = false
            })
        }
    }
}

struct ApplySheetView_Previews: PreviewProvider {
    static var previews: some View {
        ApplySheetView(applyProductStore: ApplyProductStore(), isShowingApplySheet: .constant(true), product: ApplyProduct(productName: "", productImageURLStrings: [""], description: "", influencerID: "", influencerNickname: "볼빨간사춘기", startDate: Date(), endDate: Date(), registerDate: Date(), applyUserIDs: [""]), toastMessage: .constant(""), isShowingToastMessage: .constant(false))
            .environmentObject(LoginStore())
    }
}
