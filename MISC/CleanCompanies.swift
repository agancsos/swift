import Foundation
import CoreFoundation
import EventKit

public class Reminders {
    private var store              : EKEventStore;

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
	}

	public func entryExists(cal: EKCalendar, entry: String, _ completion: @escaping (Bool) -> ()){
		let queue = DispatchSemaphore(value: 0);
		self.store.fetchReminders(matching: self.store.predicateForReminders(in: [cal]), completion: { rsp in
			if rsp == nil {
				completion(false);
				queue.signal();
			}
			for r in rsp! {
				if r.title == entry {
					completion(true);
					queue.signal();
				}
			}
			completion(false);	
			queue.signal();
        });
		queue.wait();
	}
}

var fileName = "";
var listName = "";
var isDebug  = false;
for i : Int in 0..<CommandLine.arguments.count {
	if CommandLine.arguments[i] == "-f" {
		fileName = CommandLine.arguments[i + 1];
	}
	else if CommandLine.arguments[i] == "-l" {
		listName = CommandLine.arguments[i + 1];
	}
	else if CommandLine.arguments[i] == "--debug" {
		isDebug = true;
	}
}
let service = Reminders();
if (listName == "") {
	service.getReminders().forEach({
    	print($0.title);
	});
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
			service.entryExists(cal: reminders!, entry: String(company), { rsp in
				if rsp {
					print("Cleaning: '\(company)'");
					if !isDebug {
					}
				}	
			});
		}
	}
}

