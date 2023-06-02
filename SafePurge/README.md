# README
## About
* Name        : SafePurge
* Author       : Abel Gancsos
* Version      : v. 1.0.0

## Implementation Details
SafePurge is a macOS only application meant to safely purge old data that is otherwise taking of storage unnecessarily.  Overall, SafePurge searches files for age, file size, as well as file types in order to determine which files are no longer needed.  SafePurge also offers options to restrict which files should be ignored.  


## Assumption 
* There is a need to purge old data in order to save on space.
* Microsoft Windows already has a means to purge old data.
* Linux operating systems already have a means to purge old data.
* User cache files are under ~/Library/Caches.
* System cache files are under Library/Caches.
* iTunes library backups are under ~/Music/iTunes/Previous iTunes Libraries.
* IOS backups are under /Library/Application Support/MobileSync/Backup/.
* iPad software updates are under ~/Library/iTunes/iPad Software Updates.
* iPhone software updates are under ~/Library/iTunes/iPhone Software Updates.

## Implementation Description 

## Parameters and Configuration
###  Flags
### Registry
| Name                                                       | Description                                                                           | Possible Values                                | Default                                          
|--|--|--|--|
| TraceLevel                                               | Level of the tracing                                                               | 0,1,2,3,4,5                                        | 1                                        
| MininumFileSize                                      | Minimum file size for files to be removed                             |                                                          | 5M                                     
| IncludedBasePaths                                 | Base directories to include                                                   |                                                          |                                           
| RetentionPeriod                                      | Number of days to keep archives or backups                      |                                                          | 30
