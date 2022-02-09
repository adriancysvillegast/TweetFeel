//
//  ViewController.swift
//  TweetFeel
//
//  Created by Adriancys Jesus Villegas Toro on 3/2/22.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var emotionLabel: UILabel!
    
    private let swifter = Swifter(consumerKey: "LTReJyreyyuz4SWjVABuA1WKI", consumerSecret: "ajf107xfd6869heCG8Ptn8iztfFHBWPIxLkFGvsmoEwI7MKZcz")
    private let maxTweet = 100
    private let tweetSentimentClassifier = TweetSentimentClassifier()
    private var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emotionLabel.text = "💭"
        //      Button
        buttonLabel.layer.cornerRadius = 12
        buttonLabel.layer.borderWidth = 2
        buttonLabel.layer.borderColor = UIColor.white.cgColor
        
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        fetchTweet()
    }
    
    
    
//    functions
    func fetchTweet(){
        //        array to save tweets
        var tweets = [TweetSentimentClassifierInput]()

        if let textValue = textField.text {
            //            count of prediction.label
            swifter.searchTweet(using: textValue, lang: "en", count: maxTweet, tweetMode: TweetMode.extended) { result, metadata in
                for i in 0..<self.maxTweet{
                    //                    print(result[tweet]["full_text"])
                    if let tweet = result[i]["full_text"].string{
                        //                        value auxiliar
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
                //make predition
                self.getPrediction(with: tweets)
            } failure: { error in
                print("Error retriving tweet\(error)")
            }
                updateUILabel()
        }
    }
    
    func getPrediction(with tweets: [TweetSentimentClassifierInput]){
        do{
            let predictions = try self.tweetSentimentClassifier.predictions(inputs: tweets)
            
            for prediction in predictions {
                
                if prediction.label == "Pos" {
                    count += 1
                }else if prediction.label == "Neg" {
                    count -= 1
                }
                
            }
            
        }catch{
            
            print("Error when process the prediction")
        }
    }
    
    func updateUILabel(){
        //                UILable
        if count >= 20 {
            self.emotionLabel.text = "😍"
        }else if count >= 10 {
            self.emotionLabel.text = "🥰"
        } else if count > 0 {
            self.emotionLabel.text = "🙂"
        } else if count == 0{
            self.emotionLabel.text = "😐"
        }else if count >= -10 {
            self.emotionLabel.text = "😕"
        }else if count >= -20{
            self.emotionLabel.text = "😡"
        }else{
            self.emotionLabel.text = "🤬"
        }
        
        textField.text = ""
    }
    
    
    
}

