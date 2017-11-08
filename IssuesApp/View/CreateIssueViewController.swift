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
        textView.layer.borderColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.00).cgColor
        textView.layer.borderWidth = 1.0 / UIScreen.main.scale
        textView.layer.cornerRadius = 5
    }
    func uploadIssue() {
        let title = titleTextField.text ?? ""
        let body = textView.text ?? ""
        App.api.createIssue(owner: owner, repo: repo, title: title, body: body) { [weak self] (dataResponse: DataResponse<Model.Issue>) in
            guard let `self` = self else { return }
            switch dataResponse.result {
            case .success(let issue):
                print(issue)
                self.createdIssue = issue
                self.performSegue(withIdentifier: "UnwindToIssues", sender: self)
            case .failure:
                break
            }
        }
    }
}

extension CreateIssueViewController {
    @IBAction func doneButtonTapped(_ sender: Any) {
        uploadIssue()
    }
}
