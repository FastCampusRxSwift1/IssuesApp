//
//  CreateIssueViewController.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 11. 9..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit

class CreateIssueViewController: UIViewController {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var textView: UITextView!
    
    var createdIssue: Model.Issue?
    var owner: String = ""
    var repo: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
