//
//  DetailViewController.swift
//  Flicks
//
//  Created by Jorge Cruz on 2/1/16.
//  Copyright © 2016 Jorge Cruz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var posterDetailView: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var titleDetailLabel: UILabel!
    @IBOutlet weak var overviewDetailLabel: UILabel!
    var movie : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailScrollView.contentSize = CGSize(width: detailScrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as? String
        
        titleDetailLabel.text = title
        let overview = movie["overview"]
        
        overviewDetailLabel.text = overview as? String
        //overviewDetailLabel.sizeToFit()
        overviewDetailLabel.textAlignment = .Left
        
        
         let releaseDate = movie["release_date"] as? String
            releaseDateLabel.text = "Release Date: " + releaseDate! as String
            
        
        
        
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
