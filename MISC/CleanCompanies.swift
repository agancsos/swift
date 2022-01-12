import Foundation
import EventKit

public class ReminderService {
    private var store             : EKEventStore;

    public  init() {
        self.store = EKEventStore();
        self.store.requestAccess(to: .reminder, completion: { rsp, _ in

        });
    }

    public func getLists() -> [EKCalendar] {
        return self.store.calendars(for: .reminder)
    }

    public func getList(name: String) -> EKCalendar? {
        for cal : EKCalendar in self.getLists() {
            if cal.title == name {
                return cal;
            }
        }
        return nil;
    }

    public func getReminders(cal: EKCalendar) -> [EKReminder]? {
        let semaphore = DispatchSemaphore(value: 0);
        var result : [EKReminder]? = [];
        self.store.fetchReminders(matching: self.store.predicateForReminders(in: [cal]), completion: { rsp in
            result = rsp;
            semaphore.signal();
        });
        semaphore.wait();
        return result;
    }

	public func getReminder(cal: EKCalendar, name: String) -> EKReminder? {
		let semaphore = DispatchSemaphore(value: 0);
        var result : EKReminder? = nil;
        self.store.fetchReminders(matching: self.store.predicateForReminders(in: [cal]), completion: { rsp in
			if rsp == nil { return; }
			for temp in rsp! {
				if temp.title! == name {
            		result = temp;
            		semaphore.signal();
					break;
				}
			}
			semaphore.signal();
        });
        semaphore.wait();
        return result;
    }

    public func markCompleted(reminder: EKReminder) {
        reminder.isCompleted = true;
        try? self.store.save(reminder, commit: true);
    }

	public func removeReminder(reminder: EKReminder) {
		try? self.store.remove(reminder, commit: true);
	}

	public func entryExists(cal: EKCalendar, entry: String) -> Bool {
		return self.getReminder(cal: cal, name: entry) == nil;
	}
}

var fileName       = "";
var listName       = "";
var isDebug        = false;
var skipDuplicates = false;
for i : Int in 0..<CommandLine.arguments.count {
	if CommandLine.arguments[i] == "-f" { fileName = CommandLine.arguments[i + 1]; }
	else if CommandLine.arguments[i] == "-l" { listName = CommandLine.arguments[i + 1]; }
	else if CommandLine.arguments[i] == "--debug" { isDebug = true; }
	else if CommandLine.arguments[i] == "--skip" { skipDuplicates = true; }
}
let service = ReminderService();
if (listName == "") {
	service.getLists().forEach({ print($0.title); });
}
else {
	if fileName == "" && !skipDuplicates {
		print("Filename cannot be empty...");
		exit(-1);
	}

	let rawCompanies : [String] = [];
	if !skipDuplicates {
		try? String(contentsOf: URL(string: "file://\(fileName)")!, encoding: .utf8).split(separator: "\n");
	}
	let reminders = service.getList(name: listName);
	if reminders != nil {
		if !skipDuplicates {
			for company in rawCompanies {
				if service.entryExists(cal: reminders!, entry: String(company)) {
					print("Cleaning: '\(company)'");
					if !isDebug {
						service.removeReminder(reminder: service.getReminder(cal: reminders!, name: String(company))!);
					}
					if (String(company).lowercased().contains(" gmbh") || String(company).lowercased().contains(" uk")) {
                    	print("Company (\(String(company))) is not in the US");
                    	if !isDebug {
                        	service.markCompleted(reminder: service.getReminder(cal: reminders!, name: String(company))!);
                    	}
                	}
				}
			}
		}
		else {
			for company in service.getReminders(cal: reminders!)!{
            	if (company.title!.lowercased().contains(" gmbh") || company.title!.lowercased().contains(" uk")) {
                	print("Company (\(company.title!)) is not in the US");
                	if !isDebug {
                    	service.markCompleted(reminder: company);
                	}
            	}
            }
		}	
	}
}

