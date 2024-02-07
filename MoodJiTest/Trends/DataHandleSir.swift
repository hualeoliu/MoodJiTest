//
//  DataHandleSir.swift
//  Flowzland
//
//  Created by flowz-leo on 2023/12/28.
//

import Foundation
import HealthKit

class DataHandleSir: NSObject {
    let healthStore = HKHealthStore()
    let shareReadObjectTypes: Set<HKSampleType> = [
        // Category
        HKQuantityType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!,
        //Heart rate
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRateVariabilitySDNN)!,
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.restingHeartRate)!,
        
        // Measurements
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyFatPercentage)!,
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.leanBodyMass)!,
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMassIndex)!,
        // Nutrients
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal)!,
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodGlucose)!,
        
        // Fitness
        //            HKWorkoutType.workoutType(),
        HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
        HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.uvExposure)!,
        
        
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceCycling)!,
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.basalEnergyBurned)!,
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.flightsClimbed)!,
        // Results
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyTemperature)!,
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureSystolic)!,
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureDiastolic)!,
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.respiratoryRate)!,
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.basalBodyTemperature)!,
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodGlucose)!,
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.oxygenSaturation)!,
        //            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodAlcoholContent)!
    ]
    
    func reqHealthKit(_ completion: (()->())?) {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit 不可用")
            return
        }
        //        healthStore.authorizationStatus(for: .activitySummaryType()) == HKAuthorizationStatus.sharingAuthorized
        healthStore.requestAuthorization(toShare: nil, read: shareReadObjectTypes, completion: { [self] (res, error) in
            if let error = error {
                print(error)
            } else {
                completion?()
            }
        })
    }
    
    func stepsOfday(_ haq: HealthDayBean, _ done: (()->())? = nil) {
        let startDate = Calendar.current.startOfDay(for: haq.day)
        let endDate = haq.day.endOfDay
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                done?()
            } else {
                if let result = result, let sum = result.sumQuantity() {
                    let totalSteps = sum.doubleValue(for: HKUnit.count())
                    haq.stepNum = totalSteps
                    print("Total steps: \(totalSteps)")
                    //                    done?()
                }
            }
        }
        healthStore.execute(query)
        
        let query1Type = HKObjectType.quantityType(forIdentifier: .uvExposure)!
        let query1 = HKSampleQuery(sampleType: query1Type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            print(query, results, error)
            if let error = error {
                print("Error: \(error.localizedDescription)")
                done?()
            } else {
                if let results = results as? [HKQuantitySample], !results.isEmpty {
                    var totalUVExposure: Double = 0
                    for sample in results {
                        totalUVExposure += sample.quantity.doubleValue(for: .internationalUnit())
                    }
                    haq.vuSec = totalUVExposure
                    print("Total UV exposure today: \(totalUVExposure) IU.")
                    done?()
                }
            }
            
        }
        healthStore.execute(query1)
        
        let query2 = HKSampleQuery(sampleType: HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            if let sleepSamples = results as? [HKCategorySample] {
                var totalBedTime = 0.0
                for sample in sleepSamples {
                    if sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue {
                        totalBedTime += sample.endDate.timeIntervalSince(sample.startDate)
                    }
                }
                haq.bedSec = totalBedTime
                print("Total bed time in the last week: \(totalBedTime) sec")
                done?()
            }
        }
        
        healthStore.execute(query2)
        
        
    }
    
    func loadTrends(weekSomeDay: Date, trendIndex: Int, completion: @escaping ([TrendModel]) -> ()) {
        let lastDayOfWeek = weekSomeDay.sunday
        var days = [Date]()
        for idx in 0..<7 {
            let day = lastDayOfWeek.prevDay(idx)
            days += [day]
        }
        
        var dataTrend = [TrendModel]()
        for idx in 0..<days.count {
            let day = days.reversed()[idx]
            var mod = TrendModel()
            mod.day = day
            mod.daySleep.day = day
            stepsOfday(mod.daySleep, {
            })
            mod.dayLastSleep.day = day.prevDay(7)
            stepsOfday(mod.dayLastSleep, {
            })
            dataTrend += [mod]
            if idx == days.count-1 {
                afterDo(0.1) {
                    dataTrend.forEach { mod in
                        switch trendIndex {
                        case 0:
                            mod.sales = (mod.daySleep.stepNum)
                            mod.salesLast = (mod.dayLastSleep.stepNum)
                        case 3:
                            mod.sales = (mod.daySleep.bedSec)
                            mod.salesLast = (mod.dayLastSleep.bedSec)
                        default:
                            mod.sales = (mod.daySleep.vuSec)
                            mod.salesLast = (mod.dayLastSleep.vuSec)
                        }
                    }
                    DataHandleSir.setYAxisValue(false, trendIndex, dataTrend)
                    completion(dataTrend)
                }
                
            }
            
            //            AppStateManager.shared.healthService.queryWeekSleepModelList(weekIds: [lastDayOfWeek.thisWeek().dayId, lastDayOfWeek.prevWeek().dayId]) { res in
            //                switch res {
            //                    case let .success(modelList):
            //                    mod.weekSleep = modelList.first
            //                    mod.weekLastSleep = modelList.last
            //
            //                    AppStateManager.shared.healthService.queryWhichDaySleepFeelModel(uid: uid, dayId: day.prevDay(7).dayId) { t in
            //                        let hearts = getSleepHeartRateValue(t)
            //                        mod.heartRateLastMin = hearts.0
            //                        mod.heartRateLastMax = hearts.1
            //                        mod.salesLast = getSleepNumValue(t, type: trendIndex) ?? 0
            //                        mod.dayLastSleep = t
            //
            //                        AppStateManager.shared.healthService.queryWhichDaySleepFeelModel(uid: uid, dayId: day.dayId) { t in
            //                            let hearts = getSleepHeartRateValue(t)
            //                            mod.heartRateMin = hearts.0
            //                            mod.heartRateMax = hearts.1
            //                            mod.sales = getSleepNumValue(t, type: trendIndex) ?? 0
            //                            mod.daySleep = t
            //
            //                            dataTrend += [mod]
            //                            if idx == days.count-1 {
            //                                setYAxisValue(false, trendIndex, dataTrend)
            //                                completion(dataTrend)
            //                            }
            //                        }
            //                    }
            //
            //                    case .failure:
            //                        completion([])
            //                }
            //            }
            
        }
    }
    
    
    static func setYAxisValue(_ isActive: Bool, _ type: Int, _ mods: [TrendModel]) {
        if let lastMax = mods.map({ $0.salesLast }).max(), let curMax = mods.map({ $0.sales }).max(),
           let lastMin = mods.map({ $0.salesLast }).min(), let curMin = mods.map({ $0.sales }).min() {
            
            var maxNum = max(lastMax, curMax)
            var minNum = min(lastMin, curMin)
            let mod = mods[0]
            
            maxNum = (ceil(Double(maxNum)/10)*10)
            minNum = (floor(Double(minNum)/10)*10)
            
            if isActive {
                mod.chartMax = maxNum > 80 ? "\(ceil(Double(maxNum) / 60).cleanZero1) \(NSLocalizedString("h-trends", comment: ""))" : "\(maxNum) \(NSLocalizedString("m-trends", comment: ""))"
                mod.chartMin = maxNum > 80 ? "\(floor(Double(minNum) / 60).cleanZero1) \(NSLocalizedString("h-trends", comment: ""))" : "\(minNum) \(NSLocalizedString("m-trends", comment: ""))"
                if type == 0 {
                    mod.chartMax = "\(maxNum)\(NSLocalizedString(" steps", comment: "formatSteps"))"
                    mod.chartMin = "\(minNum)\(NSLocalizedString(" steps", comment: "formatSteps"))"
                }
                if type == 3 {//WHRV
                    mod.chartMax = "\(maxNum) MS"
                    mod.chartMin = "\(minNum) MS"
                }
            }else{
                if type == 4 {
                    mod.chartMax = "\(maxNum)\(NSLocalizedString(" steps", comment: "formatSteps"))"
                    mod.chartMin = "\(minNum)\(NSLocalizedString(" steps", comment: "formatSteps"))"
                } else if type == 5 {
                    if let lastRateMax = mods.map({ $0.heartRateLastMax }).max(), let curRateMax = mods.map({ $0.heartRateMax }).max(),
                       let lastRateMin = mods.map({ $0.heartRateLastMin }).min(), let curRateMin = mods.map({ $0.heartRateMin }).min() {
                        maxNum = max(lastRateMax, curRateMax)
                        minNum = min(lastRateMin, curRateMin)
                        
                        maxNum = (ceil(Double(maxNum)/10)*10)
                        minNum = (floor(Double(minNum)/10)*10)
                        
                        mod.chartMax = "\(maxNum)\(NSLocalizedString(" bpm", comment: "formatHeartRate"))"
                        mod.chartMin = "\(minNum)\(NSLocalizedString(" bpm", comment: "formatHeartRate"))"
                    }
                } else {
                    mod.chartMax = maxNum > 80 ? "\(ceil(Double(maxNum) / 60).cleanZero1) \(NSLocalizedString("h-trends", comment: ""))" : "\(maxNum) \(NSLocalizedString("m-trends", comment: ""))"
                    mod.chartMin = maxNum > 80 ? "\(floor(Double(minNum) / 60).cleanZero1) \(NSLocalizedString("h-trends", comment: ""))" : "\(minNum) \(NSLocalizedString("m-trends", comment: ""))"
                }
            }
        }
    }
        
    static func formatSleepValue(time: Int, type: Int) -> String {
        //        let typeSleepNames: [Int: SleepState] = [0: .kInvalid, 1: .kInBed, 2: .kWindDown, 3: .kScreen, 4: .kActive, 5: .kHeartRate, 6: .kAwake, 7: .kREM, 8: .kCore, 9: .kDeepSleep]
        //        let detailType = typeSleepNames[type]
        switch type {
        case 0:
            return "\(time)\(NSLocalizedString(" steps", comment: "formatSteps"))"
        case 1:
            if time <= 0 {
                return "--"
            }
            return "\(time)\(NSLocalizedString(" bpm", comment: "formatHeartRate"))"
        default:
            return "\(time) M"
        }
    }
}



class TrendModel: NSObject {//折线图数据模型
    var day: Date = Date()
    var salesLast = 0.0 // 折线图数值1上周
    var sales = 0.0 // 折线图数值2当前周
    
    var heartRateLastMin = 0.0
    var heartRateLastMax = 0.0//上周睡眠心跳直接数值
    var heartRateMin = 0.0
    var heartRateMax = 0.0//本周睡眠心跳直接数值
    
    var chartMax = "1"
    var chartMin = "0"
    
    var daySleep = HealthDayBean()//睡眠的天数据模型
    var dayLastSleep = HealthDayBean()
    
    var weekSleep: WeekSleepFeelModel?//睡眠的周数据模型
    var weekLastSleep: WeekSleepFeelModel?
    
    var dayActive: DayHourFeelModel?//不确定这个模型是不是每天的?
    var dayLastActive: DayHourFeelModel?
    
    var weekActive: WeekHourFeelModel?//运动的周数据模型
    var weekLastActive: WeekHourFeelModel?
}


class HealthDayBean: NSObject {
    var day = Date()
    var stepNum = 0.0
    var vuSec = 0.0
    var bedSec = 0.0
}

class WeekSleepFeelModel: NSObject {
    
}

class DayHourFeelModel: NSObject {
    
}

class WeekHourFeelModel: NSObject {
    
}

extension Double {
    var cleanZero1 : String {// 小数点后如果只是0，显示整数，如果不是，显示一位小数
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.1f", self)
    }
    
}
