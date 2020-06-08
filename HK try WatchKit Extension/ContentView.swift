//
//  ContentView.swift
//  HK try WatchKit Extension
//
//  Created by denys on 20/01/2020.
//  Copyright © 2020 denys. All rights reserved.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    
    let heartMonitor : HKSleepBeat = HKSleepBeat()
    
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    @State var heartRate = 1
    
    var body: some View {
        
        Text("\(self.heartRate)").onReceive(timer) { (_) in
            DispatchQueue.main.async{
                
                self.heartMonitor.getHealthKitPermission()
            
            }
        }
//
    }
}
//    func takeInformation(){
//    guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
//        print("Nope")
//        return
//    }
//    let query = HKAnchoredObjectQuery(type: sampleType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit)
//                    { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
//
//                        guard let samples = samplesOrNil, let deletedObjects = deletedObjectsOrNil else {
//                            // Handle the error.
//                            fatalError("*** An error occurred during the initial query: \(errorOrNil) ***")
//                        }
//
//    //                    myAnchor = newAnchor
//                        print("Query Zone, your samples are : \(samples)")
//
//                        for rateSample in samples {
//                            print("your rate is : \(rateSample)")
//                        }
//                    }
//
//                    // Optionally, add an update handler.
//                    /*query.updateHandler = { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
//
//                        guard let samples = samplesOrNil, let deletedObjects = deletedObjectsOrNil else {
//                            // Handle the error.
//                            fatalError("*** An error occurred during an update: \(errorOrNil!.localizedDescription) ***")
//                        }
//                        print("Update Header Zone")
//    //                    myAnchor = newAnchor
//
//                        for stepCountSample in samples {
//                            // Process the step counts from the update.
//                        }
//
//                        for deletedStepCountSamples in deletedObjects {
//                            // Process the deleted step count samples from the update.
//                        }
//                    }*/
//
//                    // Run the query.
//                    self.healthStore.execute(query)
//                }
//
//}
//
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
//
////func takeInformation(){
////    guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
////        print("Nope")
////        return
////    }
////    let query = HKAnchoredObjectQuery(type: sampleType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit)
////                    { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
////
////                        guard let samples = samplesOrNil, let deletedObjects = deletedObjectsOrNil else {
////                            // Handle the error.
////                            fatalError("*** An error occurred during the initial query: \(errorOrNil) ***")
////                        }
////
////    //                    myAnchor = newAnchor
////                        print("Query Zone, your samples are : \(samples)")
////
////                        for rateSample in samples {
////                            print("your rate is : \(rateSample)")
////                        }
////
////                        for deletedStepCountSamples in deletedObjects {
////                            // Process the deleted step count samples.
////                        }
////                    }
////
////                    // Optionally, add an update handler.
////                    /*query.updateHandler = { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
////
////                        guard let samples = samplesOrNil, let deletedObjects = deletedObjectsOrNil else {
////                            // Handle the error.
////                            fatalError("*** An error occurred during an update: \(errorOrNil!.localizedDescription) ***")
////                        }
////                        print("Update Header Zone")
////    //                    myAnchor = newAnchor
////
////                        for stepCountSample in samples {
////                            // Process the step counts from the update.
////                        }
////
////                        for deletedStepCountSamples in deletedObjects {
////                            // Process the deleted step count samples from the update.
////                        }
////                    }*/
////
////                    // Run the query.
////                    self.healthStore.execute(query)
////                }
//
////.onReceive(timer) { (_) in
////            if HKHealthStore.isHealthDataAvailable() {
////
////                let allTypes = Set([ HKQuantityType.quantityType(forIdentifier: .heartRate)! , HKQuantityType.quantityType(forIdentifier: .distanceCycling)! ])
////
////                self.healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
////                    if !success {
////                        print("your request was was done(?)")
////                    }
////                }
////                print("Request authorization : \(self.healthStore))")
////
////                // Create the step count type.
////                guard let countType = HKObjectType.quantityType(forIdentifier: .heartRate ) else {
////                    // This should never fail when using a defined constant.
////                    fatalError("*** Unable to get the step count type ***")
////                }
////                print(countType.description)
////                let query = HKAnchoredObjectQuery(type: countType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit)
////                { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
////
////                    guard let samples = samplesOrNil, let deletedObjects = deletedObjectsOrNil else {
////                        // Handle the error.
////                        fatalError("*** An error occurred during the initial query: \(errorOrNil) ***")
////                    }
////
//////                    myAnchor = newAnchor
////                    print("Query Zone, your samples are : \(samples)")
////
////                    for rateSample in samples {
////                        print("your rate is : \(rateSample)")
////                    }
////
////                    for deletedStepCountSamples in deletedObjects {
////                        // Process the deleted step count samples.
////                    }
////                }
////
////                // Optionally, add an update handler.
////                /*query.updateHandler = { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
////
////                    guard let samples = samplesOrNil, let deletedObjects = deletedObjectsOrNil else {
////                        // Handle the error.
////                        fatalError("*** An error occurred during an update: \(errorOrNil!.localizedDescription) ***")
////                    }
////                    print("Update Header Zone")
//////                    myAnchor = newAnchor
////
////                    for stepCountSample in samples {
////                        // Process the step counts from the update.
////                    }
////
////                    for deletedStepCountSamples in deletedObjects {
////                        // Process the deleted step count samples from the update.
////                    }
////                }*/
////
////                // Run the query.
////                self.healthStore.execute(query)
////            }
