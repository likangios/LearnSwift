//
//  AudioCollectionViewCell.swift
//  LearnSwift
//
//  Created by perfay on 2018/8/31.
//  Copyright © 2018年 luck. All rights reserved.
//

import UIKit

class AudioCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = UIViewContentMode.scaleAspectFill
        return iv
    }()
    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(title)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        title.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
