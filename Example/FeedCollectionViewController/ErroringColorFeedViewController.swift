//
//  ErroringColorFeedViewController.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 11/02/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import ImageFeedCollectionViewController

class ErroringColorFeedViewController: ColorFeedViewController {

    var errorMessage:String? = "Something went wrong"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ColorFeedViewController.LENGTH = -1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func getErrorMessage() -> String {
        if let message = errorMessage {
            return message
        }
        return super.getErrorMessage()
    }
    
    func refreshFeed() {
        refresh()
    }
}
