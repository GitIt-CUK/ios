//
//  AppDelegate.swift
//  Let's_Git_It
//
//  Created by 김정원 on 2023/08/31.
//

import UIKit
import Alamofire
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        checkLoginStatus()
        
        UserDefaults.standard.set("gadisom", forKey: "Nickname")
        
        // Override point for customization after application launch.
        return true
    }
    
    func checkLoginStatus() {
        if let refreshToken = KeychainManager.shared.getRefreshToken() {
            // Refresh Token이 존재하면 유효성 확인
            validateRefreshToken(refreshToken)
        } else {
            // Refresh Token이 없으면 로그인 화면으로
            showLoginScreen()
        }
    }
    func validateRefreshToken(_ refreshToken: String) {
        // Refresh Token 유효성 확인 로직 구현 (네트워크 요청 등)
        // 예시로 Alamofire를 사용한 네트워크 요청
        AF.request("\(API.BASE_URL)/api/validateToken", method: .post, parameters: ["refreshToken": refreshToken]).responseJSON { response in
            switch response.result {
            case .success:
                // 유효한 경우 메인 화면으로 이동
                self.showMainScreen()
            case .failure:
                // 만료되었거나 유효하지 않은 경우 로그인 화면으로
                //KeychainManager.shared.deleteRefreshToken()
                self.showLoginScreen()
            }
        }
    }
    // MARK: UISceneSession Lifecycle
    func showMainScreen() {
        // 메인 화면 표시 로직
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mainViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            window?.rootViewController = mainViewController
        }
        window?.makeKeyAndVisible()
    }
    
    func showLoginScreen() {
        // 로그인 화면 표시 로직
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
            window?.rootViewController = loginViewController
        }
        window?.makeKeyAndVisible()
    }
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

