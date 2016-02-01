//
//  DetailViewController.swift
//  Flicks
//
//  Created by Jorge Cruz on 2/1/16.
//  Copyright © 2016 Jorge Cruz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterDetailView: UIImageView!
    
    @IBOutlet weak var titleDetailLabel: UILabel!
    @IBOutlet weak var overviewDetailLabel: UILabel!
    var movie : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = movie["title"] as? String
        let overview = movie["overview"]
        
        titleDetailLabel.text = title
        overviewDetailLabel.text = overview as? String
        let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie["poster_path"] as? String {
            
            let posterUrl = NSURL(string: posterBaseUrl + posterPath)
            posterDetailView.setImageWithURL(posterUrl!)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
