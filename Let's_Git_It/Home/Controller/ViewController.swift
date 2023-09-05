//
//  ViewController.swift
//  Let's_Git_It
//
//  Created by 김정원 on 2023/08/31.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 102
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommitCell", for: indexPath) as! CommitCell
            let dataIndex = indexPath.section * 7 + indexPath.item
            if dataIndex < commitDataArray.count {
                cell.commitData = commitDataArray[dataIndex]
            }
            return cell
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var commitDataArray: [CommitData] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    // ... 기타 함수들 ...

    func fetchGitHubContributions(for username: String) {
        let url = "https://api.github.com/users/\(username)/events"
        let daysAgo102 = Calendar.current.date(byAdding: .day, value: -102, to: Date())!

        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                var commitDataDict: [Date: Int] = [:]  // 딕셔너리로 날짜와 커밋 수를 저장합니다.

                let json = JSON(value)
                for event in json.arrayValue {
                    if event["type"].stringValue == "PushEvent" {
                        if let date = DateFormatter.iso8601.date(from: event["created_at"].stringValue), date > daysAgo102 {
                            let commitCount = event["payload"]["commits"].arrayValue.count
                            commitDataDict[date] = commitCount  // 딕셔너리에 날짜와 커밋 수 저장
                        }
                    }
                }

                // 최근 102일 동안의 모든 날짜를 생성합니다.
                for day in 0...102 {
                    if let date = Calendar.current.date(byAdding: .day, value: -day, to: Date()), commitDataDict[date] == nil {
                        commitDataDict[date] = 0  // 누락된 날짜에 대해 커밋 수를 0으로 설정합니다.
                    }
                }

                self.commitDataArray = commitDataDict.sorted(by: { $0.key < $1.key }).map { CommitData(date: $0.key, commitCount: $0.value) } // 날짜 순으로 정렬하고 배열로 변환

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CollectionView 설정
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CommitCell.self, forCellWithReuseIdentifier: "CommitCell")
        
        // GitHub 데이터 가져오기
        fetchGitHubContributions(for: "gadisom")
        fetchGitHubcontributions(for: "d")
        // 기타 필요한 초기화 코드 (만약 있을 경우)
    }
}

extension DateFormatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
