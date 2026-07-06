//
//  ChoicesView.swift
//  ratchakan
//
//  Created by JJsobtid on 19/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

protocol ChoicesViewDelegate {
	func selectedChoice(indexPath: IndexPath)
}

class ChoicesView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

	var titleLabel: UILabel!
	var identifier: String!
	
	var questionType: QuestionType!
	var choicesData: Any?
	var answerData: Any?
	
	var delegate: ChoicesViewDelegate?
	
	var choicesCollectionView: UICollectionView!
	var choiceCells: [ChoiceCollectionCell]!
	
	init(_ frame: CGRect, type: QuestionType, data: Any?, answer: Any?) {
		super.init(frame: frame)
		
		questionType = type
		answerData = answer
		if answerData == nil {
			if questionType == .c4a1 || questionType == .c5a1 {
				answerData = Choice(choiceData: [:])
			} else if questionType == .c5a2 || questionType == .relative {
				answerData = []
			}
		}
		if data != nil {
			choicesData = data
			if questionType == .c4a1 || questionType == .c5a1 || questionType == .c5a2 {
				choiceCells = []
				let innerSpace = ((choicesData as! [Choice]).count > 5 ? SMALLINSET : MARGIN)
				let choicesLayout = CollectionLayout(withcol: CGFloat((choicesData as! [Choice]).count), height: CHOICE_HEIGHT, axis: .horizontal, innerLine: innerSpace, innerInteritem: innerSpace)
				choicesCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0), collectionViewLayout: choicesLayout)
				choicesCollectionView.setUp(self, bg: .white, inset: UIEdgeInsets(top: 0, left: innerSpace, bottom: 0, right: innerSpace))
				choicesCollectionView.canScroll(false)
				choicesCollectionView.register(ChoiceCollectionCell.self, forCellWithReuseIdentifier: ChoiceCollectionCell.cellIdentifier)
				addSubview(choicesCollectionView)
			} else if questionType == .relative {
				
			}
		}
		titleLabel = UILabel()
		titleLabel.setParameter(font: .kanitLight16, color: .Celllabel, alignment: .center)
		titleLabel.text = "ChoicesView"

		setLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setLayout() {
		if choicesCollectionView != nil {
			choicesCollectionView.snp.remakeConstraints({ (make) in
				make.edges.equalTo(snp.edges)
			})
		}
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return (choicesData as! [Choice]).count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChoiceCollectionCell.cellIdentifier, for: indexPath) as! ChoiceCollectionCell
		cell.identifier = (choicesData as! [Choice])[indexPath.item].id
		cell.data = (choicesData as! [Choice])[indexPath.item]
		cell.setTitle(cell.data.prefix!)
		if questionType == .c4a1 || questionType == .c5a1 {
			if cell.data == answerData as? Choice {
				cell.setSelected()
			}
		} else if questionType == .c5a2 {
			let answers: [Choice] = answerData as! [Choice]
			if answers.contains(cell.data) {
				cell.setSelected()
			}
		}
		if not(choiceCells.contains(cell)) {
			choiceCells.append(cell)
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as! ChoiceCollectionCell

		if questionType == .c4a1 || questionType == .c5a1 {
			for c in choiceCells {
				if c != cell {
					c.unSelected()
				} else {
					c.setSelected()
					answerData = c.data
				}
			}
		} else if questionType == .c5a2 {
			var answers: [Choice] = answerData as? [Choice] ?? []
			if not(answers.contains(cell.data)) {
				answers.append(cell.data)
				if answers.count > 2 {
					answers.remove(at: 0)
				}
				answerData = answers
			}
			for c in choiceCells {
				if not(answers.contains(c.data)) {
					c.unSelected()
				} else {
					c.setSelected()
				}
			}
		}
		
		cell.setSelected()
		delegate?.selectedChoice(indexPath: indexPath)
	}
}

class ChoiceCollectionCell: UICollectionViewCell {
	
	static let cellIdentifier = "ChoiceCollectionCell"
	
	var choiceView: UIView!
	var numLabel: UILabel!
	var identifier: String!
	var data: Choice!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		choiceView = UIView()
		choiceView.backgroundColor = .white
		choiceView.cornerView(radius: 15)
		choiceView.borderView(color: .guestcolor, width: 0.75)
		contentView.addSubview(choiceView)
		
		numLabel = UILabel()
		numLabel.setParameter(font: .thSarabun20, color: .guestcolor, alignment: .center)
		contentView.addSubview(numLabel)
		
		setLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setLayout() {
		choiceView.snp.remakeConstraints { (make) in
			make.size.equalTo(CGSize(width: 30, height: 30))
			make.center.equalTo(contentView.snp.center)
		}
		numLabel.snp.remakeConstraints { (make) in
			make.edges.equalTo(choiceView.snp.edges)
		}
	}
	
	func setTitle(_ index: String) {
		numLabel.text = index
	}
	
	func setSelected() {
		choiceView.backgroundColor = .brandcolor1
		choiceView.borderView(color: .brandcolor1, width: 0.75)
		numLabel.textColor = .white
	}
	func unSelected() {
		choiceView.backgroundColor = .white
		choiceView.borderView(color: .guestcolor, width: 0.75)
		numLabel.textColor = .guestcolor
	}
}
