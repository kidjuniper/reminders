//
//  TableViewCell.swift
//  Напоминания
//
//  Created by Nikita Stepanov on 14.09.2022.
//

import UIKit


class TableViewCell: UITableViewCell {
    var name = UILabel()
    var date = Date()
    let reminds = Reminds()
    var dateLabel = UILabel()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "ID1")
        cellSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func cellSettings() {
        name.font = UIFont(name: "Arial", size: 35)
        dateLabel.font = UIFont(name: "Arial", size: 20)
        [name, dateLabel].forEach{
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
            NSLayoutConstraint.activate([name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2), name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20), name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                                        
                                         dateLabel.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 3),
                                         dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20), dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                                         
                                         contentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/12)
                                        ])
        }
    }
