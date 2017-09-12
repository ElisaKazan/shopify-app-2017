//
//  ViewController.swift
//  shopify-application-winter2017
//
//  Created by Elisa Kazan on 2017-09-11.
//  Copyright © 2017 ElisaKazan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var batzTotalLabel: UILabel!
    @IBOutlet weak var bagsTotalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make labels round
        DispatchQueue.main.async {
            self.bagsTotalLabel.layer.cornerRadius = 10.0
            self.bagsTotalLabel.clipsToBounds = true
            self.batzTotalLabel.layer.cornerRadius = 10.0
            self.batzTotalLabel.clipsToBounds = true
        }
        
        // Where the data is stored
        let urlString = "https://shopicruit.myshopify.com/admin/orders.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        
        let url = URL(string: urlString)
        
        
        URLSession.shared.dataTask(with: url!) {
            (optionalData, response, error) in
            
            // Get Data
            guard let data = optionalData else {
                print(error!)
                return
            }
            
            // Parse JSON data
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                let orders = jsonData["orders"] as! [Any]
                
                // Running totals
                var totalBags = 0
                var napoleanTotal = 0.00
                
                // Loop over all orders
                for order in orders {
                    let currOrder = order as! [String:Any]
                    
                    // Check if customer exists? (if no, order inputted manually)
                    if let customer = currOrder["customer"] as! [String:Any]? {
                        // Customer exists, is it napolean batz?
                        let firstName = customer["first_name"] as! String
                        let lastName = customer["last_name"] as! String
                        
                        if firstName == "Napoleon" && lastName == "Batz" {
                            // Yes, Add price to total
                            let total = Double(currOrder["total_price"] as! String)!
                            napoleanTotal += total
                            // For testing
                            print("Added $ \(total) to napolean total")
                        }
                    }
                    
                    
                    // Check if awesome bag was sold?
                    if let lineItems = currOrder["line_items"] as! [Any]? {
                        // Line Items exist, is one an awesome bag?
                        for item in lineItems {
                            let currItem = item as! [String:Any]
                            let title = currItem["title"] as! String
                            
                            if title == "Awesome Bronze Bag" {
                                // Yes, check quantity and add to total
                                let quantity = currItem["quantity"] as! Int
                                totalBags += quantity
                                //For Testing
                                print("Added \(quantity) bag(s) to total")
                            }
                        }
                    }
                }
                
                // Info has been collected
                DispatchQueue.main.async {
                    
                    self.batzTotalLabel.text = "$\(NSString(format: "%.2f", napoleanTotal))"
                    self.bagsTotalLabel.text = String(totalBags)
                }
                
                
            } catch {
                print(error)
            }
            
            }.resume()
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

