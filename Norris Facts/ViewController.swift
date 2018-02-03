//
//  ViewController.swift
//  Norris Facts
//
//  Created by John Pospisil on 1/17/18.
//  Copyright © 2018 John Pospisil. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    @IBOutlet weak var factNumberLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    

    let URL = "https://api.icndb.com/jokes/random"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getNextFact(url: URL)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }

    
    
    //    //MARK: - Networking
    //    /***************************************************************/
    func getNextFact(url: String) {
       
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    //print("Sucess! Got the fact")
                    let valueJSON : JSON = JSON(response.result.value!)
                    
                    self.updateFactData(json: valueJSON)
                    
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.questionLabel.text = "Connection Issues"
                }
        }
        
      
        
    }
    
    //    //MARK: - JSON Parsing
    //    /***************************************************************/
    
    func updateFactData(json : JSON) {
        
        // Retrieve the joke text, if it exists.
        if let factResult = json["value"]["joke"].string {
            
            // Replace text when needed. The double quote char appears as "&quot;" in some instances of factResult.
            // I also corrected a typo in one fact, "don?t" -> "don't".
            var tempResult = factResult.replacingOccurrences(of: "&quot;", with: "\"")
            tempResult = tempResult.replacingOccurrences(of: "don?t", with: "don't")
            
            questionLabel.text = tempResult
            
        } else {
            questionLabel.text = "Joke Unavailable"
        }
        
        // Retrieve the joke number/ID if it is available.
        if let factID = json["value"]["id"].int {
            factNumberLabel.text = "Fact #\(factID)"
        } else {
            factNumberLabel.text = "Fact # Unknown"
        }
    }
    
    
    
    @IBAction func nextButton(_ sender: UIButton) {
        getNextFact(url: URL)
    }
    
    
    
}

