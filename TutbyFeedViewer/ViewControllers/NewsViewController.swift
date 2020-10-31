//
//  ViewController.swift
//  TutbyFeedViewer
//
//  Created by Никита Плахин on 10/29/20.
//

import UIKit

class NewsViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
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
        contentStack.alignment = .center
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.spacing = 20
        contentStack.distribution = .fill
        return contentStack
    }()
    private let newsTextLabel: UILabel = {
        let descriptionLable = UILabel()
        descriptionLable.numberOfLines = .max
        descriptionLable.textColor = UIColor(named: "TBLightGray")
        descriptionLable.textAlignment = .natural
        return descriptionLable
    }()
    private let saveButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.contentMode = .scaleAspectFit
        return button
    }()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.contentMode = .scaleAspectFit
        return button
    }()
    private var buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.distribution = .equalSpacing
        return stackView
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var news: News? {
        didSet {
            if let imageLink = news?.imageLink {
                if let image = newsManager.getImage(for: imageLink) {
                    imageView.image = image
                } else {
                    networkService.requestImage(from: imageLink) { data, error in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        guard let imageData = data, let image = UIImage(data: imageData) else { return }
                        DispatchQueue.main.async {
                            self.imageView.image = image
                        }
                    }
                }
            }
            if let title = news?.title {
                titleLabel.text = title
            }
            if let text = news?.newsText {
                newsTextLabel.text = text
            }
            if let isSaved = news?.isSaved, isSaved {
                saveButton.setImage(UIImage(systemName: "bookmark.fill")?.withTintColor(.yellow, renderingMode: .alwaysOriginal), for: .normal)
            } else {
                saveButton.setImage(UIImage(systemName: "bookmark")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
            }
        }
    }
    
    private var newsManager = NewsManager.sharedManager
    private var networkService = NetworkService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()

    }
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "TBBackground")
        
        contentStack.addArrangedSubview(imageView)
        
        buttonStack.addArrangedSubview(saveButton)
        buttonStack.addArrangedSubview(shareButton)
        imageView.addSubview(buttonStack)
        buttonStack.bringSubviewToFront(imageView)
        
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(newsTextLabel)
        scrollView.addSubview(contentStack)
        view.addSubview(scrollView)
        
        activateConstraints()
        
        saveButton.addTarget(self, action: #selector(self.toggleSaving), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(self.share), for: .touchUpInside)
    }
    
    private func activateConstraints() {
        let buttonSide: CGFloat = 35

        NSLayoutConstraint.activate([
            // image view
            NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.4, constant: 0),
            
            // news text label
            NSLayoutConstraint(item: newsTextLabel, attribute: .width, relatedBy: .equal, toItem: contentStack, attribute: .width, multiplier: 0.96, constant: 0),
            
            // save button
            NSLayoutConstraint(item: saveButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: buttonSide),
            NSLayoutConstraint(item: saveButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: buttonSide),
            
            // share button
            NSLayoutConstraint(item: shareButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: buttonSide),
            NSLayoutConstraint(item: shareButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: buttonSide),
            
            // button stack
            NSLayoutConstraint(item: buttonStack, attribute: .trailing, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: buttonStack, attribute: .bottom, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: -10),
            
            // content stack view
            NSLayoutConstraint(item: contentStack, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentStack, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentStack, attribute: .trailing, relatedBy: .equal, toItem: scrollView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentStack, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentStack, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1, constant: 0),
            
            // scroll view
            NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
            
        ])
    }
    

    func setup(with news: News) {
        self.news = news
    }
    
    private func save(news: News) {
        print(#function)
        newsManager.addToSaved(news)
    }
    
    private func removeSaved(news: News) {
        print(#function)
        newsManager.removeFromSaved(news)
    }
    
    @objc func toggleSaving() {
        guard let news = news else { return }
        if let isSaved = news.isSaved, isSaved {
            removeSaved(news: news)
        } else {
            save(news: news)
        }
    }
    
    @objc private func share() {
        print(#function)
        let message = """
        asd
        """
        
        let shareVC = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        present(shareVC, animated: true, completion: nil)
    }
    

}
