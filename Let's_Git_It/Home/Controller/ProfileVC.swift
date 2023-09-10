//
//  ProfileVC.swift
//  Let's_Git_It
//
//  Created by 김정원 on 2023/09/10.
//

import UIKit

class ProfileVC: UIViewController {
    @IBAction func logOutBtn(_ sender: Any) {
        logout(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
