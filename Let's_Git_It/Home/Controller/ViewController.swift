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

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var consecutiveCommitLabel: UILabel!
    @IBOutlet weak var weekCommitLabel: UILabel!
    @IBOutlet weak var todayCommitLabel: UILabel!
    let numberOfDaysInYear = 371
    let numberOfSections = 1
    let numberOfDaysInWeek = 7
    
    var todayCommits: Int = 0
    var lastWeekCommits: Int = 0
    var consecutiveDaysCommits: Int = 0

    @IBOutlet weak var collectionView: UICollectionView!
    var commitDataArray: [CommitData] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        scrapeGitHubContributions(for: UserDefaults.standard.string(forKey: "Nickname")!)
        
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CommitCell.self, forCellWithReuseIdentifier: "CommitCell")
    }
    
    func dataIndex(for indexPath: IndexPath) -> Int {
        return indexPath.item + (indexPath.section * numberOfDaysInWeek)
    }
    
    func scrapeGitHubContributions(for userName: String) {
        guard let url = URL(string: "https://github.com/users/\(userName)/contributions") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Network error")
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
                
                DispatchQueue.main.async { [self] in
                    self.commitDataArray = commitDataDict.map { CommitData(date: $0.key, commitCount: $0.value) }
                    self.commitDataArray.sort(by: { $0.date < $1.date })
                    
                    // 오늘의 커밋 횟수 계산
                    if let todayData = self.commitDataArray.last {
                        self.todayCommits = todayData.commitCount
                    }

                    // 최근 7일간의 커밋 횟수 계산
                    let lastWeekData = self.commitDataArray.suffix(7)
                    self.lastWeekCommits = lastWeekData.reduce(0) { $0 + $1.commitCount }

                    // 연속 커밋일 수 계산
                    var consecutiveCount = 0
                    for commitData in self.commitDataArray.reversed() {
                        if commitData.commitCount > 0 {
                            consecutiveCount += 1
                        } else {
                            break
                        }
                    }
                    self.consecutiveDaysCommits = consecutiveCount

                    let xOffset = self.collectionView.contentSize.width - self.collectionView.frame.size.width
                    if xOffset > 0 {
                        self.collectionView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
                    }
                    self.todayCommitLabel.text = "\(todayCommits)개"
                    self.weekCommitLabel.text = "\(lastWeekCommits)개"
                    self.consecutiveCommitLabel.text = "\(consecutiveDaysCommits)개"
                }

                
            } catch {
                print("Parsing error")
            }
        }
        
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDaysInYear
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.height / CGFloat(numberOfDaysInWeek + 1)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommitCell", for: indexPath) as! CommitCell
        
        let dataIndex = self.dataIndex(for: indexPath)
        if dataIndex < commitDataArray.count {
            cell.commitData = commitDataArray[dataIndex]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataIndex = self.dataIndex(for: indexPath)
        if dataIndex < commitDataArray.count {
            let selectedData = commitDataArray[dataIndex]
            print("Selected date: \(selectedData.date), Commit count: \(selectedData.commitCount)")
        } else {
            print("Selected index is out of bounds of commitDataArray")
        }
    }
}
