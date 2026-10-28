//
//  TotalScoreTableViewCell.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 21/8/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit
import Cosmos

class TotalRatingTableViewCell: UITableViewCell {

    static let identifier = "TotalRatingCell"
    
    var note: Note! {
        didSet {
            let score = (note.rating.count == 0) ? 0 : note.rating.point/Double(note.rating.count)
            ratingStar.rating = score
            let formattedScore = Double(round(10*score)/10)
            scoreLabel.text = "\(formattedScore.removeZerosFromEnd())/5 (\(note.rating.count) รีวิว)"
            soldLabel.text = "ขายแล้ว \(note.soldCount ?? 0) ชุด"
        }
    }
    
    private var ratingStar: CosmosView = {
        let view = CosmosView()
        view.settings.filledImage = UIImage(named: "iconStar1Small")
        view.settings.emptyImage = UIImage(named: "iconStar3Small")
        view.settings.updateOnTouch = false
        view.settings.starSize = 16
        view.settings.starMargin = 4
        view.settings.totalStars = 5
        view.settings.fillMode = .half
        view.rating = 0
        return view
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .canceltext
        label.font = .kanitLight14
        return label
    }()
    
    private let soldLabel: UILabel = {
        let label = UILabel()
        label.textColor = .canceltext
        label.font = .kanitLight14
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(ratingStar)
        ratingStar.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(22)
            make.bottom.equalTo(contentView.snp.bottom).offset(-22)
            make.leading.equalTo(contentView.snp.leading).offset(16)
        }
        
        contentView.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(ratingStar.snp.centerY)
            make.leading.equalTo(ratingStar.snp.trailing).offset(12)
        }
        
        contentView.addSubview(soldLabel)
        soldLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(ratingStar.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
