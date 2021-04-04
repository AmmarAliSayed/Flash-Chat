//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//

import UIKit
import CLTypingLabel
class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        titleLabel.text = K.appName
       
    }
    
    //two steps to hide navigationBar from WelcomeViewController and
   // left it to other screens
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //1
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //2
        navigationController?.isNavigationBarHidden = false
    }
}


//Animation using Timer
//titleLabel.text = ""
//var charIndex = 0.0
//let titleText = "⚡️FlashChat"
//for letter in titleText {
//    Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
//        self.titleLabel.text?.append(letter)
//    }
//    charIndex += 1
//}
