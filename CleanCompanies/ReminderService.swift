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
