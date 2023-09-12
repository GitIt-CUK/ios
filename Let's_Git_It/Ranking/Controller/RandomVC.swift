//
//  RandomVC.swift
//  Let's_Git_It
//
//  Created by 김정원 on 2023/09/12.
//

import UIKit
import Lottie

class RandomVC: UIViewController {
    
    private var congratuationsView: LottieAnimationView?
    @IBOutlet weak var gradeLabel: UILabel!
    func matchColors() {
        let colorType = generateRandomItemRarilty()
        gradeView(colorType)
        if let colorsForType = itemsColors[colorType] {
            let imageViews = [color1, color2, color3, color4, color5]
            for (index, imageView) in imageViews.enumerated() {
                if index < colorsForType.count, let color = hexStringToUIColor(colorsForType[index]) {
                    imageView?.tintColor = color
                }
            }
        }
        
    }
    func gradeView (_ colorType : ItemType)
    {
        switch colorType {
        case .normal :
            gradeLabel.text = "Normal"
        case .special :
            gradeLabel.text = "Special"
        case .rare :
            gradeLabel.text = "Rare"
            congratuationsView = .init(name: "congratuations")
            conView()
        case .elite :
            gradeLabel.text = "Elite"
            congratuationsView = .init(name: "tear")
            conView()
        default:
            break
        }
        
    }
    func conView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            
            guard let congratuationsView = self.congratuationsView else { return }
            
            // animationView와 같은 프레임으로 설정
            congratuationsView.frame = self.uiView.frame
            
            // animationView의 속성과 동일하게 설정
            congratuationsView.contentMode = .scaleAspectFit
            congratuationsView.loopMode = .loop
            congratuationsView.animationSpeed = 1.0
            
            self.view.insertSubview(congratuationsView, aboveSubview: self.uiView)

            // 애니메이션 시작
            congratuationsView.play()
            
            // 필요하다면 애니메이션이 끝난 후 congratuationsView를 숨길 수 있습니다.
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        congratuationsView.isHidden = true
                    }
        }
    }
    @IBOutlet weak var color1: UIImageView!
    @IBOutlet weak var color2: UIImageView!
    @IBOutlet weak var color3: UIImageView!
    @IBOutlet weak var color4: UIImageView!
    @IBOutlet weak var color5: UIImageView!
    
    @IBAction func repeatBtn(_ sender: Any) {
        matchColors()
        reloadView()
        animationView.isHidden = false
    }
    func reloadView() {
        
        uiView.alpha = 0.0
        uiView.layer.cornerRadius = 20
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 2.0
        animationView.play()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            [weak self] in self?.animationView.isHidden = true
            UIView.animate(withDuration: 1.0, animations: {
                self?.uiView.alpha = 1.0
            }) { (_) in
                // 애니메이션이 완료된 후에 뷰를 숨김
                self?.uiView.isHidden = false
                //self?.conView()

            }
        }
    }
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBAction func backBtn(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        matchColors()
        reloadView()
        
    }
    

}
