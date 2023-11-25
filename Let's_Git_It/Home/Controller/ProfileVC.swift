//
//  ProfileVC.swift
//  Let's_Git_It
//
//  Created by 김정원 on 2023/09/10.
//

import UIKit
import Alamofire

class ProfileVC: UIViewController {
    @IBAction func logOutBtn(_ sender: Any) {
        logout(self)
    }
    @IBAction func profileBtn(_ sender: Any) {
        fetchUserProfile()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

}
struct MemberProfile: Decodable {
    var memberId: Int
    var githubId: String
    var nickname: String
    var profileImg: String
    var commitCount: Int
    var commitLimit: Int
}
func fetchUserProfile() {
    guard let memberId = KeychainManager.shared.getMemberID() else {
        print("Member ID not found")
        return
    }

    let url = "https://hanserver.site/v1/members/profile/\(memberId)"
    guard let accessToken = KeychainManager.shared.getAccessToken() else {
        print("Access token not found")
        return
    }
    let headers: HTTPHeaders = [
        "Authorization": "\(accessToken)"
    ]

    AF.request(url, method: .get, headers: headers).responseDecodable(of: MemberProfile.self) { response in
        switch response.result {
        case .success(let profile):
            print("Member Profile: \(profile)")
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    }
}
