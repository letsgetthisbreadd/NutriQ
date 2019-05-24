//
//  HomeViewController.swift
//  Nutriq
//
//  Created by Albert Gertskis on 4/24/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import AlamofireImage


class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
  
    // MARK: - Properties
    @IBOutlet weak var collectionView: UICollectionView!
    var meals = [[String:Any]]()
    var mealsData = [[String:Any]]()
    var targetCal = ""
    var diet = ""

    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAndLoadUserData()
    }
    
    func getAndLoadUserData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let userReference = Database.database().reference().child("users/\(userID)")
        
        userReference.observeSingleEvent(of: .value) { (snapshot) in
            print("Snapshot of the user's information:\n", snapshot.value!) // Returns snapshot of all user's information (everything under userID)
            let snapshotValue = snapshot.value! as? NSDictionary
            let username = snapshotValue?["username"] as! String
            
            // Health stats object
            let healthStatsSnapshotValue = snapshotValue?["health-stats"] as? NSDictionary
            let goalCalories = healthStatsSnapshotValue?["goal-calories"] as! Int
            let overallGoal = healthStatsSnapshotValue?["overall-goal"] as! String
            
            self.targetCal = "\(goalCalories)"
            
            if overallGoal == "Gain" { self.diet = "&diet=high+protein"}
            else if overallGoal == "Maintain" { self.diet = ""}
            else if overallGoal == "Lose" { self.diet = ""}
            
            self.mealidRequest()
        }
    }
    
    
    // MARK: - First API Request
    
    func mealidRequest() {
     
        let MY_API_KEY = "472b7cc975msh060aefd68adf082p1bb2bejsn5903ef69b2cd"
        let Host = "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        let headers: HTTPHeaders = [
            "X-RapidAPI-Host": Host,
            "X-RapidAPI-Key": MY_API_KEY,
            "Accept": "application/json"
        ]
        let request = Alamofire.request("https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/mealplans/generate?timeFrame=week&targetCalories=\(targetCal)\(diet)", headers: headers)
            .responseJSON { response in
            //debugPrint(response)
                if let result = response.result.value {
                    let JSON = result as! [String : Any]
                    self.meals = JSON["items"] as! [[String : Any]]
                    self.mealDataRequest()
                }
        }
        debugPrint(request)
    }
    
    // MARK: - Second API Request

    func mealDataRequest() {
        
        var ID_LIST = [String]()
        var ID_String = ""
        let MY_API_KEY = "472b7cc975msh060aefd68adf082p1bb2bejsn5903ef69b2cd"
        let Host = "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        let headers: HTTPHeaders = [
            "X-RapidAPI-Host": Host,
            "X-RapidAPI-Key": MY_API_KEY,
            "Accept": "application/json"
        ]
    
        do {
            for index in 0..<(meals.count) {
                let meal = meals[index]
                let mealValueJSONstring =  meal["value"] as! String
                let mealValueDictionary = try JSONSerialization.jsonObject(with: mealValueJSONstring.data(using: .utf8)!, options: []) as! [String:Any]
                let ID = mealValueDictionary["id"] as! Int
                
                ID_LIST.insert("\(ID)", at: index)
                ID_String = ID_LIST.joined(separator: "%2C")
                }
            print(ID_LIST)
            }
        catch {
            print(error)
        }
        
        let requestURL = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/informationBulk?includeNutrition=true&ids=\(ID_String)"
        let request = Alamofire.request(requestURL, headers: headers)
            .responseJSON { response in
                if let result = response.result.value {
                    self.mealsData = result as! [[String : Any]]
                    self.collectionView.reloadData()
                    print("-------Request Finished--------")
                }
        }
        debugPrint(request)
    }
    
        

    // MARK: Cell Functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FoodCell
        
        let mealHandler = meals[indexPath.row]
        let mealDataHandler = mealsData[indexPath.row]
        
        let day = mealHandler["day"] as! Int
        
        let fallbackURL = "https://spoonacular.com/recipeImages/640190-556x370.jpg"
        let baseURL = mealDataHandler["image"] as? String ?? fallbackURL
        let posterURL = URL(string: baseURL)!
        
        cell.mealImage.af_setImage(withURL: posterURL)
        cell.dayNum.text = "\(day)"
        cell.dayButton.layer.cornerRadius = 10
        
        
        do {
            let mealValueJSONstring =  mealHandler["value"] as! String
            let mealValueDictionary = try JSONSerialization.jsonObject(with: mealValueJSONstring.data(using: .utf8)!, options: []) as! [String:Any]
            let title = mealValueDictionary["title"] as! String
            
            cell.mealName.text = title
            // print("Printing meal: \(indexPath.row)")
            // print(mealValueDictionary["title"]!)
            // print(mealValueDictionary["id"]!, "\n")
        }
        catch {
                print(error)
            }
        
        
        
        // This creates the shadows and modifies the cards a little bit
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    
        // Modifies the colors of the DAY button based on Int: day
        if day == 2 {
            cell.dayButton.firstColor = .init(red: 255/255.0, green: 121/255.0, blue: 247/255.0, alpha: 1.0)
            cell.dayButton.secondColor = .init(red: 255/255.0, green: 61/255.0, blue: 221/255.0, alpha: 1.0)
        } else if day == 3 {
            cell.dayButton.firstColor = .init(red: 255/255.0, green: 92/255.0, blue: 74/255.0, alpha: 1.0)
            cell.dayButton.secondColor = .init(red: 255/255.0, green: 37/255.0, blue: 19/255.0, alpha: 1.0)
        } else if day == 4 {
            cell.dayButton.firstColor = .init(red: 29/255.0, green: 46/255.0, blue: 255/255.0, alpha: 1.0)
            cell.dayButton.secondColor = .init(red: 0/255.0, green: 19/255.0, blue: 193/255.0, alpha: 1.0)
        } else if day == 5 {
            cell.dayButton.firstColor = .init(red: 169/255.0, green: 255/255.0, blue: 103/255.0, alpha: 1.0)
            cell.dayButton.secondColor = .init(red: 124/255.0, green: 243/255.0, blue: 0/255.0, alpha: 1.0)
        } else if day == 6 {
            cell.dayButton.firstColor = .init(red: 13/255.0, green: 255/255.0, blue: 196/255.0, alpha: 1.0)
            cell.dayButton.secondColor = .init(red: 4/255.0, green: 206/255.0, blue: 176/255.0, alpha: 1.0)
        } else if day == 7 {
            cell.dayButton.firstColor = .init(red: 30/255.0, green: 193/255.0, blue: 80/255.0, alpha: 1.0)
            cell.dayButton.secondColor = .init(red: 0/255.0, green: 166/255.0, blue: 67/255.0, alpha: 1.0)
        } else if day == 1 {
            cell.dayButton.firstColor = .init(red: 95/255.0, green: 213/255.0, blue: 255/255.0, alpha: 1.0)
            cell.dayButton.secondColor = .init(red: 62/255.0, green: 166/255.0, blue: 231/255.0, alpha: 1.0)
        }
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Find the selected meal name
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        
        // Allows the variable needed to be the one for the correct number meal, based on the num of the selected cell
        let meal = meals[indexPath.row]
        let mealDataDictionary = mealsData[indexPath.row]
        
        // This do statement unpacks the JSON string "value" and retrives the desired key:value pair
        do {
            let mealValueJSONstring =  meal["value"] as! String
            let mealValueDictionary = try JSONSerialization.jsonObject(with: mealValueJSONstring.data(using: .utf8)!, options: []) as! [String:Any]
            
            // Finds the title of the selected meal and assigns it to mealTitle as a string
            let mealTitle = mealValueDictionary["title"] as! String
            
            // That mealTitle string is then passed to MealDetailsViewController via this segue
            let detailsViewController = segue.destination as! MealDetailViewController
            detailsViewController.mealTitle = mealTitle
            detailsViewController.mealData = mealDataDictionary
            print("Passing data to MealDetailsViewController...")
        
        }
        catch {
            print(error)
        }
    }
}


