/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The `Array+Sorting` extension allows for easy sorting of HomeKit objects.
*/

import HomeKit

/// A protocol for objects which have a property called `name`.
protocol Nameable {
    var name: String { get }
}

/*
    All of these HomeKit objects have names and can conform
    to this protocol without modification.
*/

extension HMHome: Nameable {}
extension HMAccessory: Nameable {}
extension HMRoom: Nameable {}
extension HMZone: Nameable {}
extension HMActionSet: Nameable {}
extension HMService: Nameable {}
extension HMServiceGroup: Nameable {}
extension HMTrigger: Nameable {}

extension Collection where Iterator.Element: Nameable {
    /**
        Generates a new array from the original collection,
        sorted by localized name.
        
        - returns:  New array sorted by localized name.
    */
    func sortByLocalizedName() -> [Iterator.Element] {
        return sorted { return $0.name.localizedCompare($1.name) == .orderedAscending }
    }
}

extension Collection where Iterator.Element: HMActionSet {
    /**
        Generates a new array from the original collection,
        sorted by built-in first, then user-defined sorted
        by localized name.
        
        - returns:  New array sorted by localized name.
    */
    func sortByTypeAndLocalizedName() -> [HMActionSet] {
        return sorted { (actionSet1, actionSet2) -> Bool in
            if actionSet1.isBuiltIn != actionSet2.isBuiltIn {
                // If comparing a built-in and a user-defined, the built-in is ranked first.
                return actionSet1.isBuiltIn
            }
            else if actionSet1.isBuiltIn && actionSet2.isBuiltIn {
                // If comparing two built-ins, we follow a standard ranking
                let firstIndex = HMActionSet.Constants.builtInActionSetTypes.firstIndex(of: actionSet1.actionSetType) ?? NSNotFound
                let secondIndex = HMActionSet.Constants.builtInActionSetTypes.firstIndex(of: actionSet2.actionSetType) ?? NSNotFound
                return firstIndex < secondIndex
            }
            else {
                // If comparing two user-defines, sort by localized name.
                return actionSet1.name.localizedCompare(actionSet2.name) == .orderedAscending
            }
        }
    }
}
