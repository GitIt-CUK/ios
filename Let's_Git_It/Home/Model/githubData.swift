import Alamofire
import SwiftyJSON

let token = "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" // 위에서 생성한 토큰 값
let headers: HTTPHeaders = [
    "Authorization": "Bearer \(token)"
]

let query = """
{
  user(login: "YOUR_USERNAME") {
    contributionsCollection {
      contributionCalendar {
        totalContributions
        weeks {
          contributionDays {
            date
            contributionCount
          }
        }
      }
    }
  }
}
"""

let parameters: [String: Any] = [
    "query": query
]

//AF.request("https://api.github.com/graphql", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//    switch response.result {
//    case .success(let value):
//        let json = JSON(value)
//        let weeks = json["data"]["user"]["contributionsCollection"]["contributionCalendar"]["weeks"].arrayValue
//        // weeks 및 days 데이터를 처리하여 캘린더 UI를 구성합니다.
//    case .failure(let error):
//        print(error.localizedDescription)
//    }
//}


func fetchGitHubcontributions(for username: String) {
    let url = "https://api.github.com/users/gadisom/events"

    AF.request(url).responseJSON { response in
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            for event in json.arrayValue {
                if event["type"].stringValue == "PushEvent" {
                    let commitCount = event["payload"]["commits"].arrayValue.count
                    let date = event["created_at"].stringValue
                    print("Date: \(date), Commits: \(commitCount)")
                }
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
