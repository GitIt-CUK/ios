//
//  RandomSelectionVC.swift
//  Let's_Git_It
//
//  Created by 김정원 on 2023/09/12.
//

import UIKit
import Lottie

class RandomSelectionVC: UIViewController {

    // type 확률적으로 계산
   
    @IBOutlet weak var animationView: LottieAnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.contentMode = .scaleAspectFit
                animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
                animationView.play()
        // Do any additional setup after loading the view.
    }
    

    

}
