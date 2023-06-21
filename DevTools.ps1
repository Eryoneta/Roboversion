# . "./RoboVersion.ps1";

Function EchoFileMap($fileMap) {
	If(-Not $fileMap) {
		Return;
	}
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
	Echo ("TEST: 'GetFileMap': Um arquivo");
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[4] _removeIn[7].ext",
		"C:\Folder\SubFolder\File _version[2] _removeIn[5].ext",
		"C:\Folder\SubFolder\File _version[1] _removeIn[5].ext",
		"C:\Folder\SubFolder\File _version[2] _removeIn[3].ext",
		"C:\Folder\SubFolder\File _removeIn[5].ext",
		"C:\Folder\SubFolder\File _version[15].ext",
		"C:\Folder\SubFolder\File _version[12] _removeIn[3].ext",
		"C:\Folder\SubFolder\File _version[12] _removeIn[2].ext",
		"C:\Folder\SubFolder\File.ext";
	$orderedMap = GetFileMap $filePathList;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(4).Get(7)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(5)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(5)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(3)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(5)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(15).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(12).Get(3)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(12).Get(2)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(-1)) { $sucess = $False; }
	Echo ("FUNCIONA: " + $sucess);
	Echo ("TEST: 'GetFileMap': Vários arquivos");
	$filePathList = "",
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
		"C:\Folder\SubFolder\ _version[9].file5",
		"C:\Folder\SubFolder\ _version[3] _removeIn[1].file5",
		"C:\Folder\SubFolder\File6 _version[6] _removeIn[5].ext";
	$orderedMap = GetFileMap $filePathList;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File1.ext").Get(4).Get(7)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File1.ext").Get(2).Get(5)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File1.ext").Get(1).Get(5)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File1.ext").Get(-1).Get(5)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File1.ext").Get(1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File1.ext").Get(1).Get(3)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File1.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File2.ext").Get(1).Get(5)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File2.ext").Get(-1).Get(5)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File2.ext").Get(5).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File2.ext").Get(1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File2.ext").Get(3).Get(5)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File2.ext").Get(3).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File2.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File3.com.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File4").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\.file5").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\.file5").Get(9).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\.file5").Get(3).Get(1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File6.ext").Get(6).Get(5)) { $sucess = $False; }
	Echo ("FUNCIONA: " + $sucess);
}
Function Test_UpdateVersioned() {
	# Ex.: Dest(F_v1(A), F_v2(B), F_v3(C), F_v4(D), F_v5(E))              --($maxVersionLimit=3)--> Dest(F_v1(A), F_v2(B), F_v3(C), F_v4(D), F_v5(E))
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[3].ext",
		"C:\Folder\SubFolder\File _version[4].ext",
		"C:\Folder\SubFolder\File _version[5].ext";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateVersioned $orderedMap 3 $False $True
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(4).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(5).Get(-1)) { $sucess = $False; }
	Echo ("FUNCIONA: " + $sucess);
	# Ex.: Dest(F_v1(A), F_v2(B), F_v3(C), F_v4(D), F_v5(E))              --($maxVersionLimit=3,$destructive)--> Dest(F_v1(C), F_v2(D), F_v3(E))
	# Ex.: Dest(F_v10(A), F_v12(B), F_v23(C))                             --($maxVersionLimit=3,$destructive)--> Dest(F_v1(A), F_v2(B), F_v3(C))
	# Ex.: Dest(F_v1(A), F_v2(B))                                         --($maxVersionLimit=3,$destructive)--> Dest(F_v1(A), F_v2(B))
	# Ex.: Dest(F_v1(A), F_v2(B), F_v27(Y), F_v34(Z))                     --($maxVersionLimit=5,$destructive)--> Dest(F_v1(A), F_v2(B), F_v4(Y), F_v5(Z))
	# Ex.: Dest(F_v1(A), F_v2(B), F_v19(W), F_v25(X), F_v27(Y), F_v34(Z)) --($maxVersionLimit=5,$destructive)--> Dest(F_v1(A), F_v2(W), F_v3(X), F_v4(Y), F_v5(Z))
	# Ex.: Dest(F_v27(Y), F_v34(Z))                                       --($maxVersionLimit=5,$destructive)--> Dest(F_v4(Y), F_v5(Z))
	# Ex.: Dest(F_v9_r3(Y), F_v9_r1(Z))                                   --($maxVersionLimit=3,$destructive)--> Dest(F_v3_r3(Y), F_v3_r1(Z))
	# Ex.: Dest(F_v12_r39(A), F_v15_r45(B))                               --($maxVersionLimit=3,$destructive)--> Dest(F_v2_r39(A), F_v3_r45(B))
	# Ex.: Dest(F(A), F_v4(B), F_v5(C), F_v6(D), F_v7(E))                 --($maxVersionLimit=3,$destructive)--> Dest(F(B), F_v1(C), F_v2(D), F_v3(D))
}
Function Test_UpdateRemoved() {
	# Ex.: Dest(F_r0(A), F_r1(B), F_r3(C), F_r5(D))             --($remotionCountdown=5)-->              Dest(F_r0(B), F_r2(C), F_r4(D))
	# Ex.: Dest(F_r1(A), F_r8(Y), F_r9(Z))                      --($remotionCountdown=5)-->              Dest(F_r0(A), F_r7(Y), F_r8(Z))
	# Ex.: Dest(F_r1(A), F_r8(Y), F_r9(Z))                      --($remotionCountdown=5,$destructive)--> Dest(F_r0(A), F_r4(Y), F_r5(Z))
	# Ex.: Dest(F_r1(A), F_r4(B), F_r5(C), F_r8(Y), F_r9(Z))    --($remotionCountdown=5,$destructive)--> Dest(F_r0(A), F_r2(B), F_r3(C), F_r4(Y), F_r5(Z))
	# Ex.: Dest(F_r1(A), F_r4(B), F_r5(C), F_r8(Y), F_r9(Z))    --($remotionCountdown=3,$destructive)--> Dest(F_r3(C), F_r4(Y), F_r5(Z))
	# Ex.: Dest(F_v1_r2(A), F_v1_r9(Z), F_v2_r2(B), F_v2_r8(Y)) --($remotionCountdown=3,$destructive)--> Dest(F_v1_r1(A), F_v1_r3(Z), F_v2_r1(B), F_v2_r3(Y))
}
Function Test_UpdateModified() {
	#TODO
}
Function Test_UpdateToVersion() {
	#TODO
}
Function Test_UpdateToRemove() {
	#TODO
}
Function Test_UpdateToModify() {
	#TODO
}
