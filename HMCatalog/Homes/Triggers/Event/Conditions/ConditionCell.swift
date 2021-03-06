/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The `ConditionCell` displays characteristic and location conditions.
*/

import UIKit
import HomeKit

/// A `UITableViewCell` subclass that displays a trigger condition.
class ConditionCell: UITableViewCell {
    /// A static, short date formatter.
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        return dateFormatter
        }()
    
    /// Ignores the passed-in style and overrides it with .Subtitle.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        detailTextLabel?.textColor = UIColor.lightGray
        accessoryType = .none
    }
    
    /// Required because we overwrote a designated initializer.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
        Sets the cell's text to represent a characteristic and target value.
        For example, "Brightness → 60%"
        Sets the subtitle to the service and accessory that this characteristic represents.
        
        - parameter characteristic: The characteristic this cell represents.
        - parameter targetValue:    The target value from this action.
    */
    func setCharacteristic(_ characteristic: HMCharacteristic, targetValue: AnyObject) {
        let targetDescription = "\(characteristic.localizedDescription) → \(characteristic.localizedDescriptionForValue(targetValue))"
        textLabel?.text = targetDescription
        
        let contextDescription = NSLocalizedString("%@ in %@", comment: "Service in Accessory")
        if let service = characteristic.service, let accessory = service.accessory {
            detailTextLabel?.text = String(format: contextDescription, service.name, accessory.name)
        }
        else {
            detailTextLabel?.text = NSLocalizedString("Unknown Characteristic", comment: "Unknown Characteristic")
        }
    }
    
    /**
        Sets the cell's text to represent an ordered time with a set context string.
        
        - parameter order: A `TimeConditionOrder` which will map to a localized string.
        - parameter timeString: The localized time string.
        - parameter contextString: A localized string describing the time type.
    */
    private func setOrder(_ order: TimeConditionOrder, timeString: String, contextString: String) {
        let formatString: String
        switch order {
            case .before:
                formatString = NSLocalizedString("Before %@", comment: "Before Time")
            
            case .after:
                formatString = NSLocalizedString("After %@", comment: "After Time")
            
            case .at:
                formatString = NSLocalizedString("At %@", comment: "At Time")
        }
        textLabel?.text = String(format: formatString, timeString)
        detailTextLabel?.text = contextString
    }
    
    /**
        Sets the cell's text to represent an exact time condition.
        
        - parameter order: A `TimeConditionOrder` which will map to a localized string.
        - parameter dateComponents: The date components of the exact time.
    */
    func setOrder(_ order: TimeConditionOrder, dateComponents: DateComponents) {
        let date = Calendar.current.date(from: dateComponents)
        let timeString = ConditionCell.dateFormatter.string(from: date!)
        setOrder(order, timeString: timeString, contextString: NSLocalizedString("Relative to Time", comment: "Relative to Time"))
    }
    
    /**
        Sets the cell's text to represent a solar event time condition.
        
        - parameter order: A `TimeConditionOrder` which will map to a localized string.
        - parameter sunState: A `TimeConditionSunState` which will map to localized string.
    */
    func setOrder(_ order: TimeConditionOrder, sunState: TimeConditionSunState) {
        let timeString: String
        switch sunState {
            case .sunrise:
                timeString = NSLocalizedString("Sunrise", comment: "Sunrise")
            
            case .sunset:
                timeString = NSLocalizedString("Sunset", comment: "Sunset")
        }
        setOrder(order, timeString: timeString , contextString: NSLocalizedString("Relative to sun", comment: "Relative to Sun"))
    }
    
    /// Sets the cell's text to indicate the given condition is not handled by the app.
    func setUnknown() {
        let unknownString = NSLocalizedString("Unknown Condition", comment: "Unknown Condition")
        detailTextLabel?.text = unknownString
        textLabel?.text = unknownString
    }
}
