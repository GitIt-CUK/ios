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

    private init() {}

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
}

func save(key: String, value: String) {
    let query = [
        kSecClass as String: kSecClassGenericPassword as String,
        kSecAttrAccount as String: key,
        kSecValueData as String: value.data(using: .utf8)!
    ] as [String: Any]

    SecItemDelete(query as CFDictionary)
    SecItemAdd(query as CFDictionary, nil)
}
func get(key: String) -> String? {
    let query = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecReturnData as String: kCFBooleanTrue!,
        kSecMatchLimit as String: kSecMatchLimitOne
    ] as [String: Any]

    var dataTypeRef: AnyObject?
    let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

    if status == noErr {
        if let retrievedData = dataTypeRef as? Data,
           let value = String(data: retrievedData, encoding: .utf8) {
            return value
        }
    }
    return nil
}

func logout(_ controller: UIViewController) {
    
    let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        // 현재 시간으로부터 과거 모든 시간을 설정합니다
        let date = Date(timeIntervalSince1970: 0)
        
        // 설정된 시간 이후로 저장된 모든 웹사이트 데이터를 삭제합니다
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: date, completionHandler: {
            // 캐시와 쿠키가 지워진 후의 처리를 여기서 합니다
            print("All cache and cookies are deleted.")
        })
//
    // 3. 로그인 화면으로 돌아가기
    controller.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
    
    if let navigationController = controller.view.window?.rootViewController as? UINavigationController {
        navigationController.popToRootViewController(animated: false)
    }
    
    let storyboard = UIStoryboard(name: "Login", bundle: nil)
    if let loginVC = storyboard.instantiateViewController(identifier: "LoginVC") as? LoginVC {
        controller.view.window?.rootViewController = loginVC
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
                // 서버에서 성공적인 응답을 받았을 경우
                print("성공: \(loginResponse)")
                completion(true, loginResponse)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(false, nil)
            }
        }
    }


}
