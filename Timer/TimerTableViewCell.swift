//
//  TimerTableViewCell.swift
//  Timer
//
//  Created by Assylzhan Nurlybekuly on 02.07.2021.
//

import UIKit
protocol TimerTableViewCellDelegate {
    func removeFinishedTimer(with index: String)
}
class TimerTableViewCell: UITableViewCell {
    var prev: String?
    var timer: Timer?
    var delegate: TimerTableViewCellDelegate?
    private let timerLabel : UILabel = {
        let label = UILabel()
        label.textColor = .gray
      
        label.textAlignment = .right
        return label
    }()
    private let timerName : UILabel = {
        let label = UILabel()
        return label
    }()
    static let identifier = "TimerTableViewCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        timerLabel.font = .systemFont(ofSize: timerName.font.pointSize, weight: .light)
        contentView.addSubview(timerLabel)
        contentView.addSubview(timerName)
        contentView.backgroundColor = .red
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        timerName.frame = CGRect(x: 20, y: 0, width: contentView.frame.size.width/3, height: contentView.frame.size.height-2)
        timerLabel.frame = CGRect(x: contentView.frame.size.width/3*2 , y: 0, width: contentView.frame.size.width/3-20, height: contentView.frame.size.height-2)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    static func calculate(model: TimerModel)->Double{
        return Double((model.createdTime + model.duration) - Date().timeIntervalSince1970)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.timer?.invalidate()
        self.timer = nil
        self.timerName.text = nil
        self.timerLabel.text = nil
    }
    public func configure(with model: TimerModel){
        
        if timer == nil {
            timerName.text = model.name
            timerLabel.text = "\(TimerTableViewCell.calculate(model: model).timeRemainingFormatted())" 
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self]timer in
                guard let strongSelf = self else {return}
                let newtime = TimerTableViewCell.calculate(model: model)
                if newtime>0 {
                    strongSelf.timerLabel.text = newtime.timeRemainingFormatted()
                }else{
                    // finished
                    strongSelf.delegate?.removeFinishedTimer(with: model.id)
                }
            })
        }
       
    }
}

extension Double {
    public func timeRemainingFormatted() -> String {
        let duration = TimeInterval(self)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]
        return formatter.string(from: duration) ?? ""
    }
}
