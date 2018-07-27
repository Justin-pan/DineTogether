
//  graphViewContoller.swift
//  ABCD
//
//  Created by admin on 7/23/18.
//  Copyright © 2018 Sarar Raad. All rights reserved.
//

import UIKit
import Charts
class graphViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let hours = ["12:00am","","","3:00am","","","6:00am","","","9:00am","","","12:00pm","","","3:00pm","","","6:00pm","","","9:00pm","",""]
        getGraph(){(result) in
            DispatchQueue.main.async {
                switch result{
                case .success(let freq):
                    self.setChart(dataPoints: hours,values: freq)
                case .failure(let error):
                    print(error)
            }
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            print(values[i])
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
            print(dataEntries[i].x)
        }
        print(dataEntries.count)
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Freq")
        chartDataSet.colors = [UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1),UIColor(red: 3/255, green: 203/255, blue: 252/255, alpha: 1)]
        let hour = Calendar.current.component(.hour, from: Date())
        chartDataSet.colors[hour]=UIColor(red: 3/255, green: 55/255, blue: 252/255, alpha: 1)
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.groupBars(fromX: 0.0, groupSpace: 0.1, barSpace: 0.1)
        barChartView.data = chartData
        
    }
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBAction func goBack(_ sender: Any){
        self.performSegue(withIdentifier: "Backtopost", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Backtopost"{
            _ = segue.destination as! FirstViewController
        }
    }
}
