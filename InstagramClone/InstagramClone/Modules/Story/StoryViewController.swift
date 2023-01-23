//
//  StoryViewController.swift
//  InstagramClone
//
//  Created by Gregory Molette on 20/01/2023.
//

import UIKit

final class StoryViewController: UIViewController {
    private weak var imageView: UIImageView!
    private weak var topHeaderView: HeaderView!
    private weak var leftTapView: UIView!
    private weak var rightTapView: UIView!
    private let author: Author
    private var currentStoryIndex = 0

    init(author: Author) {
        self.author = author
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupView() {
        let imageView = UIImageView()
        if let imageName = author.stories.first?.imageName {
            imageView.image = UIImage(named: imageName)
        }
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        self.imageView = imageView

        let leftTapView = UIView()
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(self.handleLeftTap(_:)))
        leftTapView.addGestureRecognizer(leftTap)
        leftTapView.isUserInteractionEnabled = true
        self.leftTapView = leftTapView

        let rightTapView = UIView()
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(self.handleRightTap(_:)))
        rightTapView.addGestureRecognizer(rightTap)
        rightTapView.isUserInteractionEnabled = true
        self.rightTapView = rightTapView
        
        let topHeaderView = HeaderView(author: author)
        topHeaderView.startTimer(at: 0)
        topHeaderView.delegate = self
        self.topHeaderView = topHeaderView

        [imageView, rightTapView, leftTapView, topHeaderView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            leftTapView.topAnchor.constraint(equalTo: view.topAnchor),
            leftTapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leftTapView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),
            leftTapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            rightTapView.topAnchor.constraint(equalTo: view.topAnchor),
            rightTapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            rightTapView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),
            rightTapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            topHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topHeaderView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    @objc func handleLeftTap(_ sender: UITapGestureRecognizer) {
        if currentStoryIndex == 0 {
            topHeaderView.stopCurrentProgress = true
            topHeaderView.startTimer(at: currentStoryIndex)
        } else {
            currentStoryIndex -= 1
            let imageName = author.stories[currentStoryIndex].imageName
            imageView.image = UIImage(named: imageName)
            topHeaderView.stopCurrentProgress = true
            topHeaderView.startTimer(at: currentStoryIndex)
        }
    }

    @objc func handleRightTap(_ sender: UITapGestureRecognizer) {
        currentStoryIndex += 1
        if currentStoryIndex < author.stories.count {
            let imageName = author.stories[currentStoryIndex].imageName
            imageView.image = UIImage(named: imageName)
            topHeaderView.stopCurrentProgress = true
            topHeaderView.startTimer(at: currentStoryIndex)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

extension StoryViewController: StoryViewControllerHeaderViewDelegate {
    func changeStory(_view: HeaderView, index: Int) {
        if index < author.stories.count {
            currentStoryIndex = index
            let imageName = author.stories[index].imageName
            imageView.image = UIImage(named: imageName)
        }
    }
    
    func storyDidEnd(_ view: HeaderView) {
        navigationController?.popViewController(animated: true)
    }
    
    func closeButtonDidTap(_ view: HeaderView) {
        navigationController?.popViewController(animated: true)
    }
}
