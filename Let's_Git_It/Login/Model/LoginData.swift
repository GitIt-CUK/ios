//
//  LoginData.swift
//  Let's_Git_It
//
//  Created by 김정원 on 2023/09/10.
//
import Foundation
import Alamofire

func sendAuthorizationCodeToServer(code: String) {
    let serverURL = "https://localhost:8080/auth"  // 서버의 주소
    let parameters: [String: Any] = [
        "code": code
    ]
    
    AF.request(serverURL, method: .post, parameters: parameters).response { response in
        switch response.result {
        case .success:
            print("Success: \(String(describing: response.value))")
            // 여기에서 응답 데이터를 처리할 수 있습니다. 예를 들어 JSON 형태의 응답을 파싱하는 등의 작업을 할 수 있습니다.
            
        case .failure(let error):
            print("Error: \(error)")
        }
    }
}
