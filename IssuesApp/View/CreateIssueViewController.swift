//
//  CreateIssueViewController.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 11. 9..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit
import Alamofire

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

}

extension CreateIssueViewController {
    func setup() {

    }
    func uploadIssue() {

    }
}

extension CreateIssueViewController {
    @IBAction func doneButtonTapped(_ sender: Any) {
        uploadIssue()
    }
}
