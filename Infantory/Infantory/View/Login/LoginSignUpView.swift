//
//  LoginSignUpView.swift
//  Infantory
//
//  Created by 안지영 on 2023/09/20.
//

import SwiftUI

struct LoginSignUpView: View {
    
    @State private var email: String = ""
    @State private var nickName: String = ""
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @State private var address: String = ""
    @State private var detailAddress: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("*이메일") // 소셜로그인하면서 받아올 예정
            TextField("", text: $email)
                .overlay(UnderLineOverlay())
                .padding(.bottom)
            
            Text("*닉네임")
            TextField("", text: $nickName)
                .overlay(UnderLineOverlay())
                .padding(.bottom)
            
            Text("이름")
            TextField("", text: $name)
                .overlay(UnderLineOverlay())
                .padding(.bottom)
            
            Text("휴대폰 번호")
            TextField("- 없이 입력", text: $phoneNumber)
                .overlay(UnderLineOverlay())
                .padding(.bottom)
            
            VStack(alignment: .leading) {
                Text("우편 번호") // 우편번호 검색 버튼 만들 예정
                TextField("우편 번호를 검색하세요", text: $address)
                    .overlay(UnderLineOverlay())
                    .padding(.bottom)
                
                Text("주소")
                TextField("우편 번호 검색 후, 자동입력 됩니다.", text: $address)
                    .overlay(UnderLineOverlay())
                    .padding(.bottom)
                
                Text("상세주소")
                TextField("건물, 아파트, 동/호수 입력", text: $detailAddress)
                    .overlay(UnderLineOverlay())
                    .padding(.bottom)
                
            }
            
            HStack {
                Spacer()
                Button {
                    //
                } label: {
                    Text("가입하기")
                        .frame(width: 330, height: 40, alignment: .center)
                        .foregroundColor(.white)
                        .background(.gray)
                        .cornerRadius(5)
                }
                Spacer()
            }

        }
        .padding()
        .navigationTitle("회원가입")
    }
}

struct UnderLineOverlay: View {
    
    var body: some View {
        VStack {
            Divider()
                .offset(x: 0, y: 15)
        }
    }
}

struct LoginSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginSignUpView()
        }
    }
}