//
//  LoginData.swift
//  Let's_Git_It
//
//  Created by 김정원 on 2023/09/10.
//
import Foundation
import Alamofire
import UIKit
import SafariServices
import KeychainAccess

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
    
    // 2. 앱에서의 세션 데이터 제거
    UserDefaults.standard.set(false, forKey: "isLoggedIn")
    UserDefaults.standard.synchronize()
    
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
