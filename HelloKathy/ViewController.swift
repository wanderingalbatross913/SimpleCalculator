//
//  ViewController.swift
//  HelloKathy
//
//  Created by Katthy on 11/8/16.
//  Copyright © 2016 WhistleStop. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.Clear.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var numOne: UITextField!
    @IBOutlet weak var numTwo: UITextField!
    @IBOutlet weak var sum: UITextField!
    @IBOutlet weak var Compute: UIButton!
    @IBOutlet weak var Clear: UIButton!
    @IBOutlet weak var logOut: UITextView!
    
    
    @IBAction func OnClick(_ sender: UIButton, forEvent event: UIEvent) {
        if(sender == self.Compute){
            let sum = NSString(string: self.numOne.text!).intValue + NSString(string: self.numTwo.text!).intValue
            self.sum.text = String(sum)
            self.Clear.isEnabled = true
        
            //log
        
            let num1 = (NSString(string: self.numOne.text!) as String) == "" ? "0" : (NSString(string: self.numOne.text!) as String)
            let num2 = (NSString(string: self.numTwo.text!) as String) == "" ? "0" : (NSString(string: self.numTwo.text!) as String)
            
            let line = num1 + "+" + num2 + "=" + String(sum)
            
            
            storeCompute(computeString: line, timeStamp: Date())
            
        
            let lineGet = getCompute()
            var timeStamp = ""
            if let temp = lineGet.value(forKey: "timeStamp")
            {
                timeStamp = String(describing: temp)
            }else{
                timeStamp = "empty!"

            }
            
            let computeString = lineGet.value(forKey: "computeString") != nil ? String(describing: lineGet.value(forKey: "computeString")!) : "empty"

            let text = "timeStamp: " + timeStamp + "  computeString: " + computeString
            
            self.logOut.text.append(text + "\n")
        }
        
    }
    
    @IBAction func cleanButtonClick(_ sender: UIButton, forEvent event: UIEvent) {
        if(sender == self.Clear){
            self.sum.text = "0"
            self.numOne.text = ""
            self.numTwo.text = ""
            if(self.sum.text == "0"){
                self.Clear.isEnabled = false           }        }
        
    }
    
   //core data
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    func storeCompute(computeString:String, timeStamp:Date){
        let context = getContext()
        // 定义一个entity，这个entity一定要在xcdatamodeld中做好定义
        let entity = NSEntityDescription.entity(forEntityName: "LogCompute", in: context)
        
        let compute = NSManagedObject(entity: entity!, insertInto: context)
        
        compute.setValue(computeString, forKey: "computeString")
        compute.setValue(timeStamp, forKey: "timeStamp")
        
        do {
            try context.save()
            print("saved")
        }catch{
            print(error)
        }
    }
    
    
    // 获取某一entity的所有数据
    func getCompute() -> NSManagedObject{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LogCompute")
        var line: NSManagedObject? = nil
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            print("numbers of \(searchResults.count)")
            
            for p in (searchResults as! [NSManagedObject]){
                print("computeString:  \(p.value(forKey: "computeString")!) timeStamp: \(p.value(forKey: "timeStamp")!)")
                line = p
            }
        } catch  {
            print(error)
        }
        return line!
    }
    
}

