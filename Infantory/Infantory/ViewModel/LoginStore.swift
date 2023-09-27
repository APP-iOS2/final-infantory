//
//  LoginStore.swift
//  Infantory
//
//  Created by 안지영 on 2023/09/22.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import KakaoSDKAuth
import KakaoSDKUser
import SwiftUI

enum LoginStatus {
    case signIn
    case signOut
}

final class LoginStore: ObservableObject {
    
    @AppStorage("userId") var userUid: String = ""
    
    @Published var isShowingSignUp = false
    @Published var isShowingMainView = false
    @Published var email: String = ""
    @Published var userName: String = ""
    @Published var password: String = ""
    @Published var loginType: LoginType = .kakao
    @Published var currentUser: User = User(id: "",
                                            isInfluencer: .influencer,
                                            profileImageURLString: "",
                                            name: "상필님",
                                            phoneNumber: "0101010",
                                            email: "fff@naver.com",
                                            loginType: .apple,
                                            address: Address(address: "",
                                                             zonecode: "",
                                                             addressDetail: ""),
                                            follower: nil,
                                            applyTicket: nil,
                                            influencerIntroduce: nil)
    
    // 카카오 로그인 메인 함수: 토큰값 있는지 확인
    func kakaoAuthSignIn(completion: @escaping (Bool) -> Void) {
        if AuthApi.hasToken() { // 발급된 토큰이 있는지
            UserApi.shared.accessTokenInfo { _, error in // 해당 토큰이 유효한지
                if error != nil { // 에러가 발생했으면 토큰이 유효하지 않다.
                    self.openKakaoService(completion: { result in
                        if result {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    })
                } else { // 유효한 토큰
                    self.loadingInfoDidKakaoAuth(completion: { result in
                        if result {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    })
                }
            }
        } else { // 만료된 토큰
            self.openKakaoService(completion: { result in
                if result {
                    completion(true)
                } else {
                    completion(false)
                }
            })
        }
    }
    
    // 카카오 서비스 이용가능한지 확인하는 함수: 카카오 앱이용가능? 가능하지 않다면 -> 웹으로
    func openKakaoService(completion: @escaping (Bool) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() { // 카카오톡 앱 이용 가능한지
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in // 카카오톡 앱으로 로그인
                if error != nil { // 로그인 실패 -> 종료
                    print("Kakao Sign In Error: 카카오앱 실행에 실패했습니다.")
                    return
                }
                
                _ = oauthToken // 로그인 성공
                self.loadingInfoDidKakaoAuth(completion: { result in
                    if result {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }) // 사용자 정보 불러와서 Firebase Auth 로그인하기
            }
        } else { // 카카오톡 앱 이용 불가능한 사람
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in // 카카오 웹으로 로그인
                if error != nil { // 로그인 실패 -> 종료
                    print("Kakao Sign In Error: 카카오 계정 로그인에 실패했습니다.")
                    return
                }
                _ = oauthToken // 로그인 성공
                self.loadingInfoDidKakaoAuth(completion: { result in
                    if result {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }) // 사용자 정보 불러와서 Firebase Auth 로그인하기
            }
        }
    }
    
    func loadingInfoDidKakaoAuth(completion: @escaping (Bool) -> Void) {  // 사용자 정보 불러오기
        UserApi.shared.me { kakaoUser, error in
            if error != nil {
                print("카카오톡 사용자 정보 불러오는데 실패했습니다.")
                return
            }
            guard let email = kakaoUser?.kakaoAccount?.email else { return }
            self.email = email
            guard let password = kakaoUser?.id else { return }
            self.password = String(password)
            guard let userName = kakaoUser?.kakaoAccount?.profile?.nickname else {
                self.emailAuthSignIn(email: email, password: String(password), completion: { result in
                    if result {
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
                return
            }
            self.userName = userName
            // 로그인이 되는지 안되는지 확인하는 함수 -> 에러? 로그인이안된다 -> 회원가입이 안되어있다 -> 회원가입뷰로
            // 로그인이 된다 -> 메인뷰로
            self.emailAuthSignIn(email: email, password: String(password), completion: { result in
                if result {
                    completion(true)
                } else {
                    completion(false)
                }
            })
        }
    }
    
    func emailAuthSignIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print("error: 로그인에 실패했습니다.")
                completion(false)
                return // 실패하면 회원가입 화면
            }
            
            if result != nil {
                print("로그인 성공! 사용자 이메일: \(String(describing: result?.user.email))")
                // 성공하면 메인화면
                self.userUid = result?.user.uid ?? "uid 없음"
                completion(true)
            }
        }
    }
    
    func emailAuthSignUp(email: String, password: String, completion: (() -> Void)?) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print("error: 이미 등록되어있는 사용자입니다.")
            }
            if result != nil {
                self.userUid = result?.user.uid ?? "uid 없음"
            }
            
            completion?()
        }
    }
    
    func kakaoLogout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            } else {
                self.userUid = ""
                self.currentUser = User(id: "", isInfluencer: UserType.influencer, name: "", phoneNumber: "", email: "", loginType: LoginType.apple, address: Address(address: "",
                                                                                                                                                                      zonecode: "",
                                                                                                                                                                      addressDetail: ""), applyTicket: [ApplyTicket(date: Date(), ticketGetAndUse: "", count: 0)])
            }
        }
    }
    
    func signUpToFireStore(name: String, nickName: String, phoneNumber: String, zipCode: String, streetAddress: String, detailAddress: String, completion: (() -> Void)?) {
        do {
            let signUpUser = SignUpUser(name: name, nickName: nickName, phoneNumber: phoneNumber, email: self.email, loginType: self.loginType.rawValue, address: Address(address: zipCode, zonecode: streetAddress, addressDetail: detailAddress))
            let applyTicket = ApplyTicket(date: Date(), ticketGetAndUse: "회원가입", count: 5)
            try Firestore.firestore().collection("Users").document(userUid).setData(from: signUpUser)
            try Firestore.firestore().collection("Users").document(userUid).collection("ApplyTickets").addDocument(from: applyTicket)
            
            completion?()
            
        } catch {
            print("debug : Failed to Create User")
        }
    }
    
    func signUpToFirebase(name: String, nickName: String, phoneNumber: String, zipCode: String, streetAddress: String, detailAddress: String, completion: @escaping (Bool) -> Void) {
        self.emailAuthSignUp(email: self.email, password: "\(self.password)") {
            self.signUpToFireStore(name: name, nickName: nickName, phoneNumber: phoneNumber, zipCode: zipCode, streetAddress: streetAddress, detailAddress: detailAddress) {
                self.emailAuthSignIn(email: self.email, password: "\(self.password)", completion: { result in
                    if result {
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
            }
        }
    }
    
    func duplicateNickName(nickName: String, completion: @escaping (Bool) -> Void) {
        
        let query = Firestore.firestore().collection("Users").whereField("nickName", isEqualTo: nickName)
        query.getDocuments { data, _ in
            if data!.documents.isEmpty {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func fetchUser(userUID: String) async throws {
        
        let userDocument = try await Firestore.firestore().collection("Users").document(userUID).getDocument()
        let user = try userDocument.data(as: User.self)
        try await fetchApplyTicket(getUser: user, userUID: userUID)
    }
    
    @MainActor
    func fetchApplyTicket(getUser: User, userUID: String) async throws {
        
        var user = getUser
        var ticketList: [ApplyTicket] = []
        
        let ticketDocument = try await Firestore.firestore()
            .collection("Users").document(userUID).collection("ApplyTicket").getDocuments()
        let documents = ticketDocument.documents
        for document in documents {
            let applyTicket = try document.data(as: ApplyTicket.self)
            ticketList.append(applyTicket)
        }
        user.applyTicket = ticketList
        self.currentUser = user
    }
}
