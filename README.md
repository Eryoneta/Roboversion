# RoboVersion

Based on _Robocopy_, Roboversion is a script based on _PowerShell_ capable of not only mirroring a folder system, but also versioning all of its files. A simple, yet effective, backup solution.

## _Notice_

<i>
  This project will not receive any more updates. I've long since moved to a Linux based OS, and those don't have Robocopy, which is the core of Roboversion.

  Also, rsnapshot is a way better alternative. No need to reinvent the wheel.
</i>

## Usage

Opening a _PowerShell_ console, run "`. "PATH_TO_FOLDER/RoboVersion.ps1";`"(The "`.`" is important!), where "`PATH_TO_FOLDER`" leads to the "`RoboVersion.ps1`" file.

With that, the command `Roboversion` will properly call a function.

## Parameters

### `-OrigPath`, `-OP`:
- Path to the origin-folder, which contains the files to be mirrored.

### `-DestPath`, `-DP`:
- Path to the target-folder, which will contain the copies and versions.

### `-VersionLimit`, `-VL`, `-V`:
- Total of versions allowed before replacing old ones.
- Needs to be between `0` and `99999`. Default is `5`.
- Optional.

### `-RemotionCountdown`, `-RC`, `-R`:
- Number of times the script needs to be run before the removed file is permanently deleted.
- Needs to be between `0` and `99999`. Default is `10`.
- Optional.

### `-Destructive`, `-D`:
- Forces the number of versions and removed to be within the parameters given.
- Default is `false`.
- Optional.

### `-ListOnly`, `-LO`, `-L`:
- Lists only, don't do any changes.
- Default is `false`.
- Optional.

## Examples

- `Roboversion -OrigPath "D:/Test/MyFolder" -DestPath "D:/Test/BackupFolder" -VersionLimit 3 -RemotionCountdown 5` mirrors all files from "`MyFolder`" to "`BackupFolder`", creating up to 3 versions, and having all removed files deleted after running the script 5 more times.
- `Roboversion "D:/Test/MyFolder" "D:/Test/BackupFolder" -V 3 -R 5` does the same thing.
- `Roboversion "D:/Test/MyFolder" "D:/Test/BackupFolder" -V 3 -R 5 -D` does the same thing, but all versions above `3` are decreased, maybe causing old versions starting from `1` to be deleted as needed. The same happens with remotions as well.
- `Roboversion "D:/Test/MyFolder" "D:/Test/BackupFolder" -V 3 -R 5 -L` only lists the changes it would do, but no actions are made.

## Behaviour

- Mirroring a origin-folder into a target-folder, it can do different things in different situations:
  - __New File__:
    - A file does not exist on target-folder.
    - A simple copy is made.
  - __Modified files__:
    - A file had been modified on origin-folder, and it's present on target-folder.
    - A copy is made, marked as a new version, and the original file is replaced by the one present in the origin-folder.
  - __Removed files__:
    - A file is not present on the target-folder, but it is on target-folder.
    - A copy is made, marked as removed, and the original is deleted.
- __Versions__:
  - If a file "`filename.ext`" has a new version, it's named "`filename _version[v].ext`", where `v` can range from `1` to `VersionLimit`.
    - When all numbers are occupied, version `1` is deleted and all others are renamed, leaving version `VersionLimit` free to be occupied.
      - Versions above `VersionLimit` are ignored.
    - Removed versions are ignored.
  - If `Destructive` is marked, then all versions that happen to be above `VersionLimit` are decreased to fit within the limit.
  - If `VersionLimit` is `0`, then no versions are created. Modified files are simply copied over.
    - Using with `Destructive` results in all versions being deleted.
- __Remotions__:
  - If a file "`filename.ext`" is marked as removed, it's named "`filename _removeIn[r].ext`", where `r` can range from `RemotionCountdown` to `0`.
    - All of its versions are also marked: "`filename _version[v] _removeIn[r].ext`".
    - Everytime the script is run, the number decreases. If its `0`, then it's permanently deleted.
  - If a folder "`foldername`" is marked as removed, it's named "`foldername _removeIfEmpty`".
    - When all of its content are deleted and the folder is empty, then it's permanently deleted.
  - If `Destructive` is marked, then all remotions that happen to be above `RemotionCountdown` are decreased to fit within the limit.
  - If `RemotionCountdown` is `0`, then no remotions are created. Deleted files are simply deleted.
    - Using with `Destructive` results in all remotions being deleted.
- __Note__:
  - All files on origin-folder that contains "`..._version[...]...`", "`..._removeIn[...]...`" are ignored.
    - All folders that contains "`..._removeIfEmpty...`" are also ignored.
  - Files that begin with a "`.`" are understood as a extension without a name: "`.filename`" results into versions named "` _version[v].filename`".
  - The space before the mark is optional: "`filename _version[v].ext`"(With space) is the same as "`filename_version[v].ext`"(No space).
  - Versions and remotions can be manually renamed, respecting the `1-99999` and `0-99999` ranges.
- __Caveats__:
  - Newly created folders with no files are not listed, but are still copied over.
  - Before processing files, it needs _Robocopy_ to list them all. That can be a little slow.
    - During the listing process, a file will be temporarily created on the target-folder. That's the only way for _Robocopy_ to list files with special characters on it's name.

## In Practice
| "D:\myFolder" | Command | "M:\myBackup" |
| --- | --- | --- |
| _myFile.ext_ ("A") | `Roboversion "D:\myFolder" "M:\myBackup" -V 4`<br/>(To create a inicial copy, same as _Robocopy_) | _myFile.ext_ ("A") |
| _myFile.ext_ ("B") | `Roboversion "D:\myFolder" "M:\myBackup" -V 4`<br/>(Here, it creates a version) | _myFile.ext_ ("B")<br/>_myFile \_version[1].ext_ ("A") |
| _myFile.ext_ ("C") | `Roboversion "D:\myFolder" "M:\myBackup" -V 4`<br/>(Another version) | _myFile.ext_ ("C")<br/>_myFile \_version[2].ext_ ("B")<br/>_myFile \_version[1].ext_ ("A") |
| _myFile.ext_ ("D") | `Roboversion "D:\myFolder" "M:\myBackup" -V 4` | _myFile.ext_ ("D")<br/>_myFile \_version[3].ext_ ("C")<br/>_myFile \_version[2].ext_ ("B")<br/>_myFile \_version[1].ext_ ("A") |
| _myFile.ext_ ("E") | `Roboversion "D:\myFolder" "M:\myBackup" -V 4` | _myFile.ext_ ("E")<br/>_myFile \_version[4].ext_ ("D")<br/>_myFile \_version[3].ext_ ("C")<br/>_myFile \_version[2].ext_ ("B")<br/>_myFile \_version[1].ext_ ("A") |
| _myFile.ext_ ("F") | `Roboversion "D:\myFolder" "M:\myBackup" -V 4`<br/>(Now, any new versions causes the oldest one to be replaced) | _myFile.ext_ ("F")<br/>_myFile \_version[4].ext_ ("E")<br/>_myFile \_version[3].ext_ ("D")<br/>_myFile \_version[2].ext_ ("C")<br/>_myFile \_version[1].ext_ ("B") |
| _myFile.ext_ ("G") | `Roboversion "D:\myFolder" "M:\myBackup" -V 4` | _myFile.ext_ ("G")<br/>_myFile \_version[4].ext_ ("F")<br/>_myFile \_version[3].ext_ ("E")<br/>_myFile \_version[2].ext_ ("D")<br/>_myFile \_version[1].ext_ ("C") |
| _myFile.ext_ ("H") | `Roboversion "D:\myFolder" "M:\myBackup" -V 2 -D`<br/>(Too many versions! Only two is good) | _myFile.ext_ ("H")<br/>_myFile \_version[2].ext_ ("G")<br/>_myFile \_version[1].ext_ ("F") |
| _myFile.ext_ ("I") | `Roboversion "D:\myFolder" "M:\myBackup" -V 2`<br/>(Using `2` instead of `4` now) | _myFile.ext_ ("I")<br/>_myFile \_version[2].ext_ ("H")<br/>_myFile \_version[1].ext_ ("G") |
| | `Roboversion "D:\myFolder" "M:\myBackup" -V 2 -R 30`<br/>(To reflect the deleted file) | _myFile \_removeIn[30].ext_ ("I")<br/>_myFile \_version[2] \_removeIn[30].ext_ ("H")<br/>_myFile \_version[1] \_removeIn[30].ext_ ("G") |
| | `Roboversion "D:\myFolder" "M:\myBackup" -V 2 -R 30`<br/>(Running now, it only decreases the countdown) | _myFile \_removeIn[29].ext_ ("I")<br/>_myFile \_version[2] \_removeIn[29].ext_ ("H")<br/>_myFile \_version[1] \_removeIn[29].ext_ ("G") |
| | `Roboversion "D:\myFolder" "M:\myBackup" -V 2 -R 30` | _myFile \_removeIn[28].ext_ ("I")<br/>_myFile \_version[2] \_removeIn[28].ext_ ("H")<br/>_myFile \_version[1] \_removeIn[28].ext_ ("G") |
| | `Roboversion "D:\myFolder" "M:\myBackup" -V 2 -R 1 -D`<br/>(It's taking too long!) | _myFile \_removeIn[1].ext_ ("I")<br/>_myFile \_version[2] \_removeIn[1].ext_ ("H")<br/>_myFile \_version[1] \_removeIn[1].ext_ ("G") |
| | `Roboversion "D:\myFolder" "M:\myBackup" -V 2 -R 1` | _myFile \_removeIn[0].ext_ ("I")<br/>_myFile \_version[2] \_removeIn[0].ext_ ("H")<br/>_myFile \_version[1] \_removeIn[0].ext_ ("G") |
| | `Roboversion "D:\myFolder" "M:\myBackup" -V 2 -R 1`<br/>(With `0`, all remotions are deleted) | |

## Inner Workings

Everything is based around _Robocopy_:
- All versions and remotions present on the target-folder are listed with a _Robocopy_ command that only checks marked files.
  - Versions and remotions are renamed or deleted as needed.
  - (Unfortunadely, _Robocopy_ does not allow to filter folders. So, all folders have to be listed by it and filtered by _Roboversion_. This can be a little slow).
- All files to be modified are listed with another _Robocopy_ command that only lists differences.
  - New versions and remotions are created, renaming or deleting old ones as needed.
- Then a final _Robocopy_ does the mirroring.

It all happens in five stages: `UpdateVersioned`, `UpdateRemoved`, `UpdateToVersion`, `UpdateToRemove`, and `Mirror`.
## Dependecies

Developed using _Robocopy.exe_ and _PowerShell v5.1_.
