//
//  LoginVC.swift
//  Let's_Git_It
//
//  Created by 김정원 on 2023/09/10.
//

import UIKit
import SafariServices

class LoginVC: UIViewController {
    
    let clientID = "9323cc3c58d996fc1332"
    let redirectURI = "myapp://callback"
    var safariViewController: SFSafariViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func loginWithGitHub(_ sender: UIButton) {
           // 1. GitHub OAuth 인증 페이지를 띄우기 위한 URL 생성
           let authURL = "https://github.com/login/oauth/authorize?client_id=\(clientID)&redirect_uri=\(redirectURI)&scope=user"
           
           // 2. SFSafariViewController를 사용하여 GitHub OAuth 페이지를 띄우기
           if let url = URL(string: authURL) {
            safariViewController = SFSafariViewController(url: url)
               present(safariViewController!, animated: true, completion: nil)
              // UIApplication.shared.open(url)
           }
       }
    func handleGitHubCallback(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
            return
        }
        
        safariViewController?.dismiss(animated: true, completion: {
            print("Received authorization code: \(code)")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            // TabBarController를 인스턴스화
            if let tabBarController = storyboard.instantiateViewController(identifier: "TabVC") as? UITabBarController {
                // 현재 윈도우의 루트 뷰 컨트롤러로 설정
                self.view.window?.rootViewController = tabBarController
                self.view.window?.makeKeyAndVisible()
            }

            sendAuthorizationCodeToServer(code: code)
        })
    }


    

}
