//
//  MonitorKitDetailViewController.swift
//  MonitorKit
//
//  Created by Mert Urhan on 30.04.2025.
//

import UIKit

final class MonitorKitDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let record: MonitorKitRecord
    
    private let dateLabel = UILabel()
    private let methodLabel = UILabel()
    private let statusCodeLabel = UILabel()
    private let urlLabel = UILabel()
    
    private let requestTextView = UITextView()
    private let responseTextView = UITextView()
    
    // MARK: - Initializers
    
    init(record: MonitorKitRecord) {
        self.record = record
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureContent()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .black
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let infoStack = UIStackView(arrangedSubviews: [dateLabel, methodLabel, statusCodeLabel])
        infoStack.axis = .horizontal
        infoStack.spacing = 8
        
        styleLabel(dateLabel, font: .systemFont(ofSize: 12), color: .gray)
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        styleLabel(methodLabel, font: .boldSystemFont(ofSize: 12), color: .white)
        methodLabel.backgroundColor = .darkGray
        methodLabel.textAlignment = .center
        methodLabel.layer.cornerRadius = 4
        methodLabel.clipsToBounds = true
        methodLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        styleLabel(statusCodeLabel, font: .boldSystemFont(ofSize: 12), color: .white)
        
        styleLabel(urlLabel, font: .systemFont(ofSize: 14), color: .white)
        urlLabel.numberOfLines = 1
        urlLabel.lineBreakMode = .byTruncatingHead
        
        [requestTextView, responseTextView].forEach {
            $0.isEditable = false
            $0.isScrollEnabled = true
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .white
            $0.backgroundColor = .darkGray.withAlphaComponent(0.25)
        }

        // Section containers
        let requestSection = makeSection(title: "Request Body", textView: requestTextView)
        let responseSection = makeSection(title: "Response Body", textView: responseTextView)
        
        // Add all to main stack
        stackView.addArrangedSubview(infoStack)
        stackView.addArrangedSubview(urlLabel)
        stackView.addArrangedSubview(requestSection)
        stackView.addArrangedSubview(responseSection)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            requestSection.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.2),
            responseSection.heightAnchor.constraint(greaterThanOrEqualTo: stackView.heightAnchor, multiplier: 0.6)
        ])
    }
    
    // MARK: - Configuration
    
    private func configureContent() {
        dateLabel.text = record.timestamp.toTimeString
        methodLabel.text = record.method
        statusCodeLabel.text = record.statusCode?.description ?? "-"
        urlLabel.text = record.url
        
        requestTextView.text = JSSONBeautifier.beatuify(record.requestBody) ?? "(No Request Body)"
        responseTextView.text = JSSONBeautifier.beatuify(record.responseBody) ?? "(No Response Body)"
    }
    
    // MARK: - Helpers
    
    private func styleLabel(_ label: UILabel, font: UIFont, color: UIColor) {
        label.font = font
        label.textColor = color
    }
    
    private func makeSection(title: String, textView: UITextView) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.textColor = .lightGray
        
        let sectionStack = UIStackView(arrangedSubviews: [titleLabel, textView])
        sectionStack.axis = .vertical
        sectionStack.spacing = 4
        return sectionStack
    }
}
