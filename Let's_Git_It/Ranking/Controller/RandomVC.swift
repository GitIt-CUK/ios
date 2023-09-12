//
//  RandomVC.swift
//  Let's_Git_It
//
//  Created by 김정원 on 2023/09/12.
//

import UIKit
import Lottie

class RandomVC: UIViewController {

    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        uiView.alpha = 0.0
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 2.0
        animationView.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            [weak self] in self?.animationView.isHidden = true
            UIView.animate(withDuration: 1.5, animations: {
                           self?.uiView.alpha = 1.0
                       }) { (_) in
                           // 애니메이션이 완료된 후에 뷰를 숨김
                           self?.uiView.isHidden = false
                       }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
