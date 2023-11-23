//
//  LoginVC.swift
//  Let's_Git_It
//
//  Created by 김정원 on 2023/09/10.
// access token 유효기간 지나면 리프레쉬 보내기 -> access token 들어오면 userdefaults 에 다시 저장하기
// refresh token = 3일 => 없어지면 로그인 다시해야함
// 자동로그인 하는 방법을 생각해야함 -> rtk 가 지나도 자동로그인 되어야함
import UIKit
import SafariServices
import Alamofire
struct API {
    static let BASE_URL = ProcessInfo.processInfo.environment["BASE_URL"]!
    static let CLIENT_ID = ProcessInfo.processInfo.environment["CLIENT_ID"]
    static let CLIENT_SECRET = ProcessInfo.processInfo.environment["CLIENT_SECRET"]
}


class LoginVC: UIViewController {
    
    let redirectURI = "gitit://callback"
    var safariViewController: SFSafariViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func loginWithGitHub(_ sender: UIButton) {
        // 1. GitHub OAuth 인증 페이지를 띄우기 위한 URL 생성
        let authURL = "https://github.com/login/oauth/authorize?client_id=\(API.CLIENT_ID!)&redirect_uri=\(redirectURI)&scope=user"
        
        // 2. SFSafariViewController를 사용하여 GitHub OAuth 페이지를 띄우기
        if let url = URL(string: authURL) {
            safariViewController = SFSafariViewController(url: url)
            present(safariViewController!, animated: true, completion: nil)
        }
    }
    func handleGitHubCallback(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
            return
        }
        safariViewController?.dismiss(animated: true, completion: {
            self.sendAuthorizationCodeToServer(code: code)
            print("Received authorization code: \(code)")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            // TabBarController를 인스턴스화
            if let tabBarController = storyboard.instantiateViewController(identifier: "TabVC") as? UITabBarController {
                // 현재 윈도우의 루트 뷰 컨트롤러로 설정
                self.view.window?.rootViewController = tabBarController
                self.view.window?.makeKeyAndVisible()
            }
            
        })
    }
    func sendAuthorizationCodeToServer(code: String) {
        let parameters: Parameters = [
            "client_id": API.CLIENT_ID!,
            "client_secret": API.CLIENT_SECRET!,
            "code": code,
            "redirect_uri": redirectURI
        ]
        
        AF.request("https://github.com/login/oauth/access_token", method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseString { response in
            switch response.result {
            case .success(let value):
                if let accessToken = self.extractToken(from: value),
                   let refreshToken = self.extractToken(from: value) {
                    KeychainManager.shared.saveAccessToken(accessToken)
                    KeychainManager.shared.saveRefreshToken(refreshToken)
                    // 성공적으로 토큰 저장 후 메인 화면 표시
                    self.showMainScreen()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                // 에러 처리
            }
        }
    }
    private func extractToken(from responseString: String) -> String? {
        let components = responseString.split(separator: "&")
            .map { $0.split(separator: "=") }
            .filter { $0.count == 2 }
            .reduce(into: [String: String]()) { dict, pair in
                let key = String(pair[0])
                let value = String(pair[1])
                dict[key] = value
            }
        
        return components["access_token"]
    }
    
    
}

extension LoginVC {
    func showMainScreen() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let mainTabBarController = storyboard.instantiateViewController(identifier: "TabVC") as? UITabBarController {
            // 현재 윈도우의 루트 뷰 컨트롤러로 메인 탭 바 컨트롤러 설정
            view.window?.rootViewController = mainTabBarController
            view.window?.makeKeyAndVisible()
        }
    }
}
