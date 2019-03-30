//
//  QFchartView.swift
//  SwiftStudy
//
//  Created by qwp on 2018/4/9.
//  Copyright © 2018年 祁伟鹏. All rights reserved.
//
/*
 let qfView = QFRadarChartView.init(frame: CGRect(x: 0, y: 20, width: 320, height: 320))
 qfView.backgroundColor = .black
 
 let entry = qfView.addChartsData(title: "数据1", valueArr: [100,50,13,88,39], lineColor: UIColor.green, lineWidth: 1, fillColor: UIColor.brown, fillAlpha: 0.5)
 qfView.setChartData(setArray: [entry])
 
 self.view.addSubview(qfView)
 */

import UIKit
import Charts

class QFRadarChartView: UIView,ChartViewDelegate {
    
    var viewframe = CGRect.init()
    var chartView:RadarChartView  = RadarChartView()
    var rotationEnabled = true          //是否允许转动
    var highlightPerTapEnabled = false  //是否能被选中
    var mainLineWidth:CGFloat = 0.5     //主干线线宽
    var mainLineColor = UIColor.lightGray     //主干线颜色
    var edgeLineWidth:CGFloat = 0.375;  //边线宽度
    var edgeLineColor = UIColor.lightGray    //边线颜色
    var mainLineAlpha:CGFloat = 1       //主视图透明度
    
    
    @objc var yAxisMinimum:Double = 0         //Y轴最小值
    @objc var yAxisMaximum:Double = 0       //Y轴最大值
    @objc var yScale:Int = 4                  //Y轴分段
    var yScaleShow = true              //是否显示分段比例尺
    var yScaleColor = UIColor.lightGray //比例尺字体颜色
    var yScaleFont = UIFont.systemFont(ofSize: 9, weight: .light) //比例尺标签大小
    var yAxisValueShow = false           //是否显示Y轴数值
    var yAxisValueColor:UIColor = UIColor.red  //Y轴数值颜色
    var yAxisValueFont:UIFont = UIFont.systemFont(ofSize: 9, weight: .light) //Y轴数值字体
    @objc var yAxisTags:Array<String> = Array()        //Y轴标签
    
    var dataTitleColor:UIColor = UIColor.gray  //数据标题颜色
    var dataTitleFont:UIFont = UIFont.systemFont(ofSize: 10, weight: .light) //数据标题字体
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.viewframe = frame
        rotationEnabled = true
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI(){
        
        self.configUIDontShowTitle()
        
    }
    @objc func configUIDontShowTitle(){
        chartView = RadarChartView.init(frame: CGRect(x: 10, y: 10, width: viewframe.size.width-20 , height: viewframe.size.height-10))
        self.addSubview(chartView)
        chartView.delegate = self
        chartView.rotationEnabled = rotationEnabled
        chartView.highlightPerTapEnabled = highlightPerTapEnabled
        
        //雷达图线条样式
        chartView.webLineWidth = mainLineWidth
        chartView.webColor = mainLineColor
        chartView.innerWebLineWidth = edgeLineWidth
        chartView.innerWebColor = edgeLineColor
        chartView.webAlpha = mainLineAlpha
        chartView.chartDescription?.enabled = false
        
        //设置 xAxi
        let xAxis = chartView.xAxis
        xAxis.valueFormatter = self
        xAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        xAxis.xOffset = 0
        xAxis.yOffset = 0
        xAxis.labelTextColor = .gray
        
        
        //设置 yAxis
        let yAxis = chartView.yAxis;
        yAxis.axisMinimum = yAxisMinimum
        yAxis.axisMaximum = yAxisMaximum
        yAxis.drawLabelsEnabled = yScaleShow
        yAxis.labelCount = yScale
        yAxis.labelFont = yScaleFont
        yAxis.labelTextColor = yScaleColor
        
        let l = chartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .top
        l.orientation = .horizontal
        l.drawInside = true
        l.font = dataTitleFont
        l.xEntrySpace = 7
        l.yEntrySpace = 5
        l.textColor = dataTitleColor
    }
    
    @objc func addChartsData(title:String,valueArr:Array<CGFloat>,lineColor:UIColor,lineWidth:CGFloat,fillColor:UIColor,fillAlpha:CGFloat) -> RadarChartDataSet {
        
        var entries:Array<RadarChartDataEntry> = Array()
        for value in valueArr {
            entries.append(RadarChartDataEntry.init(value: Double(value)))
        }
        let set = RadarChartDataSet(values: entries, label: title)
        set.setColor(lineColor)//数据折线颜色
        set.fillColor = fillColor//填充颜色
        set.drawFilledEnabled = true//是否填充颜色
        set.fillAlpha = fillAlpha//填充透明度
        set.lineWidth = lineWidth//数据折线线宽
        set.drawHighlightCircleEnabled = true
        set.setDrawHighlightIndicators(true)
        set.drawValuesEnabled = yAxisValueShow//是否绘制显示数据
        return set
    }
    
    
    @objc func setChartData(setArray:Array<RadarChartDataSet>) {
        
        let data = RadarChartData(dataSets: setArray)
        data.setValueFont(yAxisValueFont)
        data.setDrawValues(yAxisValueShow)
        data.setValueTextColor(yAxisValueColor)
        
        //为雷达图提供数据
        chartView.data = data
        chartView.reloadInputViews()
        //设置动画
        chartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
    }
}
extension QFRadarChartView: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if yAxisTags.count>0 {
            return yAxisTags[Int(value) % yAxisTags.count]
        }
        return String.init(format: "%d", Int(value))
    }
}
