//
//  SceneDelegate.swift
//  Let's_Git_It
//
//  Created by 김정원 on 2023/08/31.
//

import UIKit
import Alamofire
struct AccessTokenResponse: Decodable {
    let accessToken: String
}
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        checkLoginStatus() // 로그인 상태를 확인하고 UI를 설정하는 메서드 호출
    }
    
    private func checkLoginStatus() {
        if let memberId = KeychainManager.shared.getMemberID(),
           let refreshToken = KeychainManager.shared.getRefreshToken() {
            refreshAccessToken(memberId: memberId, refreshToken: refreshToken)
        } else {
            showLoginScreen()
        }
    }
    func refreshAccessToken(memberId: Int, refreshToken: String) {
        let url = "https://hanserver.site/v1/members/\(memberId)/token/\(refreshToken)"
        
        AF.request(url, method: .post).responseJSON { [weak self] response in
            switch response.response?.statusCode {
            case 200:
                // 성공적으로 액세스 토큰을 받았을 경우
                if let jsonData = response.data, let accessToken = String(data: jsonData, encoding: .utf8) {
                    KeychainManager.shared.saveAccessToken(accessToken)
                    // 메인 화면으로 이동
                    DispatchQueue.main.async {
                        self?.showMainScreen()
                    }
                }
            case 605:
                // 리프레시 토큰이 유효하지 않을 경우, 로그인 화면으로 이동
                DispatchQueue.main.async {
                    self?.showLoginScreen()
                }
            default:
                // 다른 오류가 발생한 경우, 오류 메시지를 출력하거나 사용자에게 알림
                if let error = response.error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    // MARK: UISceneSession Lifecycle
    func showMainScreen() {
        // 메인 화면 (탭 바 컨트롤러)를 스토리보드에서 인스턴스화
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mainTabBarController = storyboard.instantiateViewController(identifier: "TabVC") as? UITabBarController {
            // UIWindow의 rootViewController로 설정
            window?.rootViewController = mainTabBarController
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
    
    
}

