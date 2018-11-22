//
/*
 
 * LKStateManager
 * Created by: Leela Prasad on 15/11/18
 
 * Copyright © 2018 Leela Prasad. All rights reserved.
 * All rights have been granted for free of use for any project in SecNinjaz
 
 */

import UIKit

class SomeClass {
  
  enum AAA {
    
    case loading
    case error
    case empty
    case populated
    
  }
  
  enum BBB: String {
    
    case loading
    case error
    case empty
    case populated
    
  }
  
  enum CCC: Double {
    
    case loading
    case error
    case empty
    case populated
    
  }
  
  func mymethod() {
    
    let aaa = AAA.empty
    print(aaa.hashValue)
    
    let bbb = BBB.init(rawValue: "error")!
    let bbb1 = BBB.error
    print(bbb == bbb1)
    
    let ccc = CCC.init(rawValue: 2.0)
    print(ccc ?? .empty)
    let cccc = CCC.error
    print(cccc.rawValue)
    
  }
  
  //Associated Values
  //With Labels
  enum Marks {
    
    case languages(marks: Int)
    case scienceSubjects(marks: Int)
    case games(marks: Int)
    case otherActivities(marks: Int)
    
  }
  
  //Without Labels
  enum Percentage {
    case languages(Double)
    case scienceSubjects(Double)
    case games(percentage: Double) //Contains label
    case otherActivities(Double)
  }
  
  func method1() {
    
    let myMarks = Marks.languages(marks: 300)
    
    //Pattern Matching
    if case let Marks.languages(marks: languageMarks) = myMarks {
      
      print("I got \(languageMarks) in marks Languages")
    }
    
    let myPerc = Percentage.languages(80.5)
    
    if case let Percentage.languages(percInLang) = myPerc {
      
      print("I got \(percInLang) percentage in Languages")
    }
    
  }
  
  
}
