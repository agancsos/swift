import Foundation
import EventKit

public class Reminders {
    private var store             : EKEventStore;

    public  init() {
        self.store = EKEventStore();
        self.store.requestAccess(to: .reminder, completion: { rsp, _ in

        });
    }

    public func getReminders() -> [EKCalendar] {
        return self.store.calendars(for: .reminder)
    }

    public func getReminder(name: String) -> EKCalendar? {
        for cal : EKCalendar in self.getReminders() {
            if cal.title == name {
                return cal;
            }
        }
        return nil;
    }

    public func removeReminder(cal: EKCalendar, entry: String) {
        let semaphore = DispatchSemaphore(value: 0);
        var reminder : EKReminder?;
        self.store.fetchReminders(matching: self.store.predicateForReminders(in: [cal]), completion: { rsp in
            if rsp == nil { semaphore.signal(); }
            for r in rsp! {
                if r.title! == entry {
                    reminder = r;
                    semaphore.signal();
                }
            }
            semaphore.signal();
        });
        semaphore.wait();
        if reminder != nil {
            try? self.store.remove(reminder!, commit: true);
        }
    }

    public func entryExists(cal: EKCalendar, entry: String) -> Bool {
        let semaphore = DispatchSemaphore(value: 0);
        var result = false;
        self.store.fetchReminders(matching: self.store.predicateForReminders(in: [cal]), completion: { rsp in
            if rsp == nil { semaphore.signal(); }
            for r in rsp! {
                if r.title == entry {
                    result = true;
                    semaphore.signal();
                }
            }
            semaphore.signal();
        });
        semaphore.wait();
        return result;
    }
}

var fileName = "";
var listName = "";
var isDebug  = false;
for i : Int in 0..<CommandLine.arguments.count {
    if CommandLine.arguments[i] == "-f" { fileName = CommandLine.arguments[i + 1]; }
    else if CommandLine.arguments[i] == "-l" { listName = CommandLine.arguments[i + 1]; }
    else if CommandLine.arguments[i] == "--debug" { isDebug = true; }
}
let service = Reminders();
if (listName == "") {
    service.getReminders().forEach({ print($0.title); });
}
else {
    if fileName == "" {
        print("Filename cannot be empty...");
        exit(-1);
    }

    let rawCompanies = try? String(contentsOf: URL(string: "file://\(fileName)")!, encoding: .utf8).split(separator: "\n");
    let reminders = service.getReminder(name: listName);
    if reminders != nil && rawCompanies != nil {
        for company in rawCompanies! {
            if service.entryExists(cal: reminders!, entry: String(company)) {
                print("Cleaning: '\(company)'");
                if !isDebug {
                    service.removeReminder(cal: reminders!, entry: String(company));
                }
            }
        }
    }
}
