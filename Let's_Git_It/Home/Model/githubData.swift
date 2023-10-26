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

