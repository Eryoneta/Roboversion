﻿# . "./RoboVersion.ps1";

Function EchoFileMap($fileMap) {
	ForEach($nameKey In $fileMap.List()) {
		Echo ("--> BASENAME: " + $nameKey);
		ForEach($versionKey In $fileMap.Get($nameKey).List()) {
			Echo ("----> VERSION: " + $versionKey);
			ForEach($remotionKey In $fileMap.Get($nameKey).Get($versionKey).List()) {
				Echo ("------> REMOTION: " + $remotionKey);
				Echo $fileMap.Get($nameKey).Get($versionKey).Get($remotionKey);
			}
		}
	}
}
Function Test_GetFileMap() {
	$filePathList1 = "",
		"C:\Folder\SubFolder\File1 _version[4] _removeIn[7].ext",
		"C:\Folder\SubFolder\File1 _version[2] _removeIn[5].ext",
		"C:\Folder\SubFolder\File1 _version[1] _removeIn[5].ext",
		"C:\Folder\SubFolder\File1 _removeIn[5].ext",
		"C:\Folder\SubFolder\File1 _version[1].ext",
		"C:\Folder\SubFolder\File1 _version[1] _removeIn[3].ext",
		"C:\Folder\SubFolder\File1.ext",
		"C:\Folder\SubFolder\File2 _version[1] _removeIn[5].ext",
		"C:\Folder\SubFolder\File2 _removeIn[5].ext",
		"C:\Folder\SubFolder\File2 _version[5].ext",
		"C:\Folder\SubFolder\File2 _version[1].ext",
		"C:\Folder\SubFolder\File2 _version[3] _removeIn[5].ext",
		"C:\Folder\SubFolder\File2 _version[3].ext",
		"C:\Folder\SubFolder\File2.ext",
		"C:\Folder\SubFolder\File3.com.ext",
		"C:\Folder\SubFolder\File4",
		"C:\Folder\SubFolder\.file5",
		"C:\Folder\SubFolder\File6 _version[6] _removeIn[5].ext";
	$filePathList2 = "",
		"C:\Folder\SubFolder\File1 _version[4] _removeIn[7].ext",
		"C:\Folder\SubFolder\File1 _version[2] _removeIn[5].ext",
		"C:\Folder\SubFolder\File1 _version[1] _removeIn[5].ext",
		"C:\Folder\SubFolder\File1 _version[2] _removeIn[3].ext",
		"C:\Folder\SubFolder\File1 _removeIn[5].ext",
		"C:\Folder\SubFolder\File1 _version[15].ext",
		"C:\Folder\SubFolder\File1 _version[12] _removeIn[3].ext",
		"C:\Folder\SubFolder\File1 _version[12] _removeIn[2].ext",
		"C:\Folder\SubFolder\File1.ext";
	$orderedMap = GetFileMap $filePathList2;
	EchoFileMap $orderedMap;
}
