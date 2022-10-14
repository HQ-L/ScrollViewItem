//
//  ViewController.swift
//  ScrollViewTest
//
//  Created by hq on 2022/10/12.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private var menuView: MenuView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tapView1 = UITapGestureRecognizer(target: self, action: #selector(tapView1Action))
        let tapView2 = UITapGestureRecognizer(target: self, action: #selector(tapView2Action))
        let tapView3 = UITapGestureRecognizer(target: self, action: #selector(tapView3Action))

        let cardContents = [
            CardContent(title: "下载", handler: nil, image: UIImage(named: "rip")),
            CardContent(title: "分享", handler: nil, image: nil),
            CardContent(title: "删除", handler: nil, image: nil)
        ]
        view.backgroundColor = .orange

        menuView = MenuView(frame: view.bounds, image: UIImage(named: "rip") ?? UIImage())
        menuView.addStructs(cardContents)
        menuView.addStruct(CardContent(title: "123", handler: handlerFunction, image: nil))
        view.addSubview(menuView)
    }

    func handlerFunction() {
        print(123)
    }

    @objc func tapView1Action(_ tapGesture: UITapGestureRecognizer) {
        tapGestureAnimation(tapGesture)
        print(1)
    }

    @objc func tapView2Action(_ tapGesture: UITapGestureRecognizer) {
        tapGestureAnimation(tapGesture)
        print(2)
    }

    @objc func tapView3Action(_ tapGesture: UITapGestureRecognizer) {
        tapGestureAnimation(tapGesture)
        print(3)
    }

    func tapGestureAnimation(_ tapGesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.13, delay: 0, animations: {
            tapGesture.view?.alpha = 0.23
        }, completion: { _ in
            UIView.animate(withDuration: 0.06, delay: 0, animations: {
                tapGesture.view?.alpha = 1.0
            })
        })
    }


}

