//
//  NewsCollectionViewCell.swift
//  TutbyFeedViewer
//
//  Created by Никита Плахин on 10/28/20.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
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
        descriptionLable.textAlignment = .center
        return descriptionLable
    }()
    private let activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .medium)
        activityView.color = .white
        activityView.hidesWhenStopped = true
        return activityView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        imageView.addSubview(activityView)
        activityView.startAnimating()
        
        contentStack.addArrangedSubview(imageView)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(descriptionLabel)
        contentView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            // image view
            NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 0.4, constant: 0),
            
            // content stack view
            NSLayoutConstraint(item: contentStack, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentStack, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentStack, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0),
            
        ])
        
        activityView.center = imageView.center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(image: UIImage) {
        imageView.image = image
        activityView.stopAnimating()
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
        titleLabel.sizeToFit()
    }
    
    func setDescription(description: String) {
        descriptionLabel.text = description
        descriptionLabel.sizeToFit()
    }
    
    func setActivityViewCenter(to center: CGPoint) {
        activityView.center = center
    }
    
    func setTransformToImage(transform: CGAffineTransform) {
        imageView.transform = transform
    }
}
