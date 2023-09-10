//
//  SceneDelegate.swift
//  Let's_Git_It
//
//  Created by 김정원 on 2023/08/31.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var isLoggedIn: Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let homeStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let window = UIWindow(windowScene: windowScene)
        
        // 로그인 상태에 따라 루트 뷰 컨트롤러를 설정
        if isLoggedIn {
            window.rootViewController = homeStoryboard.instantiateViewController(identifier: "TabVC") // Main View Controller
        } else {
            window.rootViewController = loginStoryboard.instantiateViewController(identifier: "LoginVC") // Login View Controller
        }
        
        self.window = window
        window.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        if let url = URLContexts.first?.url, let loginVC = window?.rootViewController as? LoginVC {
            print("Received URL: \(URLContexts.first?.url)")
                loginVC.handleGitHubCallback(url: url)
            }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
       
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
       
    }


}

