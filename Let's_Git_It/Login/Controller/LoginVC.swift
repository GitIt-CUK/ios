//
//  LoginVC.swift
//  Let's_Git_It
//
//  Created by 김정원 on 2023/09/10.
// access token 유효기간 지나면 리프레쉬 보내기 -> access token 들어오면 userdefaults 에 다시 저장하기
// refresh token = 3일 => 없어지면 로그인 다시해야함
// 자동로그인 하는 방법을 생각해야함 -> rtk 가 지나도 자동로그인 되어야함
import UIKit
import Alamofire
import WebKit

class LoginVC: UIViewController,WKNavigationDelegate {
    var webView : WKWebView!
    
    let redirectURI = "gitit://callback"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setupWebView()
        
    }
    func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme == "gitit" {
            handleGitHubCallback(url: url)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    @IBAction func loginWithGitHub(_ sender: UIButton) {
        setupWebView()
        let authURL = "https://github.com/login/oauth/authorize?client_id=\(API.CLIENT_ID!)&redirect_uri=\(API.REDIRECT_URI!)&scope=user"
        if let url = URL(string: authURL) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func handleGitHubCallback(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
            return
        }
        // Authorization Code를 서버에 전송
        LoginService.shared.sendAuthorizationCodeToServer(code: code) { [weak self] success,response in
            if success,let response = response {
                print("Auth code :\(code)")
                // 성공 시 메인 화면으로 이동
                self?.showMainScreen()
            } else {
                // 실패 시 오류 처리
                // ...
            }
        }
    }
    
    func showMainScreen() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let mainTabBarController = storyboard.instantiateViewController(identifier: "TabVC") as? UITabBarController {
                self.view.window?.rootViewController = mainTabBarController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    
}

