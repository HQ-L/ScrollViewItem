//
//  StructView.swift
//  ScrollViewTest
//
//  Created by hq on 2022/10/12.
//

import UIKit

class StructView: UIView {

    private var structString: String
    private var label = UILabel()

    init(frame: CGRect, structString: String) {
        self.structString = structString
        super.init(frame: frame)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.5
        setupLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension StructView {
    func setupLabel() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        label.text = structString
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
    }
}
