//
//  StoryViewController+HeaderView.swift
//  InstagramClone
//
//  Created by Gregory Molette on 20/01/2023.
//

import UIKit

internal protocol StoryViewControllerHeaderViewDelegate: AnyObject {
    func closeButtonDidTap(_ view: StoryViewController.HeaderView)
    func storyDidEnd(_ view: StoryViewController.HeaderView)
    func changeStory(_view: StoryViewController.HeaderView, index: Int)
}

extension StoryViewController {
    final class HeaderView: UIView {
        public weak var progressStackView: UIStackView!
        private weak var authorImageView: UIImageView!
        private weak var authorNameLabel: UILabel!
        private weak var closeButton: UIButton!
        internal weak var delegate: StoryViewControllerHeaderViewDelegate!

        private var author: Author!
        private var progressValue: Double!
        private var index: Int!
        private var progressViewArray = [UIProgressView]()
        var stopCurrentProgress = false

        init(author: Author) {
            self.author = author
            super.init(frame: CGRectZero)
            setupView()
            setupConstraints()
        }
        
        @available(*, unavailable)
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupView() {
            backgroundColor = .clear
            
            for _ in author.stories {
                let progressView = UIProgressView()
                progressView.setProgress(0.1, animated: true)
                progressView.trackTintColor = .lightGray
                progressView.tintColor = .white
                progressViewArray.append(progressView)
            }
            
            let progressStackView = UIStackView(arrangedSubviews: progressViewArray)
            progressStackView.alignment = .leading
            progressStackView.axis = .horizontal
            progressStackView.distribution = .fillProportionally
            progressStackView.spacing = 8
            self.progressStackView = progressStackView
            
            let authorImageView = UIImageView()
            authorImageView.clipsToBounds = true
            authorImageView.contentMode = .scaleAspectFill
            authorImageView.layer.cornerRadius = 16
            authorImageView.image = UIImage(named: author.photoName)
            self.authorImageView = authorImageView
            
            let authorNameLabel = UILabel()
            authorNameLabel.textColor = .white
            authorNameLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            authorNameLabel.text = author.name
            self.authorNameLabel = authorNameLabel
            
            let closeButton = UIButton(type: .system, primaryAction: UIAction(title: "", handler: { [weak self] _ in
                guard let self = self else { return }
                if let authorIndex = Author.authors.firstIndex(of: self.author) {
                    Author.authors[authorIndex].isSeen = true
                }
                self.progressValue = 0.0
                self.index += 1
                self.delegate?.closeButtonDidTap(self)
            }))
            closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            closeButton.tintColor = .white
            self.closeButton = closeButton
            
            [closeButton, progressStackView, authorImageView, authorNameLabel]
                .forEach {
                    $0.translatesAutoresizingMaskIntoConstraints = false
                    addSubview($0)
                }
        }
        
        private func setupConstraints() {
            NSLayoutConstraint.activate([
                progressStackView.heightAnchor.constraint(equalToConstant: 4),
                progressStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                progressStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                progressStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                
                authorImageView.heightAnchor.constraint(equalToConstant: 32),
                authorImageView.widthAnchor.constraint(equalToConstant: 32),
                authorImageView.topAnchor.constraint(equalTo: progressStackView.bottomAnchor, constant: 16),
                authorImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                
                authorNameLabel.centerYAnchor.constraint(equalTo: authorImageView.centerYAnchor),
                authorNameLabel.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: 8),
                
                closeButton.heightAnchor.constraint(equalToConstant: 18),
                closeButton.widthAnchor.constraint(equalToConstant: 18),
                closeButton.centerYAnchor.constraint(equalTo: authorImageView.centerYAnchor),
                closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            ])
        }

        func startTimer(at index: Int) {
            if let authorIndex = Author.authors.firstIndex(of: author) {
                Author.authors[authorIndex].isSeen = true
            }
            progressValue = 0.0
            self.index = index
            stopCurrentProgress = true
            progressViewArray.forEach {
                $0.setProgress(0.0, animated: false)
            }
            stopCurrentProgress = false
            updateProgress()
        }
        
        @objc
        private func updateProgress() {
            if stopCurrentProgress == true {
                return
            }

            if index < progressViewArray.count {
                progressValue = progressValue + 0.02
                progressViewArray[index].setProgress(Float(progressValue), animated: true)
                if progressValue <= 1.0 {
                    self.perform(#selector(updateProgress), with: nil, afterDelay: 0.2)
                } else {
                    progressValue = 0.0
                    index += 1
                    guard let delegate = delegate else { return }
                    delegate.changeStory(_view: self, index: index)
                }
            } else {
                if let delegate = delegate {
                    delegate.storyDidEnd(self)
                }
            }
        }
    }
}
