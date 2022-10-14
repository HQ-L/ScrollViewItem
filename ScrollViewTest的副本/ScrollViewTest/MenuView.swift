//
//  MenuView.swift
//  FinalDemo
//
//  Created by hq on 2022/9/13.
//

import UIKit

class MenuView: UIView {

    let imageView = UIImageView()
    let scrollView = UIScrollView()
    let background = UIView()
    private var allViews = [UIView]()
    private var cardContents = [CardContent]()
    private var scrollViewFrameParameter: CGFloat = 0.0 {
        didSet {
            // 不使用layoutIfNeeded会导致这里无法通过frame去计算scrollView的contentSize
            // 所以不使用layoutIfNeeded方法，解决方法是延迟设置contentSize
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.000001) { [self] in
                scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height / scrollViewFrameParameter * CGFloat(cardContents.count))
            }
        }
    }

    init(frame: CGRect, image: UIImage?) {
        super.init(frame: frame)
        setupBackground()
        setupImageView(image)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: External Interface
extension MenuView {

    /// 添加单个功能
    func addStruct(_ cardContent: CardContent) {
        self.cardContents.append(cardContent)
        completeAddStruct()
    }

    /// 添加多个功能
    func addStructs(_ cardContents: [CardContent]) {
        cardContents.forEach({ self.cardContents.append($0) })
        completeAddStruct()
    }

    /// 设置功能
    func setupStructs(_ cardContents: [CardContent]) {
        self.cardContents.removeAll()
        for index in 0..<cardContents.count {
            self.cardContents.append(cardContents[index])
        }
        completeAddStruct()
    }

    /// 设置手势
    func setupTapAction(index: Int, tapGesture: UITapGestureRecognizer) {
        // 越界检测
        if index > self.allViews.count-1 {
            fatalError("index out of range, maxnum is \(self.allViews.count-1)")
        } else {
            self.allViews[index].addGestureRecognizer(tapGesture)
        }
    }
}

// MARK: Private Method
private extension MenuView {

    func setupBackground() {
        // 用来响应点击背景返回的手势
        background.frame = self.bounds
        background.alpha = 0.1
        addSubview(background)
    }

    func setupImageView(_ image: UIImage?) {
        addSubview(imageView)

        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .black
        imageView.image = image

        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true

        imageView.snp.makeConstraints { make in
            make.height.equalTo(self.snp.width).offset(-10).multipliedBy(9.0 / 16)
            make.centerY.equalToSuperview().offset(-100)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
        }
    }

    func setupScrollView() {
        addSubview(scrollView)

        scrollView.layer.cornerRadius = 10
        scrollView.layer.masksToBounds = true
        scrollView.layer.borderWidth = 1.0
        scrollView.layer.borderColor = UIColor.gray.cgColor

        scrollView.bounces = true
        scrollView.alpha = 0.8
        scrollView.backgroundColor = .white


        var height: CGFloat = 50
        if cardContents.count < 3 {
            height *= CGFloat(cardContents.count)
        } else {
            height *= 3
        }

        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(height)
        }
    }

    func setupCardView() {
        if cardContents.count < 3 {
            scrollViewFrameParameter = CGFloat(cardContents.count)
        } else {
            scrollViewFrameParameter = 3
        }

        for index in 0..<cardContents.count {
            let cardView = UIView()
            cardView.addGestureRecognizer(defaultTapGesture())
            scrollView.addSubview(cardView)

            cardView.layer.borderColor = UIColor.gray.cgColor
            cardView.layer.borderWidth = 0.5

            if index == 0 {
                cardView.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                    make.height.equalToSuperview().dividedBy(scrollViewFrameParameter)
                    make.centerX.equalToSuperview()
                    make.top.equalToSuperview()
                }
            } else {
                cardView.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                    make.height.equalToSuperview().dividedBy(scrollViewFrameParameter)
                    make.centerX.equalToSuperview()
                    make.top.equalTo(allViews[index-1].snp.bottom)
                }
            }

            allViews.append(cardView)
            setupCardView(cardView, cardContents[index])
        }
    }

    func setupCardView(_ cardView: UIView, _ cardContent: CardContent) {
        let imageView = UIImageView(image: cardContent.image)
        cardView.addSubview(imageView)

        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.width.equalTo(cardView.snp.height).offset(-5)
            make.height.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }


        let label = UILabel()
        cardView.addSubview(label)

        label.font = .systemFont(ofSize: 16)
        label.text = cardContent.title
        label.textAlignment = .left
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(imageView.snp.left)
        }
    }

    func completeAddStruct() {
        self.allViews.removeAll()
        self.scrollView.subviews.forEach({ $0.removeFromSuperview() })

        setupScrollView()
        setupCardView()
    }

    func defaultTapGesture() -> UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(defaultTapAction))

        return tapGesture
    }

    @objc func defaultTapAction(_ tapGesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.13, delay: 0, animations: {
            tapGesture.view?.alpha = 0.23
        }, completion: { _ in
            UIView.animate(withDuration: 0.06, delay: 0, animations: {
                tapGesture.view?.alpha = 1.0
            })
        })

        print("--已调用默认单击手势响应--")
    }
}
