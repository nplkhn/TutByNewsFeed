//
//  ViewController.swift
//  TutbyFeedViewer
//
//  Created by Никита Плахин on 10/29/20.
//

import UIKit

class NewsViewController: UIViewController {
    
    private let imageView: UIImageView = {
        private let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 20
            imageView.layer.masksToBounds = true
            return imageView
        }()
        private let titleLabel: UILabel = {
            let titleLable = UILabel()
            titleLable.numberOfLines = .max
            titleLable.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
            titleLable.textColor = .white
            titleLable.textAlignment = .center
            return titleLable
        }()
        private let contentStack: UIStackView = {
            let contentStack = UIStackView()
            contentStack.axis = .vertical
            contentStack.alignment = .fill
            contentStack.translatesAutoresizingMaskIntoConstraints = false
            contentStack.spacing = 20
            contentStack.distribution = .fill
            return contentStack
        }()
        private let descriptionLabel: UILabel = {
            let descriptionLable = UILabel()
            descriptionLable.numberOfLines = .max
            descriptionLable.textColor = UIColor(named: "TBLightGray")
            descriptionLable.textAlignment = .justified
            return descriptionLable
        }()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
