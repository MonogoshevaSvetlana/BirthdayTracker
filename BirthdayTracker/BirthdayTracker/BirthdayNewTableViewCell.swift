//
//  BirthdayNewTableViewCell.swift
//  BirthdayTracker
//
//  Created by Света on 12.11.2021.
//

import UIKit

class BirthdayNewTableViewCell: UITableViewCell {

    let emojiLable = UILabel.init(frame: .zero)
    let firstNameLabel = UILabel.init(frame: .zero)
    let lastNameLabel = UILabel.init(frame: .zero)
    let birthdataLabel = UILabel.init(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(emojiLable)
        addSubview(firstNameLabel)
        addSubview(lastNameLabel)
        addSubview(birthdataLabel)
    }
    
    override func layoutSubviews() {
        let height = frame.height / 3 - 16
        let width = frame.width - emojiLable.frame.width - 20
        emojiLable.frame = CGRect(x: 10, y: 4, width: 50, height: 50)
        firstNameLabel.frame = CGRect(x: emojiLable.frame.maxX, y: 4, width: width, height: height)
        lastNameLabel.frame = CGRect(x: emojiLable.frame.maxX, y: firstNameLabel.frame.maxY + 4, width: width, height: height)
        birthdataLabel.frame = CGRect(x: emojiLable.frame.maxX, y: lastNameLabel.frame.maxY + 4, width: width, height: height)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
