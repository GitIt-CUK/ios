//
//  ViewController.swift
//  Let's_Git_It
//
//  Created by 김정원 on 2023/08/31.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSoup

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    let totalWeeks = 16
    let daysInWeek = 7
    let currentWeekday = Calendar.current.component(.weekday, from: Date()) // 1: 일요일, 2: 월요일, ..., 7: 토요일
    @IBOutlet weak var collectionView: UICollectionView!
    var dates : [Date] = []
    var commitDataArray: [CommitData] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CommitCell.self, forCellWithReuseIdentifier: "CommitCell")
        
        scrapeGitHubContributions()
    }
    
    func scrapeGitHubContributions() {
            guard let url = URL(string: "https://github.com/users/gadisom/contributions") else {
                print("Invalid URL")
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Network error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    let html = String(decoding: data, as: UTF8.self)
                    let document = try SwiftSoup.parse(html)
                    let elements = try document.select("td")
                    
                    var commitDataDict: [Date: Int] = [:]
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
                    
                    for element in elements.array() {
                        if let dateString = try? element.attr("data-date"),
                           let levelString = try? element.attr("data-level"),
                           let date = dateFormatter.date(from: dateString),
                           let level = Int(levelString) {
                            commitDataDict[date] = level
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.commitDataArray = commitDataDict.map { CommitData(date: $0.key, commitCount: $0.value) }
                        self.commitDataArray.sort(by: { $0.date < $1.date })
                        let xOffset = self.collectionView.contentSize.width - self.collectionView.frame.size.width
                            if xOffset > 0 {
                                self.collectionView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
                            }
                    }
                    
                } catch {
                    print("Parsing error: \(error.localizedDescription)")
                }
            }
            
            task.resume()
        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1 // 세로 방향의 간격을 2로 조정
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1 // 수평 방향의 간격을 2로 유지
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 367 // 올림을 사용해 주의 개수를 계산
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.height / 8 // 7일에 맞추어 너비를 나눕니다.
            return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommitCell", for: indexPath) as! CommitCell
        
        let dataIndex = indexPath.item + (indexPath.section * daysInWeek) // 수정된 부분
        if dataIndex < commitDataArray.count {
            cell.commitData = commitDataArray[dataIndex]
        }
        
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataIndex = indexPath.item + (indexPath.section * daysInWeek)
        if dataIndex < commitDataArray.count {
            let selectedData = commitDataArray[dataIndex]
            print("Selected date: \(selectedData.date), Commit count: \(selectedData.commitCount)")
        } else {
            print("Selected index is out of bounds of commitDataArray")
        }
    }


   
}
