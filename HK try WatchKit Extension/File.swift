//
//  File.swift
//  HK try WatchKit Extension
//
//  Created by denys on 21/01/2020.
//  Copyright © 2020 denys. All rights reserved.
//

import Foundation
import HealthKit

class HeartCL: ObservableObject {
    var heartRateQuery: HKObserverQuery!
    public let healthStore = HKHealthStore()
    @Published var heartB = 0
    

    public func requestAccessToHealthKit() {
        if HKHealthStore.isHealthDataAvailable() {
             let healthKitTypesToWrite: Set<HKSampleType> = [
                 HKObjectType.workoutType(),
                 HKSeriesType.workoutRoute(),
                 HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                 HKObjectType.quantityType(forIdentifier: .heartRate)!,
                 HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
                 HKObjectType.quantityType(forIdentifier: .bodyMass)!,
                 HKObjectType.quantityType(forIdentifier: .vo2Max)!,
                 HKObjectType.quantityType(forIdentifier: .stepCount)!,
                 HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!]

             let healthKitTypesToRead: Set<HKObjectType> = [
                 HKObjectType.workoutType(),
                 HKSeriesType.workoutRoute(),
                 HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                 HKObjectType.quantityType(forIdentifier: .heartRate)!,
                 HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
                 HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
                 HKObjectType.quantityType(forIdentifier: .bodyMass)!,
                 HKObjectType.quantityType(forIdentifier: .vo2Max)!,
                 HKObjectType.quantityType(forIdentifier: .stepCount)!,
                 HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!]

             let authorizationStatus = healthStore.authorizationStatus(for: HKSampleType.workoutType())

             switch authorizationStatus {

                 case .sharingAuthorized: print("sharing authorized")
                     print("sharing authorized this message is from Watch's extension delegate")

                 case .sharingDenied: print("sharing denied")

                    healthStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
                         print("Successful HealthKit Authorization from Watch's extension Delegate")
                 }

                 default: print("not determined")

                 healthStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
                     print("Successful HealthKit Authorization from Watch's extension Delegate")
                 }

             }
        }
        print("DEBUG")
    }
    
    public func subscribeToHeartBeatChanges() {

      // Creating the sample for the heart rate
      guard let sampleType: HKSampleType =
        HKObjectType.quantityType(forIdentifier: .heartRate) else {
          return
      }

      /// Creating an observer, so updates are received whenever HealthKit’s
      // heart rate data changes.
      self.heartRateQuery = HKObserverQuery.init(
        sampleType: sampleType,
        predicate: nil) { [weak self] _, _, error in
          guard error == nil else {
            print(error!)
            return
          }

          /// When the completion is called, an other query is executed
          /// to fetch the latest heart rate
            self?.fetchLatestHeartRateSample(completion: { sample in
            guard let sample = sample else {
              return
            }

            /// The completion in called on a background thread, but we
            /// need to update the UI on the main.
            DispatchQueue.main.async {

              /// Converting the heart rate to bpm
              let heartRateUnit = HKUnit(from: "count/min")
              let heartRate = sample
                .quantity
                .doubleValue(for: heartRateUnit)

              /// Updating the UI with the retrieved value
                self?.heartB = Int(heartRate)
            }
          })
      }
    }

    public func fetchLatestHeartRateSample(
      completion: @escaping (_ sample: HKQuantitySample?) -> Void) {

      /// Create sample type for the heart rate
      guard let sampleType = HKObjectType
        .quantityType(forIdentifier: .heartRate) else {
          completion(nil)
        return
      }

      /// Predicate for specifiying start and end dates for the query
      let predicate = HKQuery
        .predicateForSamples(
          withStart: Date.distantPast,
          end: Date(),
          options: .strictEndDate)

      /// Set sorting by date.
      let sortDescriptor = NSSortDescriptor(
        key: HKSampleSortIdentifierStartDate,
        ascending: false)

      /// Create the query
      let query = HKSampleQuery(
        sampleType: sampleType,
        predicate: predicate,
        limit: Int(HKObjectQueryNoLimit),
        sortDescriptors: [sortDescriptor]) { (_, results, error) in

          guard error == nil else {
            print("Error: \(error!.localizedDescription)")
            return
          }
          
          completion(results?[0] as? HKQuantitySample)
      }

      self.healthStore.execute(query)
    }
}
