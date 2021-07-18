//
//  ViewController.swift
//  Timer
//
//  Created by Assylzhan Nurlybekuly on 02.07.2021.
//

import UIKit
struct TimerModel {
    let id: String
    let name: String
    let createdTime: TimeInterval
    let duration: TimeInterval
}

class ViewController: UIViewController {
    public static let dataFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "MM-dd-yyyy HH-mm-ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
    private let topView : UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    private let secondView : UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    private let secondLabel : UILabel = {
        let label = UILabel()
        label.text = "Добавление таймеров"
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textAlignment = .left
        label.textColor = .gray
        return label
    }()
    private let secondLine : UIView = {
        let line = UIView()
        line.backgroundColor = .systemGray4
        return line
    }()
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Мульти таймер"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    private var data = [TimerModel]()
    private let tableView = UITableView()
    private var nameTextField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Название таймера"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    private var secondsTextField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Время в секундах"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить", for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.link, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Мульти таймер"
        view.backgroundColor = .systemBackground
        view.addSubview(topView)
        topView.addSubview(titleLabel)
        view.addSubview(secondView)
        secondView.addSubview(secondLabel)
        secondView.addSubview(secondLine)
        view.addSubview(nameTextField)
        view.addSubview(secondsTextField)
        view.addSubview(button)
        view.addSubview(tableView)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()
        
        
        tableView.backgroundColor = .secondarySystemBackground
        
    }
    func createTableHeader()->UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
//        headerView.backgroundColor = .red
        let label = UILabel()
        label.text = "Таймеры"
        label.textColor = .gray
        label.frame  = CGRect(x: 20, y: 10, width: self.view.width, height: 50)
        let line = UIView()
        line.backgroundColor = .systemGray4
        line.frame = CGRect(x: 0, y: headerView.bottom, width: headerView.width, height: 1)
        headerView.addSubview(line)
        headerView.addSubview(label)
        return headerView
    }
    @objc private func buttonTapped(){
        guard nameTextField.text != nil, secondsTextField.text != nil else {return}
        guard let duration = secondsTextField.text?.convertToTimeInterval() else { return  }
        let id = ViewController.dataFormatter.string(from: Date())
        let newModel = TimerModel(id: id, name: nameTextField.text ?? "NO NAME", createdTime: Date().timeIntervalSince1970, duration: duration)
        var pos = 0
        for model in data {
            if TimerTableViewCell.calculate(model: model) <= Double(duration) {
                break
            }
            pos += 1
        }
        print("new id: \(id)")
        tableView.beginUpdates()
        data.insert(newModel, at: pos)
        tableView.insertRows(at: [IndexPath(row: pos, section: 0)], with: .middle)
        tableView.endUpdates()
        nameTextField.text = nil
        secondsTextField.text = nil
     
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.register(TimerTableViewCell.self, forCellReuseIdentifier: TimerTableViewCell.identifier)
        let width = view.width
        let height = view.height
        
        topView.frame =  CGRect(x: 0, y: 0, width: width, height: height/7)
        titleLabel.frame =  CGRect(x: 0, y: topView.height/2, width: width, height: 52)
        
        secondView.frame =  CGRect(x: 0, y: topView.bottom+20, width: width, height: 52)
        secondLabel.frame =  CGRect(x: 20, y: 10 ,width: width-20, height: 42)
        secondLine.frame =  CGRect(x: 0, y:secondLabel.bottom, width: width, height: 1)
       
        nameTextField.frame = CGRect(x: 20, y: secondView.bottom+15, width: width-130, height: 42)
        secondsTextField.frame = CGRect(x: 20, y: nameTextField.bottom+10, width: width-130, height: 42)
        button.frame = CGRect(x: 10, y: secondsTextField.bottom + 20, width: width-30, height: 52)
        tableView.frame = CGRect(x: 0, y: button.bottom+50, width: width, height: height-secondsTextField.frame.origin.y-20)
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimerTableViewCell.identifier) as! TimerTableViewCell
        cell.configure(with: data[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension ViewController: TimerTableViewCellDelegate {
    func removeFinishedTimer(with index: String) {
        var pos = 0
        for model in data {
            if model.id == index {
                print("Found")
                tableView.beginUpdates()
                data.remove(at: pos)
                tableView.deleteRows(at: [IndexPath(row: pos, section: 0)], with: .fade)
                tableView.endUpdates()
                break
            }
            pos += 1
        }
        
    }
    
}

extension UIView{
    public var width: CGFloat{
        return self.frame.size.width
    }
    public var height: CGFloat{
        return self.frame.size.height
    }
    public var top: CGFloat{
        return self.frame.origin.y;
    }
    public var bottom: CGFloat{
        return self.frame.size.height + self.frame.origin.y;
    }
    public var left: CGFloat{
        return self.frame.origin.x;
    }
    public var right: CGFloat{
        return self.frame.origin.x + self.frame.size.width
    }
}
extension String {
    func convertToTimeInterval() -> TimeInterval {
           guard self != "" else {
               return 0
           }

           var interval:Double = 0

        interval += Double(self) ?? 0

           return interval
       }
}
