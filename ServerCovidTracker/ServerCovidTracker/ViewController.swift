import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var positiveLabel: UILabel!
    @IBOutlet weak var negativeLabel: UILabel!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    private var startDatePicker: UIDatePicker?
    private var endDatePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startDatePicker = UIDatePicker()
        startDatePicker?.datePickerMode = .date
        startDatePicker?.addTarget(self, action: #selector(startDateChanged(datePicker:)), for: .valueChanged)
        
        endDatePicker = UIDatePicker()
        endDatePicker?.datePickerMode = .date
        endDatePicker?.addTarget(self, action: #selector(endDateChanged(datePicker:)), for: .valueChanged)
        
        startDateTextField.inputView = startDatePicker
        endDateTextField.inputView = endDatePicker
        
        stateTextField.placeholder = "Enter state (e.g., AZ)"
        stateTextField.autocapitalizationType = .allCharacters // Ensure all characters are capitalized
        
        fetchArizonaData()
    }
    
    @objc func startDateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        startDateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func endDateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        endDateTextField.text = dateFormatter.string(from: datePicker.date)
    }
  
    func fetchArizonaData() {
        APIClient.shared.fetchArizonaData { data in
            guard let data = data else { return }
            DispatchQueue.main.async {
                let positiveCases = data.map { $0.positive ?? 0 }.reduce(0, +)
                let negativeCases = data.map { $0.negative ?? 0 }.reduce(0, +)
                self.positiveLabel.text = "Positive cases (last 7 days): \(positiveCases)"
                self.negativeLabel.text = "Negative cases (last 7 days): \(negativeCases)"
            }
        }
    }
    
    @IBAction func fetchStateData(_ sender: UIButton) {
        guard let state = stateTextField.text, !state.isEmpty,
              let startDate = startDateTextField.text, !startDate.isEmpty,
              let endDate = endDateTextField.text, !endDate.isEmpty else {
            return
        }
        
        APIClient.shared.fetchStateData(state: state, startDate: startDate, endDate: endDate) { data in
            guard let data = data else { return }
            DispatchQueue.main.async {
                let positiveCases = data.map { $0.positive ?? 0 }.reduce(0, +)
                let negativeCases = data.map { $0.negative ?? 0 }.reduce(0, +)
                self.positiveLabel.text = "Positive cases: \(positiveCases)"
                self.negativeLabel.text = "Negative cases: \(negativeCases)"
            }
        }
    }
}
