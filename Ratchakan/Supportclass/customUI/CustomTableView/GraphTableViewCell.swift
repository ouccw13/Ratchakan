//
//  GraphTableViewCell.swift
//  ratchakan
//
//  Created by JJsobtid on 20/3/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import DGCharts

class GraphTableViewCell: UITableViewCell, ChartViewDelegate {
    
	static let cellIdentifier = "GraphTableViewCell"
	
	var viewBG: UIView!
    
    var chart: LineChartView!
    var dataEntries: [ChartDataEntry] = []
    var labels:[String] = []
	
	var xAxisLabel: UILabel!
	var yAxisLabel: UILabel!
	
	var headerLabel: UILabel!
	var detailHeaderLabel: UILabel!
	
	var values: [Float]!
	
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		backgroundColor = .clear
		selectionStyle = .none
		values = []
		
		createUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
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
	
	fileprivate func createUI() {
		viewBG = UIView()
		viewBG.backgroundColor = .white
            
        chart = LineChartView()
        chart.delegate = self
        chart.chartDescription.enabled = false
        chart.dragEnabled = false
        chart.setScaleEnabled(false)
        chart.pinchZoomEnabled = false
        chart.legend.enabled = false
        
        //set xAxis label
        let xAxis = chart.xAxis
        xAxis.labelFont = .kanitLight10
        xAxis.labelTextColor = .cencelborder
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.labelPosition = .bottom
        
        //set yAxis left label
        let leftAxis = chart.leftAxis
        leftAxis.labelFont = .kanitLight10
        leftAxis.labelTextColor = .cencelborder
        leftAxis.axisMaximum = 100
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = true
        leftAxis.drawAxisLineEnabled = false
        leftAxis.enabled = true
        
        let rightAxis = chart.rightAxis
        rightAxis.enabled = false
        
        //set animated linechart
        chart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .linear)
		
		xAxisLabel = UILabel()
		xAxisLabel.setParameter(font: .kanitLight10, color: .cencelborder, alignment: .right)

		yAxisLabel = UILabel()
		yAxisLabel.setParameter(font: .kanitLight10, color: .cencelborder, alignment: .left)
		
		headerLabel = UILabel()
		headerLabel.setParameter(font: .kanitLight16, color: .Celllabel, alignment: .left)
		headerLabel.text = string.th_analysis_summary_exam
		
		contentView.addsubviews([viewBG, headerLabel])
		viewBG.addsubviews([chart, xAxisLabel, yAxisLabel])
    
		setLayout()
	}
	
    func setData(_ data: MemberGraphModel, xTitle: String, yTitle: String,hexColor: String) {
		xAxisLabel.text = xTitle
		yAxisLabel.text = yTitle
        dataEntries.removeAll()
        labels.removeAll()
        let color = UIColor.color(fromHexString: hexColor)
        if data.count == 1 {
            for i in 0..<data.percentages.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(data.percentages[i].score))
                dataEntries.append(dataEntry)
            }
            for i in 0..<data.count + 2 {
                labels.append("\(i + 1)")
            }
        }else{
            for i in 0..<data.percentages.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(data.percentages[i].score))
                dataEntries.append(dataEntry)
            }
            for i in 0..<data.count {
                labels.append("\(i + 1)")
            }
        }
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "")
        lineChartDataSet.axisDependency =  .left
        lineChartDataSet.setColor(color)
        lineChartDataSet.setCircleColor(color)
        lineChartDataSet.lineWidth = 2.5
        lineChartDataSet.circleRadius = 4
        lineChartDataSet.drawCircleHoleEnabled = false
        lineChartDataSet.mode = .horizontalBezier
      
        let lineChartData = LineChartData(dataSets: [lineChartDataSet])
        
        chart.notifyDataSetChanged()
        chart.data?.notifyDataChanged()
        chart.data = lineChartData
        chart.data?.setDrawValues(false)
        chart.setVisibleXRangeMaximum(Double(labels.count + 2))
        chart.setVisibleXRangeMinimum(1)
        
        chart.xAxis.labelCount = labels.count 
        chart.xAxis.setLabelCount(labels.count, force: true)
        chart.xAxis.granularity = 1
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        chart.xAxis.centerAxisLabelsEnabled = false
        chart.xAxis.avoidFirstLastClippingEnabled = false

        // - tap line chart show value
        chart.highlightPerTapEnabled = true
        chart.drawMarkers = true
        chart.data?.isHighlightEnabled = true
        
        let customMarkerView = CustomMarkerView(frame: .zero)
        customMarkerView.markerBoard = chart
	}
	
	fileprivate func setLayout() {
		viewBG.snp.remakeConstraints({ (make) in
			make.top.equalTo(contentView.snp.top)
			make.leading.equalTo(contentView.snp.leading)
			make.trailing.equalTo(contentView.snp.trailing)
			make.height.equalTo(325)
			make.bottom.equalTo(contentView.snp.bottom).offset(-49)
		})
		headerLabel.snp.remakeConstraints({ (make) in
			make.top.equalTo(viewBG.snp.bottom).offset(MARGIN)
			make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
			make.height.equalTo(24)
		})
		chart.snp.remakeConstraints { (make) in
			make.top.equalTo(viewBG.snp.top).offset(2*MARGIN)
			make.leading.equalTo(viewBG.snp.leading).offset(MARGIN)
			make.trailing.equalTo(viewBG.snp.trailing).offset(-2*MARGIN)
			make.bottom.equalTo(viewBG.snp.bottom).offset(-MARGIN)
		}
		xAxisLabel.snp.remakeConstraints { (make) in
			make.size.equalTo(CGSize(width: 100, height: 20))
			make.trailing.equalTo(viewBG.snp.trailing).offset(-MARGIN)
			make.bottom.equalTo(viewBG.snp.bottom).offset(-MARGIN-8)
		}
		yAxisLabel.snp.remakeConstraints { (make) in
			make.size.equalTo(CGSize(width: 100, height: 20))
			make.top.equalTo(viewBG.snp.top).offset(SMALLINSET)
			make.leading.equalTo(viewBG.snp.leading).offset(MARGIN)
		}
	}
}
