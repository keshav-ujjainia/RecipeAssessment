//
//  ViewController.swift
//  SeachRecipe
//
//  Created by keshav-ujjainia on 08/03/21.
//

import UIKit

class ViewController: UIViewController {
    
    var query = ""

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var recipeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    var baseurl = "https://api.spoonacular.com/recipes/complexSearch?apiKey=d44e2af41cd047c8bb41588f5a76026c"
    var url = "https://api.spoonacular.com/recipes/654959/information?apiKey=d44e2af41cd047c8bb41588f5a76026c&includeNutrition=false"
    let apikey = "d44e2af41cd047c8bb41588f5a76026c"
    
    func fetchInformation(query: String) {
        let urlString = "\(baseurl)&query=\(query)"
        performRequest(with: urlString)
    }
    
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }
                if let safeData = data {
                    self.parseJSON(safeData)
                    }
                }
            task.resume()
            }
            
        }
    
    
    
    func parseJSON(_ data: Data){
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(results.self, from: data)
            let id = decodedData.results[0].id
            print(id)
            getRecipe(id: id)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func parseJSONforRecipe(_ data: Data){
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(source.self, from: data)
            let instruction = decodedData.instructions
            DispatchQueue.main.async {
                
                self.recipeLabel.text = instruction.html2String
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func getRecipe(id: Int){
        let infourl = "https://api.spoonacular.com/recipes/\(id)/information?apiKey=d44e2af41cd047c8bb41588f5a76026c&includeNutrition=false"
        if let url = URL(string: infourl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }
                if let safeData = data {
                    self.parseJSONforRecipe(safeData)
                    }
                }
            task.resume()
            }
    }

    
    @IBAction func searchButton(_ sender: UIButton) {
        self.query = searchTextField.text!
        fetchInformation(query: searchTextField.text!)
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}
