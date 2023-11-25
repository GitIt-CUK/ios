//
//  LoginData.swift
//  Let's_Git_It
//
//  Created by 김정원 on 2023/09/10.
//
import Foundation
import Alamofire
import UIKit
import KeychainAccess
import WebKit

struct API {
    static let BASE_URL = ProcessInfo.processInfo.environment["BASE_URL"]!
    static let CLIENT_ID = ProcessInfo.processInfo.environment["CLIENT_ID"]
    static let REDIRECT_URI = ProcessInfo.processInfo.environment["REDIRECT_URI"]
    
    
}
class KeychainManager {
    static let shared = KeychainManager()
    private let accessTokenKey = "AccessToken"
    private let refreshTokenKey = "RefreshToken"
    private let memberIdKey = "MemberId"
    private init() {}
    
    func saveMemberID(_ id: Int) {
        save(key: memberIdKey, value: String(id))
    }
    
    func getMemberID() -> Int? {
        if let idString = get(key: memberIdKey), let id = Int(idString) {
            return id
        }
        return nil
    }
    func saveAccessToken(_ token: String) {
        save(key: accessTokenKey, value: token)
    }
    
    func getAccessToken() -> String? {
        return get(key: accessTokenKey)
    }
    
    func saveRefreshToken(_ token: String) {
        save(key: refreshTokenKey, value: token)
    }
    
    func getRefreshToken() -> String? {
        return get(key: refreshTokenKey)
    }
    func addAccessTokenToHeader(_ request: inout URLRequest) {
        if let accessToken = getAccessToken() {
            request.setValue("\(accessToken)", forHTTPHeaderField: "Authorization")
        }
    }
    func deleteAccessToken() {
            delete(key: accessTokenKey)
        }

        func deleteRefreshToken() {
            delete(key: refreshTokenKey)
        }

        private func delete(key: String) {
            let query = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key
            ] as [String: Any]

            SecItemDelete(query as CFDictionary)
        }

    private func save(key: String, value: String) {
           let query = [
               kSecClass as String: kSecClassGenericPassword,
               kSecAttrAccount as String: key,
               kSecValueData as String: value.data(using: .utf8)!
           ] as [String: Any]

           SecItemDelete(query as CFDictionary)
           SecItemAdd(query as CFDictionary, nil)
       }
    private func get(key: String) -> String? {
            let query = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecReturnData as String: kCFBooleanTrue!,
                kSecMatchLimit as String: kSecMatchLimitOne
            ] as [String: Any]

            var dataTypeRef: AnyObject?
            let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

            if status == noErr, let retrievedData = dataTypeRef as? Data, let value = String(data: retrievedData, encoding: .utf8) {
                return value
            }
            return nil
        }

}


func logout(_ controller: UIViewController) {
    // 웹사이트 데이터 삭제
    let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
    let date = Date(timeIntervalSince1970: 0)
    WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: date, completionHandler: {
        print("All cache and cookies are deleted.")
    })

    // 키체인에서 토큰 삭제
    KeychainManager.shared.deleteAccessToken()
    KeychainManager.shared.deleteRefreshToken()

    // 로그인 화면으로 이동
    if let navigationController = controller.view.window?.rootViewController as? UINavigationController {
        navigationController.popToRootViewController(animated: false)
    } else {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(identifier: "LoginVC") as? LoginVC {
            controller.view.window?.rootViewController = loginVC
            controller.view.window?.makeKeyAndVisible()
        }
    }
}

struct LoginResponse: Decodable {
    var memberId: Int
    var refreshToken: String
    var accessToken: String
}

// 이제 이 구조체를 사용하여 서버의 응답을 파싱합니다.

class LoginService {
    static let shared = LoginService()
    
    private init() {}
    
    func sendAuthorizationCodeToServer(code: String, completion: @escaping (Bool, LoginResponse?) -> Void) {
        let url = "\(API.BASE_URL)/v1/members/login/oauth"
        let parameters: Parameters = ["code": code]
        
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: LoginResponse.self) { response in
            switch response.result {
            case .success(let loginResponse):
                // 키체인에 토큰 저장
                KeychainManager.shared.saveAccessToken(loginResponse.accessToken)
                KeychainManager.shared.saveRefreshToken(loginResponse.refreshToken)
                
                // 키체인에 MemberID 저장
                KeychainManager.shared.saveMemberID(loginResponse.memberId)
                
                print("성공: \(loginResponse)")
                completion(true, loginResponse)
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(false, nil)
            }
        }
    }
}
