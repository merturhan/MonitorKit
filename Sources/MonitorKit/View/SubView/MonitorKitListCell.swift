//
//  MonitorKitListCell.swift
//  MonitorKit
//
//  Created by Mert Urhan on 30.04.2025.
//

import UIKit

final class MonitorKitListCell: UITableViewCell {
    
    static let identifier = "MonitorKitListCell"
    
    // MARK: UI Properties
    
    private let horizontalStack = UIStackView()
    private let verticalStack = UIStackView()
    private let dateLabel = UILabel()
    private let methodLabel = UILabel()
    private let statusCodeLabel = UILabel()
    private let urlLabel = UILabel()
    
    // MARK: Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: Configure
    
    func configure(with record: MonitorKitRecord) {
        dateLabel.text = record.timestamp.toTimeString
        methodLabel.text = record.method.uppercased()
        statusCodeLabel.text = record.statusCode?.description ?? "-"
        urlLabel.text = record.url
    }
    
    // MARK: Helper Functions

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .gray
        
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .gray
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        methodLabel.font = UIFont.boldSystemFont(ofSize: 12)
        methodLabel.textColor = .white
        methodLabel.backgroundColor = .darkGray
        methodLabel.layer.cornerRadius = 4
        methodLabel.clipsToBounds = true
        methodLabel.textAlignment = .center
        methodLabel.translatesAutoresizingMaskIntoConstraints = false
        methodLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        statusCodeLabel.font = UIFont.systemFont(ofSize: 12)
        statusCodeLabel.textColor = .gray

        urlLabel.font = UIFont.systemFont(ofSize: 12)
        urlLabel.textColor = .white
        urlLabel.numberOfLines = 1
        urlLabel.lineBreakMode = .byTruncatingHead

        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 8
        horizontalStack.alignment = .center
        horizontalStack.distribution = .fill
        horizontalStack.backgroundColor = .clear
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.addArrangedSubview(dateLabel)
        horizontalStack.addArrangedSubview(methodLabel)
        horizontalStack.addArrangedSubview(statusCodeLabel)

        verticalStack.axis = .vertical
        verticalStack.spacing = 4
        verticalStack.alignment = .leading
        verticalStack.distribution = .fill
        verticalStack.backgroundColor = .clear
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.addArrangedSubview(horizontalStack)
        verticalStack.addArrangedSubview(urlLabel)

        contentView.addSubview(verticalStack)

        NSLayoutConstraint.activate([
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}
