//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var currencySymbolTracker = 0
    
    var updateTimer: Timer?

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    @IBOutlet weak var updatePriceButton: UIButton!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        updatePriceButton.isHidden = true
       
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        currencySymbolTracker = row
    
        updateTimer?.invalidate()
        
        let localURL = finalURL
        updateTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.getCurrentBitcoinPrice(url: localURL)
        }
        getCurrentBitcoinPrice(url: localURL)
        
        
        updatePriceButton.isHidden = false

    }
    

    
    
    
//    
//    //MARK: - Networking
//    /***************************************************************/
//    
    func getCurrentBitcoinPrice(url: String) {
        
        
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    let priceDataJSON : JSON = JSON(response.result.value!)

                    self.updateBtcPriceData(json: priceDataJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    
    
    
    
//    //MARK: - JSON Parsing
//    /***************************************************************/
//    
    func updateBtcPriceData(json : JSON) {
        
        if let btcPriceResult = json["last"].double {
            
            bitcoinPriceLabel.text = "\(currencySymbolArray[currencySymbolTracker]) \(btcPriceResult)"
            
            
        } else {
            bitcoinPriceLabel.text = "Prices Currently Unavailable"
        }
        
        
    }
    

    @IBAction func updateCurrentPrice(_ sender: UIButton) {
        
        getCurrentBitcoinPrice(url: finalURL)
        
    }
    


}

