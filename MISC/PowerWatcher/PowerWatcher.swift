import Foundation
import AppKit

// https://newbedev.com/what-event-is-fired-when-mac-is-back-from-sleep
class PowerWatcher {
    
    public init() {
    }
    
    @objc func onWake(note: NSNotification) {
        print("System woke up...");
    }
    
    @objc func onSleep(note: NSNotification) {
        print("System fell asleep...");
    }   
    
    private func registerNotifications() {
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(onWake), name: NSWorkspace.didWakeNotification, object: nil);
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(onSleep), name: NSWorkspace.willSleepNotification, object: nil);
    }

    public func watch() {
        self.registerNotifications();
    }
}

let group   : DispatchGroup = DispatchGroup();
let watcher : PowerWatcher = PowerWatcher();
watcher.watch();
RunLoop.current.run();
