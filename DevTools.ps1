# . "./RoboVersion.ps1";

Function EchoFileMap($fileMap) {
	If(-Not $fileMap) {
		Return;
	}
	ForEach($nameKey In $fileMap.List()) {
		PrintText ("--> BASENAME: " + $nameKey);
		ForEach($versionKey In $fileMap.Get($nameKey).List()) {
			PrintText ("----> VERSION: " + $versionKey);
			ForEach($remotionKey In $fileMap.Get($nameKey).Get($versionKey).List()) {
				PrintText ("------> REMOTION: " + $remotionKey);
				PrintText (Out-String -InputObject $fileMap.Get($nameKey).Get($versionKey).Get($remotionKey)).trim();
			}
		}
	}
}
Function Test_GetFileMap() {
	$sucessAll = $True;
	PrintText ("TEST: 'GetFileMap': Um arquivo");
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[4] _removeIn[7].ext",
		"C:\Folder\SubFolder\File _version[2] _removeIn[5].ext",
		"C:\Folder\SubFolder\File _version[1] _removeIn[5].ext",
		"C:\Folder\SubFolder\File _version[2] _removeIn[3].ext",
		"C:\Folder\SubFolder\File _removeIn[5].ext",
		"C:\Folder\SubFolder\File _version[15].ext",
		"C:\Folder\SubFolder\File _version[12] _removeIn[3].ext",
		"C:\Folder\SubFolder\File _version[12] _removeIn[2].ext",
		"C:\Folder\SubFolder\File.ext",
		"";
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
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: 'GetFileMap': Vários arquivos");
	$filePathList = "",
		"C:\Folder\SubFolder\File1 _version[4] _removeIn[7].ext",
		"C:\Folder\SubFolder\File1 _version[2] _removeIn[5].ext",
		"C:\Folder\SubFolder\File1 _version[1] _removeIn[5].ext",
		"C:\Folder\SubFolder\File1 _removeIn[5].ext",
		"C:\Folder\SubFolder\File1 _version[1].ext",
		"C:\Folder\SubFolder\File1 _version[1] _removeIn[3].ext",
		"C:\Folder\SubFolder\File1.ext",
		"C:\Folder\SubFolder\File2 _version[1] _removeIn[5].ext",
		"C:\Folder\SubFolder\File2 _removeIn[5].ext",
		"C:\Folder\SubFolder\File2 _version[5].ext",
		"C:\Folder\SubFolder\File2 _version[1].ext",
		"C:\Folder\SubFolder\File2 _version[3] _removeIn[5].ext",
		"C:\Folder\SubFolder\File2 _version[3].ext",
		"C:\Folder\SubFolder\File2.ext",
		"C:\Folder\SubFolder\File3.com.ext",
		"C:\Folder\SubFolder\File4",
		"C:\Folder\SubFolder\.file5",
		"C:\Folder\SubFolder\_version[9].file5",
		"C:\Folder\SubFolder\_version[3] _removeIn[1].file5",
		"C:\Folder\SubFolder\File6 _version[6] _removeIn[5].ext",
		"";
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
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	Return $sucessAll;
}
Function Test_UpdateVersioned() {
	$sucessAll = $True;
	PrintText ('TEST: Dest(F_v1(A), F_v2(B), F_v3(C), F_v4(D), F_v5(E)) --($maxVersionLimit=3)--> Dest(F_v1(A), F_v2(B), F_v3(C), F_v4(D), F_v5(E))');
	PrintText ("'UpdateVersioned /V=3 /L': Sem Destructive, não deve fazer nada");
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[3].ext",
		"C:\Folder\SubFolder\File _version[4].ext",
		"C:\Folder\SubFolder\File _version[5].ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateVersioned $orderedMap 3 $False $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(4).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(5).Get(-1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Dest(F_v1(A), F_v2(B)) --($maxVersionLimit=3,$destructive)--> Dest(F_v1(A), F_v2(B))');
	PrintText ("'UpdateVersioned /V=3 /L': Com Destructive, não deve fazer nada se menores que 3");
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[3].ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateVersioned $orderedMap 3 $False $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(-1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Dest(F_v10(A), F_v12(B), F_v23(C)) --($maxVersionLimit=3,$destructive)--> Dest(F_v1(A), F_v2(B), F_v3(C))');
	PrintText ("'UpdateVersioned /V=3 /D /L': Com Destructive, os maiores que 3 devem ser diminuidos");
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[10].ext",
		"C:\Folder\SubFolder\File _version[12].ext",
		"C:\Folder\SubFolder\File _version[23].ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateVersioned $orderedMap 3 $True $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(10).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(12).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(23).Get(-1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Dest(F_v1(A), F_v2(B), F_v3(C), F_v4(D), F_v5(E)) --($maxVersionLimit=3,$destructive)--> Dest(F_v1(C), F_v2(D), F_v3(E))');
	PrintText ("'UpdateVersioned /V=3 /D /L': Com Destructive, devem sobrar apenas 3 versões no máximo");
	PrintText ("(v1 e v2 são deletados, e v3, v4, e v5 se tornam os novos v1, v2, e v3)");
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[3].ext",
		"C:\Folder\SubFolder\File _version[4].ext",
		"C:\Folder\SubFolder\File _version[5].ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateVersioned $orderedMap 3 $True $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(4).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(5).Get(-1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Dest(F_v1(A), F_v2(B), F_v27(Y), F_v34(Z)) --($maxVersionLimit=5,$destructive)--> Dest(F_v1(A), F_v2(B), F_v4(Y), F_v5(Z))');
	PrintText ("'UpdateVersioned /V=5 /D /L': Com Destructive, os maiores que 5 devem ser diminuidos, mas aqui não afetam os menores");
	PrintText ("(v27 e v34 se tornam v4 e v5)");
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[27].ext",
		"C:\Folder\SubFolder\File _version[34].ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateVersioned $orderedMap 5 $True $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(4).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(5).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(27).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(34).Get(-1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Dest(F_v1(A), F_v2(B), F_v19(W), F_v25(X), F_v27(Y), F_v34(Z)) --($maxVersionLimit=5,$destructive)--> Dest(F_v1(B), F_v2(W), F_v3(X), F_v4(Y), F_v5(Z))');
	PrintText ("'UpdateVersioned /V=5 /D /L': Com Destructive, os maiores que 5 devem ser diminuidos, mas apagando os menores");
	PrintText ("(v2, v19, v25, v27, e v34 se tornam v1, v2, v3, v4, e v5)");
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[19].ext",
		"C:\Folder\SubFolder\File _version[25].ext",
		"C:\Folder\SubFolder\File _version[27].ext",
		"C:\Folder\SubFolder\File _version[34].ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateVersioned $orderedMap 5 $True $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(4).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(5).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(19).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(25).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(27).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(34).Get(-1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Dest(F_v27(Y), F_v34(Z)) --($maxVersionLimit=5,$destructive)--> Dest(F_v4(Y), F_v5(Z))');
	PrintText ("'UpdateVersioned /V=5 /D /L': Com Destructive, os maiores que 5 devem ser diminuidos, do maior ao menor");
	PrintText ("(v27 e v34 se tornam v4 e v5)");
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[27].ext",
		"C:\Folder\SubFolder\File _version[34].ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateVersioned $orderedMap 5 $True $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(4).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(5).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(27).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(34).Get(-1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Dest(F_v9_r3(Y), F_v9_r1(Z)) --($maxVersionLimit=3,$destructive)--> Dest(F_v3_r3(Y), F_v3_r1(Z))');
	PrintText ("'UpdateVersioned /V=3 /D /L': Com Destructive, os maiores que 3 devem ser diminuidos, sem afetar os removidos");
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[9] _removeIn[3].ext",
		"C:\Folder\SubFolder\File _version[9] _removeIn[1].ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateVersioned $orderedMap 3 $True $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(3)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(9).Get(3)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(9).Get(1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Dest(F_v4(A), F_v5(B), F_v6(C), F_v7(D), F(E)) --($maxVersionLimit=3,$destructive)--> Dest(F_v1(B), F_v2(C), F_v3(D), F(E))');
	PrintText ("'UpdateVersioned /V=3 /D /L': Com Destructive, o sem-versão também deve ser considerado");
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[4].ext",
		"C:\Folder\SubFolder\File _version[5].ext",
		"C:\Folder\SubFolder\File _version[6].ext",
		"C:\Folder\SubFolder\File _version[7].ext",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateVersioned $orderedMap 3 $True $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(4).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(5).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(6).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(7).Get(-1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Dest(F_v-3(A), F_v-2(B), F_v-1(C), F_vA(1), F_vB(2), F_v1(D)) --($maxVersionLimit=3,$destructive)--> Dest(F_v1(D))');
	PrintText ("'UpdateVersioned /V=3 /D /L': Os negativos e letras são ignorados(São parte do nome!)");
	PrintText ("(Estes são ignorados durante o mirror, se tornando arquivos-fantasmas)");
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[-3].ext",
		"C:\Folder\SubFolder\File _version[-2].ext",
		"C:\Folder\SubFolder\File _version[-1].ext",
		"C:\Folder\SubFolder\File _version[A].ext",
		"C:\Folder\SubFolder\File _version[B].ext",
		"C:\Folder\SubFolder\File _version[1].ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateVersioned $orderedMap 3 $True $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File _version[-3].ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File _version[-2].ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File _version[-1].ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File _version[A].ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File _version[B].ext").Get(-1).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-3).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-2).Get(-1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Dest(F1_v4(A), F1_v5(B), F2_v4(1), F2_v5(2)) --($maxVersionLimit=3,$destructive)--> Dest(F1_v2(A), F1_v3(B), F2_v2(1), F2_v3(2))');
	PrintText ("'UpdateVersioned /V=3 /D /L': Com Destructive, não deve haver conflito entre versões de diferentes arquivos");
	$filePathList = "",
		"C:\Folder\SubFolder\File1 _version[4].ext",
		"C:\Folder\SubFolder\File1 _version[5].ext",
		"C:\Folder\SubFolder\File2 _version[4].ext",
		"C:\Folder\SubFolder\File2 _version[5].ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateVersioned $orderedMap 3 $True $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File1.ext").Get(2).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File1.ext").Get(3).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File2.ext").Get(2).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File2.ext").Get(3).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File1.ext").Get(4).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File1.ext").Get(5).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File2.ext").Get(4).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File2.ext").Get(5).Get(-1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Dest(F_v2(A), F_v6(B), F_v7(C), F(D)) --($maxVersionLimit=0,$destructive)--> Dest(F(D))');
	PrintText ("'UpdateVersioned /V=0 /D /L': Com Destructive, deve deletar todas as versões");
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[6].ext",
		"C:\Folder\SubFolder\File _version[7].ext",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateVersioned $orderedMap 0 $True $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File1.ext").Get(2).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File1.ext").Get(6).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File2.ext").Get(7).Get(-1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Dest(F_v2(A), F_v6(B), F_v7(C), F(D)) --($maxVersionLimit=1,$destructive)--> Dest(F(D), F_v1(C))');
	PrintText ("'UpdateVersioned /V=1 /D /L': Com Destructive, deve manter apenas 1 versão");
	PrintText ("(v7 se torna v1)");
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[6].ext",
		"C:\Folder\SubFolder\File _version[7].ext",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateVersioned $orderedMap 1 $True $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File1.ext").Get(2).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File1.ext").Get(6).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File2.ext").Get(7).Get(-1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	Return $sucessAll;
}
Function Test_UpdateRemoved() {
	$sucessAll = $True;
	PrintText ('TEST: Dest(F_r0(A), F_r1(B), F_r3(C), F_r5(D)) --($remotionCountdown=3)--> Dest(F_r0(B), F_r2(C), F_r4(D))');
	PrintText ("'UpdateRemoved /R=3 /L': Sem Destructive, deve apenas diminuir o countdown");
	PrintText ("(O r0 é deletado e todos os outros recebem countdown - 1)");
	$filePathList = "",
		"C:\Folder\SubFolder\File _removeIn[0].ext",
		"C:\Folder\SubFolder\File _removeIn[1].ext",
		"C:\Folder\SubFolder\File _removeIn[3].ext",
		"C:\Folder\SubFolder\File _removeIn[5].ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateRemoved $orderedMap 3 $False $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(0)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(2)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(4)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(3)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(5)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Dest(F_r1(A), F_r8(Y), F_r9(Z)) --($remotionCountdown=3,$destructive)--> Dest(F_r0(A), F_r4(Y), F_r5(Z))');
	PrintText ("'UpdateRemoved /R=3 /D /L': Com Destructive, os maiores que 3 devem ser diminuidos");
	$filePathList = "",
		"C:\Folder\SubFolder\File _removeIn[1].ext",
		"C:\Folder\SubFolder\File _removeIn[8].ext",
		"C:\Folder\SubFolder\File _removeIn[9].ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateRemoved $orderedMap 3 $True $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(0)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(2)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(3)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(8)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(9)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Dest(F_r3(Y),F_r4(Z)) --($remotionCountdown=3,$destructive)--> Dest(F_r2(Y), F_r3(Z))');
	PrintText ("'UpdateRemoved /R=3 /D /L': Com Destructive, o 3 deve ser diminuido normalmente");
	$filePathList = "",
		"C:\Folder\SubFolder\File _removeIn[3].ext",
		"C:\Folder\SubFolder\File _removeIn[4].ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateRemoved $orderedMap 3 $True $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(2)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(3)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(4)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Dest(F_r1(A), F_r4(W), F_r5(X), F_r8(Y), F_r9(Z)) --($remotionCountdown=3,$destructive)--> Dest(F_r0(W), F_r1(X), F_r2(Y), F_r3(Z))');
	PrintText ("'UpdateRemoved /R=3 /D /L': Com Destructive, os maiores que 3 devem ser diminuidos, apagando os menores");
	$filePathList = "",
		"C:\Folder\SubFolder\File _removeIn[1].ext",
		"C:\Folder\SubFolder\File _removeIn[4].ext",
		"C:\Folder\SubFolder\File _removeIn[5].ext",
		"C:\Folder\SubFolder\File _removeIn[8].ext",
		"C:\Folder\SubFolder\File _removeIn[9].ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateRemoved $orderedMap 3 $True $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(0)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(2)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(3)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(4)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(5)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(8)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(9)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Dest(F_v1_r2(A), F_v1_r9(Z), F_v2_r2(1), F_v2_r9(10)) --($remotionCountdown=3,$destructive)--> Dest(F_v1_r1(A), F_v1_r3(Z), F_v2_r1(1), F_v2_r3(10))');
	PrintText ("'UpdateRemoved /R=3 /D /L': Com Destructive, as diferentes versões não devem entrar em conflito");
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[1] _removeIn[2].ext",
		"C:\Folder\SubFolder\File _version[1] _removeIn[9].ext",
		"C:\Folder\SubFolder\File _version[2] _removeIn[2].ext",
		"C:\Folder\SubFolder\File _version[2] _removeIn[9].ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateRemoved $orderedMap 3 $True $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(3)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(3)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(2)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(9)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(2)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(9)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Dest(F_r2(A), F_r9(B), F_r12(C), F(D)) --($remotionCountdown=0,$destructive)--> Dest(F(D)))');
	PrintText ("'UpdateRemoved /R=0 /D /L': Com Destructive, todos os removidos devem ser deletados");
	$filePathList = "",
		"C:\Folder\SubFolder\File _removeIn[2].ext",
		"C:\Folder\SubFolder\File _removeIn[9].ext",
		"C:\Folder\SubFolder\File _removeIn[12].ext",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateRemoved $orderedMap 0 $True $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(2)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(9)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(12)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Dest(F_r2(A), F_r9(B), F_r12(C), F(D)) --($remotionCountdown=1,$destructive)--> Dest(F_r0(B), F_r1(C), F(D)))');
	PrintText ("'UpdateRemoved /R=1 /D /L': Com Destructive, deve manter apenas os removidos 0 e 1");
	$filePathList = "",
		"C:\Folder\SubFolder\File _removeIn[2].ext",
		"C:\Folder\SubFolder\File _removeIn[9].ext",
		"C:\Folder\SubFolder\File _removeIn[12].ext",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateRemoved $orderedMap 1 $True $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(0)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(2)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(9)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(12)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	Return $sucessAll;
}
Function Test_UpdateModified() {
	$sucessAll = $True;
	PrintText ('TEST: Dest(F_v1_r2(A), F_v1_r9(Z), F_v2_r2(1), F_v2_r9(10)) --($maxVersionLimit=3,$remotionCountdown=5,$destructive)--> Dest(F_v1_r1(A), F_v1_r8(Z), F_v2_r1(1), F_v2_r8(10))');
	PrintText ("'UpdateModified /V=3 /R=5 /L': Sem Destructive, as diferentes versões não devem entrar em conflito");
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[1] _removeIn[2].ext",
		"C:\Folder\SubFolder\File _version[1] _removeIn[9].ext",
		"C:\Folder\SubFolder\File _version[2] _removeIn[2].ext",
		"C:\Folder\SubFolder\File _version[2] _removeIn[9].ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateVersioned $orderedMap 3 $False $True;
	$orderedMap = UpdateRemoved $orderedMap 5 $False $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(8)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(8)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(2)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(9)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(2)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(9)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Dest(F_v1_r2(A), F_v1_r9(Z), F_v6_r2(1), F_v6_r9(10)) --($maxVersionLimit=3,$remotionCountdown=5,$destructive)--> Dest(F_v1_r1(A), F_v1_r5(Z), F_v3_r1(1), F_v3_r5(10))');
	PrintText ("'UpdateModified /V=3 /R=5 /D /L': Com Destructive, as diferentes versões não devem entrar em conflito");
	PrintText ("(Os v6 se tornam v3, e os r9 se tornam r5)");
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[1] _removeIn[2].ext",
		"C:\Folder\SubFolder\File _version[1] _removeIn[9].ext",
		"C:\Folder\SubFolder\File _version[6] _removeIn[2].ext",
		"C:\Folder\SubFolder\File _version[6] _removeIn[9].ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateVersioned $orderedMap 3 $True $True;
	$orderedMap = UpdateRemoved $orderedMap 5 $True $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(5)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(5)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(2)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(9)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(6).Get(2)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(6).Get(9)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	Return $sucessAll;
}
Function Test_UpdateToVersion() {
	$sucessAll = $True;
	PrintText ('TEST: Orig(F(4))->Dest(F_v1(1), F_v2(2), F(3)) --($maxVersionLimit=3)--> Dest(F_v1(1), F_v2(2), F_v3(3), F(3))');
	PrintText ("'UpdateToVersion /V=3 /L': Deve criar uma nova versão");
	$filePathListToModify = "",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMapToModify = GetFileMap $filePathListToModify;
	$toModifyList = [System.Collections.ArrayList]::new();
	ForEach($nameKey In $orderedMapToModify.List()) {
		$toModifyFile = $orderedMapToModify.Get($nameKey).Get(-1).Get(-1);
		$Null = $toModifyList.Add($toModifyFile);
	}
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateToVersion $orderedMap $toModifyList 3 $True;
	EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(-1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Orig(F(5))->Dest(F_v1(1), F_v2(2), F_v3(3), F(4)) --($maxVersionLimit=3)--> Dest(F_v1(2), F_v2(3), F_v3(4), F(4))');
	PrintText ("'UpdateToVersion /V=3 /L': Deve criar uma nova versão, mudando a versão de todas as outras e deletando a v0");
	PrintText ("(v1 é deletada, v2 se torna v1, v3 se torna v2, e F é copiado para v3)");
	$filePathListToModify = "",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMapToModify = GetFileMap $filePathListToModify;
	$toModifyList = [System.Collections.ArrayList]::new();
	ForEach($nameKey In $orderedMapToModify.List()) {
		$toModifyFile = $orderedMapToModify.Get($nameKey).Get(-1).Get(-1);
		$Null = $toModifyList.Add($toModifyFile);
	}
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[3].ext",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateToVersion $orderedMap $toModifyList 3 $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(4).Get(-1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Orig(F(5))->Dest(F_v1(1), F(4)) --($maxVersionLimit=3)--> Dest(F_v1(1), F_v2(4), F(4))');
	PrintText ("'UpdateToVersion /V=3 /L': Deve criar uma nova versão 2");
	PrintText ("(F é copiado para v2)");
	$filePathListToModify = "",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMapToModify = GetFileMap $filePathListToModify;
	$toModifyList = [System.Collections.ArrayList]::new();
	ForEach($nameKey In $orderedMapToModify.List()) {
		$toModifyFile = $orderedMapToModify.Get($nameKey).Get(-1).Get(-1);
		$Null = $toModifyList.Add($toModifyFile);
	}
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateToVersion $orderedMap $toModifyList 3 $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(-1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Orig(F(5))->Dest(F_v3(1), F(4)) --($maxVersionLimit=3)--> Dest(F_v2(1), F_v3(4), F(4))');
	PrintText ("'UpdateToVersion /V=3 /L': Deve criar uma nova versão 3, mudando a versão do outro");
	PrintText ("(F é copiado para v2)");
	$filePathListToModify = "",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMapToModify = GetFileMap $filePathListToModify;
	$toModifyList = [System.Collections.ArrayList]::new();
	ForEach($nameKey In $orderedMapToModify.List()) {
		$toModifyFile = $orderedMapToModify.Get($nameKey).Get(-1).Get(-1);
		$Null = $toModifyList.Add($toModifyFile);
	}
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[3].ext",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateToVersion $orderedMap $toModifyList 3 $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(-1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Orig(F(5))->Dest(F_v3(1), F(4)) --($maxVersionLimit=0)--> Dest(F_v3(4), F(4))');
	PrintText ("'UpdateToVersion /V=0 /L': Com valor 0, não deve fazer nada");
	$filePathListToModify = "",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMapToModify = GetFileMap $filePathListToModify;
	$toModifyList = [System.Collections.ArrayList]::new();
	ForEach($nameKey In $orderedMapToModify.List()) {
		$toModifyFile = $orderedMapToModify.Get($nameKey).Get(-1).Get(-1);
		$Null = $toModifyList.Add($toModifyFile);
	}
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[3].ext",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateToVersion $orderedMap $toModifyList 0 $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(-1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Orig(F(5))->Dest(F_v3(1), F(4)) --($maxVersionLimit=1)--> Dest(F_v3(4), F_v1(4), F(4))');
	PrintText ("'UpdateToVersion /V=01 /L': Com valor 1, não deve fazer nada");
	$filePathListToModify = "",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMapToModify = GetFileMap $filePathListToModify;
	$toModifyList = [System.Collections.ArrayList]::new();
	ForEach($nameKey In $orderedMapToModify.List()) {
		$toModifyFile = $orderedMapToModify.Get($nameKey).Get(-1).Get(-1);
		$Null = $toModifyList.Add($toModifyFile);
	}
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[3].ext",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateToVersion $orderedMap $toModifyList 1 $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(-1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	Return $sucessAll;
}
Function Test_UpdateToRemove() {
	$sucessAll = $True;
	PrintText ('TEST: Orig()->Dest(F_v3(3), F(4)) --($remotionCountdown=3)--> Dest(F_v3_r3(3), F_r3(4), F(4))');
	PrintText ("'UpdateToRemove /R=3 /L': Deve criar uma nova remoção 3, renomeando todas as versões e copiando o arquivo");
	PrintText ("(v3 se torna v3_r3 e F é copiado para r3)");
	$filePathListToModify = "",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMapToModify = GetFileMap $filePathListToModify;
	$toModifyList = [System.Collections.ArrayList]::new();
	ForEach($nameKey In $orderedMapToModify.List()) {
		$toModifyFile = $orderedMapToModify.Get($nameKey).Get(-1).Get(-1);
		$Null = $toModifyList.Add($toModifyFile);
	}
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[3].ext",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateToRemove $orderedMap $toModifyList 3 $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(3)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(3)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(-1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Orig()->Dest(F_v3_r2(3), F_r2(4), F(5)) --($remotionCountdown=3)--> Dest(F_v3_r2(3), F_r2(4), F_r3(5), F(5))');
	PrintText ("'UpdateToRemove /R=3 /L': Deve criar uma nova remoção 3, sem afetar os outros removidos");
	$filePathListToModify = "",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMapToModify = GetFileMap $filePathListToModify;
	$toModifyList = [System.Collections.ArrayList]::new();
	ForEach($nameKey In $orderedMapToModify.List()) {
		$toModifyFile = $orderedMapToModify.Get($nameKey).Get(-1).Get(-1);
		$Null = $toModifyList.Add($toModifyFile);
	}
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[3] _removeIn[2].ext",
		"C:\Folder\SubFolder\File _removeIn[2].ext",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateToRemove $orderedMap $toModifyList 3 $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(2)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(2)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(3)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Orig()->Dest(F_v3_r3(3), F_r3(4), F(5)) --($remotionCountdown=3)--> Dest(F_v3_r2(3), F_r2(4), F_r3(5), F(5))');
	PrintText ("'UpdateToRemove /R=3 /L': Deve criar uma nova remoção 3, e renomear os outros para remoção 2, se tiverem remoção 3");
	$filePathListToModify = "",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMapToModify = GetFileMap $filePathListToModify;
	$toModifyList = [System.Collections.ArrayList]::new();
	ForEach($nameKey In $orderedMapToModify.List()) {
		$toModifyFile = $orderedMapToModify.Get($nameKey).Get(-1).Get(-1);
		$Null = $toModifyList.Add($toModifyFile);
	}
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[3] _removeIn[3].ext",
		"C:\Folder\SubFolder\File _removeIn[3].ext",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateToRemove $orderedMap $toModifyList 3 $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(2)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(2)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(3)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(3)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Orig()->Dest(F(5)) --($remotionCountdown=0)--> Dest(F(5))');
	PrintText ("'UpdateToRemove /R=0 /L': Com 0, não deve fazer nada");
	$filePathListToModify = "",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMapToModify = GetFileMap $filePathListToModify;
	$toModifyList = [System.Collections.ArrayList]::new();
	ForEach($nameKey In $orderedMapToModify.List()) {
		$toModifyFile = $orderedMapToModify.Get($nameKey).Get(-1).Get(-1);
		$Null = $toModifyList.Add($toModifyFile);
	}
	$filePathList = "",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateToRemove $orderedMap $toModifyList 0 $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(0)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Orig()->Dest(F(5)) --($remotionCountdown=1)--> Dest(F_r1(5), F(5))');
	PrintText ("'UpdateToRemove /R=1 /L': Com 1, deve criar uma remoção 1");
	$filePathListToModify = "",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMapToModify = GetFileMap $filePathListToModify;
	$toModifyList = [System.Collections.ArrayList]::new();
	ForEach($nameKey In $orderedMapToModify.List()) {
		$toModifyFile = $orderedMapToModify.Get($nameKey).Get(-1).Get(-1);
		$Null = $toModifyList.Add($toModifyFile);
	}
	$filePathList = "",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateToRemove $orderedMap $toModifyList 1 $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(0)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	Return $sucessAll;
}
Function Test_UpdateToModify() {
	$sucessAll = $True;
	PrintText ('TEST: Orig(F1(B))->Dest(F1(A), F2(1)) --($maxVersionLimit=1,$remotionCountdown=1)--> Dest(F1_v1(A), F1(A), F2_r1(1), F2(1))');
	PrintText ("'UpdateToRemove /V=1 /R=1 /L': Deve criar uma versão e remoção");
	$filePathListToModify = "",
		"C:\Folder\SubFolder\File1.ext",
		"";
	$orderedMapToModify = GetFileMap $filePathListToModify;
	$toModifyList = [System.Collections.ArrayList]::new();
	ForEach($nameKey In $orderedMapToModify.List()) {
		$toModifyFile = $orderedMapToModify.Get($nameKey).Get(-1).Get(-1);
		$Null = $toModifyList.Add($toModifyFile);
	}
	$filePathListToRemove = "",
		"C:\Folder\SubFolder\File2.ext",
		"";
	$orderedMapToRemove = GetFileMap $filePathListToRemove;
	$toRemoveList = [System.Collections.ArrayList]::new();
	ForEach($nameKey In $orderedMapToRemove.List()) {
		$toRemoveFile = $orderedMapToRemove.Get($nameKey).Get(-1).Get(-1);
		$Null = $toRemoveList.Add($toRemoveFile);
	}
	$filePathList = "",
		"C:\Folder\SubFolder\File1.ext",
		"C:\Folder\SubFolder\File2.ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateToVersion $orderedMap $toModifyList 1 $True;
	$orderedMap = UpdateToRemove $orderedMap $toRemoveList 1 $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File1.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File2.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File1.ext").Get(1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File2.ext").Get(-1).Get(1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ('TEST: Orig(F(5))->Dest(F_v1_r1(1), F_v1(1), F_v2(3), F_v3(3), F(4)) --($maxVersionLimit=3,$remotionCountdown=5)--> Dest(F_v1(2), F_v2(3), F_v3(4), F(4))');
	PrintText ("'UpdateToRemove /V=3 /R=5 /L': Deve remover v1 e v1_r1");
	PrintText ("(v3 se torna v2, v2 se torna v1, e v1 é deletado, junto com v1_r1)");
	$filePathListToModify = "",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMapToModify = GetFileMap $filePathListToModify;
	$toModifyList = [System.Collections.ArrayList]::new();
	ForEach($nameKey In $orderedMapToModify.List()) {
		$toModifyFile = $orderedMapToModify.Get($nameKey).Get(-1).Get(-1);
		$Null = $toModifyList.Add($toModifyFile);
	}
	$filePathListToRemove = "",
		"";
	$orderedMapToRemove = GetFileMap $filePathListToRemove;
	$toRemoveList = [System.Collections.ArrayList]::new();
	ForEach($nameKey In $orderedMapToRemove.List()) {
		$toRemoveFile = $orderedMapToRemove.Get($nameKey).Get(-1).Get(-1);
		$Null = $toRemoveList.Add($toRemoveFile);
	}
	$filePathList = "",
		"C:\Folder\SubFolder\File _version[1] _removeIn[1].ext",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[3].ext",
		"C:\Folder\SubFolder\File.ext",
		"";
	$orderedMap = GetFileMap $filePathList;
	$orderedMap = UpdateToVersion $orderedMap $toModifyList 3 $True;
	$orderedMap = UpdateToRemove $orderedMap $toRemoveList 5 $True;
	# EchoFileMap $orderedMap;
	$sucess = $True;
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(-1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(2).Get(-1)) { $sucess = $False; }
	If(-Not $orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(3).Get(-1)) { $sucess = $False; }
	If($orderedMap.Get("C:\Folder\SubFolder\File.ext").Get(1).Get(1)) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	Return $sucessAll;
}
Function Test_RoboVersion_Input() {
	$sucessAll = $True;
	PrintText ("TEST: Parâmetros nomeados devem funcionar");
	# RoboVersion -OrigPath "D:\ \BKPM\LOC1" -DestPath "D:\ \BKPM\LOC2" -Threads 8 -VersionLimit 3 -RemotionCountdown 5 -Destructive -ListOnly;
	PrintText ("Teste manual, funciona");
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Origem e destino devem aceitar posição 0 e 1");
	# RoboVersion "D:\ \BKPM\LOC1" "D:\ \BKPM\LOC2" -Threads 8 -VersionLimit 3 -RemotionCountdown 5 -Destructive -ListOnly;
	PrintText ("Teste manual, funciona");
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Deve funcionar com tudo fora de ordem");
	# RoboVersion "D:\ \BKPM\LOC1" "D:\ \BKPM\LOC2" -Destructive -VersionLimit 3 -Threads 8 -RemotionCountdown 5 -ListOnly;
	PrintText ("Teste manual, funciona");
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Deve perguntar pela origem e destino");
	# RoboVersion -VersionLimit 3 -Threads 8 -RemotionCountdown 5;
	PrintText ("Teste manual, funciona");
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Aliases de parâmetros devem funcionar");
	# RoboVersion -OP "D:\ \BKPM\LOC1" -DP "D:\ \BKPM\LOC2" -V 3 -T 8 -RC 5;
	PrintText ("Teste manual, funciona");
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Deve reclamar do V = -1");
	# RoboVersion "D:\ \BKPM\LOC1" "D:\ \BKPM\LOC2" -V -1 -T 8 -RC 5;
	PrintText ("Teste manual, funciona");
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Deve reclamar do V = 999991");
	# RoboVersion "D:\ \BKPM\LOC1" "D:\ \BKPM\LOC2" -V 999991 -T 8 -RC 5;
	PrintText ("Teste manual, funciona");
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Deve reclamar da origem inexistente");
	# RoboVersion -OP "D:\ \BKPM\LOC9999" -DP "D:\ \BKPM\LOC2" -V 3 -T 8 -RC 5;
	PrintText ("Teste manual, funciona");
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Deve reclamar do destino inválido");
	# RoboVersion -OP "D:\ \BKPM\LOC1" -DP "*" -V 3 -T 8 -RC 5;
	PrintText ("Teste manual, funciona");
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Deve reclamar do destino vazio");
	# RoboVersion -OP "D:\ \BKPM\LOC1" -DP "" -V 3 -T 8 -RC 5;
	PrintText ("Teste manual, funciona");
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Deve reclamar do destino inválido(Longo demais)");
	# RoboVersion -OP "D:\ \BKPM\LOC1" -DP "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO" -V 3 -T 8 -RC 5;
	PrintText ("Teste manual, funciona");
	PrintText ("");
	PrintText ("");
	PrintText ("");
	Return $sucessAll;
}
Function Test_RoboVersion($rootPath) {
	
				# . "./RoboVersion.ps1";
				# $rootPath = "D:\ ";

	$sucessAll = $True;
	PrintText ("ATENÇÃO: Testes reais! Arquivos-testes serão criados!");
	PrintText ("");
	PrintText ("");
	PrintText ("");
	#Pastas
	If(-Not (Test-Path -LiteralPath $rootPath)) {
		Return $False;
	}
	$testRootPath = (Join-Path -Path $rootPath -ChildPath "RoboVersion_TestArea");
	$testOrigPath = (Join-Path -Path $testRootPath -ChildPath "LOC1");
	$testDestPath = (Join-Path -Path $testRootPath -ChildPath "LOC2");
	If(-Not (Test-Path -LiteralPath $testRootPath)) {
		$Null = New-Item -Path $testRootPath -ItemType Directory;
	}
	If(-Not (Test-Path -LiteralPath $testOrigPath)) {
		$Null = New-Item -Path $testOrigPath -ItemType Directory;
	}
	If(-Not (Test-Path -LiteralPath $testDestPath)) {
		$Null = New-Item -Path $testDestPath -ItemType Directory;
	}
	#Testes
	$sucessAll = $True;
	$sucessTest_RoboVersion_1 = Test_RoboVersion_1 $testOrigPath $testDestPath;
	$sucessTest_RoboVersion_2 = Test_RoboVersion_2 $testOrigPath $testDestPath;
	$sucessTest_RoboVersion_2 = Test_RoboVersion_3 $testOrigPath $testDestPath;
	$sucessTest_RoboVersion_2 = Test_RoboVersion_4 $testOrigPath $testDestPath;
	$sucessTest_RoboVersion_2 = Test_RoboVersion_5 $testOrigPath $testDestPath;
	$sucessTest_RoboVersion_2 = Test_RoboVersion_6 $testOrigPath $testDestPath;
	$sucessTest_RoboVersion_2 = Test_RoboVersion_7 $testOrigPath $testDestPath;
	$sucessTest_RoboVersion_2 = Test_RoboVersion_8 $testOrigPath $testDestPath;
	PrintText ("Test_RoboVersion_1 FUNCIONA: " + $sucessTest_RoboVersion_1);
	PrintText ("Test_RoboVersion_2 FUNCIONA: " + $sucessTest_RoboVersion_2);
	PrintText ("Test_RoboVersion_3 FUNCIONA: " + $sucessTest_RoboVersion_3);
	PrintText ("Test_RoboVersion_4 FUNCIONA: " + $sucessTest_RoboVersion_4);
	PrintText ("Test_RoboVersion_5 FUNCIONA: " + $sucessTest_RoboVersion_5);
	PrintText ("Test_RoboVersion_6 FUNCIONA: " + $sucessTest_RoboVersion_6);
	PrintText ("Test_RoboVersion_7 FUNCIONA: " + $sucessTest_RoboVersion_7);
	PrintText ("Test_RoboVersion_8 FUNCIONA: " + $sucessTest_RoboVersion_8);
	If(-Not $sucessTest_RoboVersion_1) { $sucessAll = $False; }
	If(-Not $sucessTest_RoboVersion_2) { $sucessAll = $False; }
	If(-Not $sucessTest_RoboVersion_3) { $sucessAll = $False; }
	If(-Not $sucessTest_RoboVersion_4) { $sucessAll = $False; }
	If(-Not $sucessTest_RoboVersion_5) { $sucessAll = $False; }
	If(-Not $sucessTest_RoboVersion_6) { $sucessAll = $False; }
	If(-Not $sucessTest_RoboVersion_7) { $sucessAll = $False; }
	If(-Not $sucessTest_RoboVersion_8) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("Test_RoboVersion FUNCIONA: " + $sucessAll);
	#Deletar pastas
	$Null = Remove-Item -LiteralPath $testRootPath -Recurse;
	Return $sucessAll;
}
Function Test_RoboVersion_1($testOrigPath, $testDestPath) {
	$sucessAll = $True;
	PrintText ("TEST BATCH: Versionamento e remoção básicos");
	PrintText ("");
	PrintText ("TEST: Orig(New_F(A)) --(V=3,R=5)--> Dest(F(A))");
	PrintText ("'RoboVersion /V=3 /R=5': Espelhamento básico de 1 arquivo");
	$dummyFilePath = (Join-Path -Path $testOrigPath -ChildPath "FILE");
	$Null = New-Item $dummyFilePath;
	$Null = Set-Content $dummyFilePath "A";
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig(Mod_F(B)) --(V=3,R=5)--> Dest(F_v1(A), F(B))");
	PrintText ("'RoboVersion /V=3 /R=5': 1º versionamento");
	$Null = Set-Content $dummyFilePath "B";
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig(Mod_F(C)) --(V=3,R=5)--> Dest(F_v1(A), F_v2(B), F(C))");
	PrintText ("'RoboVersion /V=3 /R=5': 2º versionamento");
	$Null = Set-Content $dummyFilePath "C";
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig(Mod_F(D)) --(V=3,R=5)--> Dest(F_v1(A), F_v2(B), F_v3(C), F(D))");
	PrintText ("'RoboVersion /V=3 /R=5': 3º versionamento");
	$Null = Set-Content $dummyFilePath "D";
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig(Mod_F(E)) --(V=3,R=5)--> Dest(F_v1(B), F_v2(C), F_v3(D), F(E))");
	PrintText ("'RoboVersion /V=3 /R=5': 4º versionamento, removendo velhas versões");
	$Null = Set-Content $dummyFilePath "E";
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[0]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[4]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig(Mod_F(F)) --(V=3,R=5)--> Dest(F_v1(C), F_v2(D), F_v3(E), F(F))");
	PrintText ("'RoboVersion /V=3 /R=5': 5º versionamento, removendo velhas versões");
	$Null = Set-Content $dummyFilePath "F";
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[0]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[4]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig(Del_F(F)) --(V=3,R=5)--> Dest(F_v1_r5(C), F_v2_r5(D), F_v3_r5(E), F_r5(F))");
	PrintText ("'RoboVersion /V=3 /R=5': Remoção");
	$Null = Remove-Item -LiteralPath $dummyFilePath;
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[5]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3] _removeIn[5]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[5]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[5]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_v1_r4(C), F_v2_r4(D), F_v3_r4(E), F_r4(F))");
	PrintText ("'RoboVersion /V=3 /R=5': 1º countdown");
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[4]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3] _removeIn[4]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[4]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[4]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[5]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3] _removeIn[5]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[5]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[5]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_v1_r3(C), F_v2_r3(D), F_v3_r3(E), F_r3(F))");
	PrintText ("'RoboVersion /V=3 /R=5': 2º countdown");
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[3]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3] _removeIn[3]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[3]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[3]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[4]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3] _removeIn[4]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[4]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[4]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_v1_r2(C), F_v2_r2(D), F_v3_r2(E), F_r2(F))");
	PrintText ("'RoboVersion /V=3 /R=5': 3º countdown");
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[2]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3] _removeIn[2]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[2]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[2]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[3]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3] _removeIn[3]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[3]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[3]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_v1_r1(C), F_v2_r1(D), F_v3_r1(E), F_r1(F))");
	PrintText ("'RoboVersion /V=3 /R=5': 4º countdown");
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[1]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3] _removeIn[1]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[1]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[1]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[2]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3] _removeIn[2]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[2]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[2]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_v1_r0(C), F_v2_r0(D), F_v3_r0(E), F_r0(F))");
	PrintText ("'RoboVersion /V=3 /R=5': 5º countdown, o último");
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[0]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3] _removeIn[0]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[0]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[0]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[1]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3] _removeIn[1]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[1]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[1]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest()");
	PrintText ("'RoboVersion /V=3 /R=5': Deve deletar tudo!");
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[0]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3] _removeIn[0]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[0]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[0]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	Return $sucessAll;
}
Function Test_RoboVersion_2($testOrigPath, $testDestPath) {
	$sucessAll = $True;
	PrintText ("TEST BATCH: Versionamento e remoção de 2 arquivos iguais");
	PrintText ("");
	PrintText ("TEST: Orig(New_F(A)) --(V=3,R=5)--> Dest(F(A))");
	PrintText ("'RoboVersion /V=3 /R=5': Deve espelhar");
	$dummyFilePath = (Join-Path -Path $testOrigPath -ChildPath "FILE");
	$Null = New-Item $dummyFilePath;
	$Null = Set-Content $dummyFilePath "A";
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig(Mod_F(B)) --(V=3,R=5)--> Dest(F_v1(A), F(B))");
	PrintText ("'RoboVersion /V=3 /R=5': 1º versão");
	$Null = Set-Content $dummyFilePath "B";
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig(Mod_F(C)) --(V=3,R=5)--> Dest(F_v1(A), F_v2(B), F(C))");
	PrintText ("'RoboVersion /V=3 /R=5': 2º versão");
	$Null = Set-Content $dummyFilePath "C";
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig(Mod_F(D)) --(V=3,R=5)--> Dest(F_v1(A), F_v2(B), F_v3(C), F(D))");
	PrintText ("'RoboVersion /V=3 /R=5': 3º versão");
	$Null = Set-Content $dummyFilePath "D";
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig(Del_F(D)) --(V=3,R=5)--> Dest(F_v1_r5(A), F_v2_r5(B), F_v3_r5(C), F_r5(D))");
	PrintText ("'RoboVersion /V=3 /R=5': Remoção");
	$Null = Remove-Item -LiteralPath $dummyFilePath;
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[5]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[5]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[5]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3] _removeIn[5]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig(New_F(Z)) --(V=3,R=5)--> Dest(F_v1_r4(A), F_v2_r4(B), F_v3_r4(C), F_r4(D), F(Z))");
	PrintText ("'RoboVersion /V=3 /R=5': 1º countdown, com espelhamento");
	$Null = New-Item $dummyFilePath;
	$Null = Set-Content $dummyFilePath "Z";
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[4]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[4]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[4]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3] _removeIn[4]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");



	PrintText ("TEST: Orig(Mod_F(Y)) --(V=3,R=5)--> Dest(F_v1_r3(A), F_v2_r3(B), F_v3_r3(C), F_r3(D), F_v1(Z), F(Y))");
	PrintText ("'RoboVersion /V=3 /R=5': 2º countdown, 1ª versão");
	$Null = Set-Content $dummyFilePath "Y";
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[3]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[3]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[3]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3] _removeIn[3]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	# AH! A nova versão deve ser diferente da removida! Não a mesma!




	PrintText ("TEST: Orig(Mod_F(W)) --(V=3,R=5)--> Dest(F_v1_r2(A), F_v2_r2(B), F_v2_r2(C), F_r2(D), F_v1(Z), F_v2(Y), F(W))");
	PrintText ("'RoboVersion /V=3 /R=5': 3º countdown, 2ª versão");
	$Null = Set-Content $dummyFilePath "W";
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[2]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[2]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[2]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3] _removeIn[2]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig(Del_F(W)) --(V=3,R=5)--> Dest(F_v1_r1(A), F_v2_r1(B), F_v1_r1(C), F_r1(D), F_v1_r5(Z), F_v2_r5(Y), F_r5(W))");
	PrintText ("'RoboVersion /V=3 /R=5': 4º countdown, e remoção");
	$Null = Remove-Item -LiteralPath $dummyFilePath;
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[5]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[5]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[5]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[1]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[1]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[1]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3] _removeIn[1]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_v1_r0(A), F_v2_r0(B), F_v1_r0(C), F_r0(D), F_v1_r4(Z), F_v2_r4(Y), F_r4(W))");
	PrintText ("'RoboVersion /V=3 /R=5': 5º countdown, o último, 1º countdown");
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[4]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[4]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[4]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[0]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[0]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[0]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3] _removeIn[0]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_v1_r3(Z), F_v2_r3(Y), F_r3(W))");
	PrintText ("'RoboVersion /V=3 /R=5': Deletar os removidos, e 2º countdown");
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[3]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[3]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[3]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[0]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[0]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[0]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[3] _removeIn[0]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_v1_r2(Z), F_v2_r2(Y), F_r2(W))");
	PrintText ("'RoboVersion /V=3 /R=5': 3º countdown");
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[2]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[2]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[2]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_v1_r1(Z), F_v2_r1(Y), F_r1(W))");
	PrintText ("'RoboVersion /V=3 /R=5': 4º countdown");
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[1]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[1]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[1]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_v1_r0(Z), F_v2_r0(Y), F_r0(W))");
	PrintText ("'RoboVersion /V=3 /R=5': 5º countdown, o último");
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[0]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[0]"))) { $sucess = $False; }
	If(-Not (Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[0]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest()");
	PrintText ("'RoboVersion /V=3 /R=5': Deletar os removidos");
	Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = $True;
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[0]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[1] _removeIn[0]"))) { $sucess = $False; }
	If((Test-Path -LiteralPath (Join-Path -Path $testDestPath -ChildPath "FILE _version[2] _removeIn[0]"))) { $sucess = $False; }
	PrintText ("FUNCIONA: " + $sucess);
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("");
	PrintText ("");
	Return $sucessAll;
}
Function Test_RoboVersion_3($testOrigPath, $testDestPath) {
	$sucessAll = $True;
	PrintText ("TEST BATCH: Conflito entre remoção automática e remoção manual");
	PrintText ("");
	PrintText ("TEST: Orig(New_F(A)) --(V=3,R=5)--> Dest(F(A))");
	PrintText ("TEST: Orig(Del_F(A)) --(V=3,R=5)--> Dest(F_r5(A))");
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_r4(A))");
	PrintText ("TEST: Dest(Ren_F_r6(A), Orig(New_F(Z))) --(V=3,R=5)--> Dest(F_r6(A), F(Z))");
	PrintText ("TEST: Orig(Del_F(Z))) --(V=3,R=5)--> Dest(F_r4(A), F_r5(Z))");
	PrintText ("(r6 se torna r4, com o r5 sendo ocupado pelo novo removido)");
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_r3(A), F_r4(Z))");
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_r2(A), F_r3(Z))");
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_r1(A), F_r2(Z))");
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_r0(A), F_r1(Z))");
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_r0(Z))");
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest()");
	Return $sucessAll;
}
Function Test_RoboVersion_4($testOrigPath, $testDestPath) {
	$sucessAll = $True;
	PrintText ("TEST BATCH: Conflito entre versão automática e versão manual");
	PrintText ("");
	PrintText ("TEST: Orig(New_F(A)) --(V=3,R=1)--> Dest(F(A))");
	PrintText ("TEST: Orig(Mod_F(B)) --(V=3,R=1)--> Dest(F_v1(A), F(B))");
	PrintText ("TEST: Dest(Ren_F_v2(A)), Orig(Mod_F(C)) --(V=3,R=1)--> Dest(F_v2(A), F_v1(B), F(C))");
	PrintText ("TEST: Orig(Del_F(C)) --(V=3,R=1)--> Dest(F_v2_r1(A), F_v1_r1(B), F_r1(C))");
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest(F_v2_r0(A), F_v1_r0(B), F_r0(C))");
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest()");
	Return $sucessAll;
}
Function Test_RoboVersion_5($testOrigPath, $testDestPath) {
	$sucessAll = $True;
	PrintText ("TEST BATCH: `"Esmagamento`" de versões presentes além do limite");
	PrintText ("");
	PrintText ("TEST: Orig(New_F(A)) --(V=3,R=1)--> Dest(F(A))");
	PrintText ("TEST: Orig(Mod_F(B)) --(V=3,R=1)--> Dest(F_v1(A), F(B))");
	PrintText ("TEST: Orig(Mod_F(C)) --(V=3,R=1)--> Dest(F_v1(A), F_v2(B), F(C))");
	PrintText ("TEST: Orig(Mod_F(D)) --(V=3,R=1)--> Dest(F_v1(A), F_v2(B), F_v3(C), F(D))");
	PrintText ("TEST: Dest(New_F_v5(Z)), Orig() --(V=3,R=1)--> Dest(F_v1(A), F_v2(B), F_v3(C), F(D), F_v5(Z))");
	PrintText ("TEST: Dest(New_F_v6(Y)), Orig() --(V=3,R=1)--> Dest(F_v1(A), F_v2(B), F_v3(C), F(D), F_v5(Z), F_v6(Y))");
	PrintText ("TEST: Orig() --(V=3,R=1,D)--> Dest(F_v1(C), F_v2(Z), F_v3(Y), F(D))");
	PrintText ("(v6 se torna v3, v5 se torna v2, e v3 se torna v1, o resto sendo deletado)");
	PrintText ("TEST: Orig() --(V=0,R=1,D)--> Dest(F(D))");
	PrintText ("TEST: Orig(Del_F(D)) --(V=0,R=1)--> Dest(F_r1(D))");
	PrintText ("TEST: Orig() --(V=0,R=1)--> Dest(F_r0(D))");
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest()");
	Return $sucessAll;
}
Function Test_RoboVersion_6($testOrigPath, $testDestPath) {
	$sucessAll = $True;
	PrintText ("TEST BATCH: `"Esmagamento`" de remoções presentes além do limite");
	PrintText ("");
	PrintText ("TEST: Orig(New_F(A)) --(V=3,R=5)--> Dest(F(A))");
	PrintText ("TEST: Orig(Del_F(A)) --(V=3,R=5)--> Dest(F_r5(A))");
	PrintText ("TEST: Dest(New_F_r6(Z), New_F_r7(Y), New_F_r8(X), New_F_r9(W)), Orig() --(V=3,R=5)--> Dest(F_r4(A), F_r6(Z), F_r7(Y), F_r8(X), F_r9(W))");
	PrintText ("TEST: Orig() --(V=3,R=5,D)--> Dest(F_r1(A), F_r2(Z), F_r3(Y), F_r4(X), F_r5(W))");
	PrintText ("TEST: Orig() --(V=3,R=0,D)--> Dest()");
	Return $sucessAll;
}
Function Test_RoboVersion_6($testOrigPath, $testDestPath) {
	$sucessAll = $True;
	PrintText ("TEST BATCH: Versões devem seguir de 1 a V");
	PrintText ("");
	PrintText ("TEST: Orig(New_F(A)) --(V=5,R=1)--> Dest(F(A))");
	PrintText ("TEST: Dest(New_F_v3(Z)), Orig(Mod_F(B)) --(V=3,R=5)--> Dest(F_v1(A), F(B), F_v3(Z))");
	PrintText ("TEST: Orig(Mod_F(C)) --(V=5,R=1)--> Dest(F_v1(A), F_v2(B), F(C), F_v5(Z))");
	PrintText ("TEST: Orig(Mod_F(D)) --(V=5,R=1)--> Dest(F_v1(A), F_v2(B), F_v3(C), F(D), F_v5(Z))");
	PrintText ("TEST: Orig(Mod_F(E)) --(V=5,R=1)--> Dest(F_v1(A), F_v2(B), F_v3(C), F_v4(D), F_v5(Z), F(E))");
	PrintText ("TEST: Orig(Mod_F(F)) --(V=5,R=1)--> Dest(F_v1(B), F_v2(C), F_v3(D), F_v4(Z), F_v5(E), F(F))");
	PrintText ("TEST: Orig(Del_F(F)) --(V=0,R=0)--> Dest()");
	Return $sucessAll;
}
Function Test_RoboVersion_7($testOrigPath, $testDestPath) {
	$sucessAll = $True;
	PrintText ("TEST BATCH: Sub-Pastas");
	PrintText ("");
	PrintText ("TEST: Orig(New_P()) --(V=3,R=3)--> Dest()");
	PrintText ("TEST: Orig(P(New_F(A))) --(V=3,R=3)--> Dest(P(F(A)))");
	PrintText ("TEST: Orig(P(Mod_F(B))) --(V=3,R=3)--> Dest(P(F_v1(A), F(B)))");
	PrintText ("TEST: Orig(P(Del_F(B))) --(V=3,R=3)--> Dest(P(F_v1_r3(A), F_r3(B)))");
	PrintText ("TEST: Orig(Del_P()) --(V=3,R=3)--> Dest(P_r3(F_v1_r2(A), F_r2(B)))");
	PrintText ("TEST: Orig() --(V=3,R=3)--> Dest(P_r2(F_v1_r1(A), F_r1(B)))");
	PrintText ("TEST: Orig() --(V=3,R=3)--> Dest(P_r1(F_v1_r0(A), F_r0(B)))");
	PrintText ("TEST: Orig() --(V=3,R=3)--> Dest(P_r0())");
	PrintText ("TEST: Orig() --(V=3,R=3)--> Dest()");
	Return $sucessAll;
}
Function Test_RoboVersion_8($testOrigPath, $testDestPath) {
	$sucessAll = $True;
	PrintText ("TEST BATCH: Arquivos com nomes estranhos");
	PrintText ("");
	PrintText ("TEST: Orig(New_`".file`"(A)) --(V=3,R=1)--> Dest(`".file`"(A))");
	PrintText ("TEST: Orig(Mod_`".file`"(B)) --(V=3,R=1)--> Dest(`"_v1.file`"(A), `".file`"(B))");
	PrintText ("TEST: Orig(Del_`".file`"(B)) --(V=3,R=1)--> Dest(`"_v1_r1.file`"(A), `"_r1.file`"(B))");
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest(`"_v1_r0.file`"(A), `"_r0.file`"(B))");
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest()");
	PrintText ("TEST: Orig(New_`"F _version[1]`"(A)) --(V=3,R=1)--> Dest()");
	PrintText ("TEST: Orig(Del_`"F _version[1]`"(A)) --(V=3,R=1)--> Dest()");
	PrintText ("TEST: Orig(New_`"F _version[AAA]`"(A)) --(V=3,R=1)--> Dest()");
	PrintText ("TEST: Orig(Del_`"F _version[AAA]`"(A)) --(V=3,R=1)--> Dest()");
	PrintText ("TEST: Orig(New_`"F.ext _version[1]`"(A)) --(V=3,R=1)--> Dest(`"F.ext _version[1]`"(A))");
	PrintText ("TEST: Orig(Mod_`"F.ext _version[1]`"(B)) --(V=3,R=1)--> Dest(`"F_v1.ext _version[1]`"(A), `"F.ext _version[1]`"(B))");
	PrintText ("TEST: Orig(Del_`"F.ext _version[1]`"(B)) --(V=3,R=1)--> Dest(`"F_v1_r1.ext _version[1]`"(A), `"F_r1.ext _version[1]`"(B))");
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest(`"F_v1_r0.ext _version[1]`"(A), `"F_r0.ext _version[1]`"(B))");
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest()");
	PrintText ("TEST: Orig(New_`"F-F+my+two.2.1_beta.ext`"(A)) --(V=3,R=1)--> Dest(`"F-F+my+two.2.1_beta.ext`"(A))");
	PrintText ("TEST: Orig(Mod_`"F-F+my+two.2.1_beta.ext`"(B)) --(V=3,R=1)--> Dest(`"F-F+my+two.2.1_beta_v1.ext`"(A), `"F-F+my+two.2.1_beta.ext`"(B))");
	PrintText ("TEST: Orig(Del_`"F-F+my+two.2.1_beta.ext`"(B)) --(V=3,R=1)--> Dest(`"F-F+my+two.2.1_beta_v1_r1.ext`"(A), `"F-F+my+two.2.1_beta_r1.ext`"(B))");
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest(`"F-F+my+two.2.1_beta_v1_r0.ext`"(A), `"F-F+my+two.2.1_beta_r0.ext`"(B))");
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest()");
	PrintText ("TEST: Orig(New_`"$%&#@!.;`^[]{}ºª=¨§`"(A)) --(V=3,R=1)--> Dest(`"$%&#@!.;`^[]{}ºª=¨§`"(A))");
	PrintText ("TEST: Orig(Mod_`"$%&#@!.;`^[]{}ºª=¨§`"(A)) --(V=3,R=1)--> Dest(`"$%&#@!.;`^[]{}ºª=¨§_v1`"(A), `"$%&#@!.;`^[]{}ºª=¨§`"(B))");
	PrintText ("TEST: Orig(Del_`"$%&#@!.;`^[]{}ºª=¨§`"(A)) --(V=3,R=1)--> Dest(`"$%&#@!.;`^[]{}ºª=¨§_v1_r1`"(A), `"$%&#@!.;`^[]{}ºª=¨§_r1`"(B))");
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest(`"$%&#@!.;`^[]{}ºª=¨§_v1_r0`"(A), `"$%&#@!.;`^[]{}ºª=¨§_r0`"(B))");
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest()");
	PrintText ("TEST: Orig(New_`" ˸`”ʔ∕`"(A)) --(V=3,R=1)--> Dest(`" ˸`”ʔ∕`"(A))");
	PrintText ("TEST: Orig(Mod_`" ˸`”ʔ∕`"(B)) --(V=3,R=1)--> Dest(`" ˸`”ʔ∕_v1`"(A), `" ˸`”ʔ∕`"(B))");
	PrintText ("TEST: Orig(Del_`" ˸`”ʔ∕`"(B)) --(V=3,R=1)--> Dest(`" ˸`”ʔ∕_v1_r1`"(A), `" ˸`”ʔ∕_r1`"(B))");
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest(`" ˸`”ʔ∕_v1_r0`"(A), `" ˸`”ʔ∕_r0`"(B))");
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest()");
	Return $sucessAll;
}
Function Test_All() {
	$testAreaPath = "D:\ ";
	# Básico
	$sucessTest_GetFileMap = Test_GetFileMap;
	# Update dos arquivos versionados e removidos
	$sucessTest_UpdateVersioned = Test_UpdateVersioned;
	$sucessTest_UpdateRemoved = Test_UpdateRemoved;
	$sucessTest_UpdateModified = Test_UpdateModified;
	# Update com os arquivos a modificar e deletar
	$sucessTest_UpdateToVersion = Test_UpdateToVersion;
	$sucessTest_UpdateToRemove = Test_UpdateToRemove;
	$sucessTest_UpdateToModify = Test_UpdateToModify;
	# Update de todos os arquivos
	$sucessTest_RoboVersion_Input = Test_RoboVersion_Input;
	$sucessTest_RoboVersion = Test_RoboVersion $testAreaPath;
	# Resultado
	$sucessAll = $True;
	PrintText ("Test_GetFileMap FUNCIONA: " + $sucessTest_GetFileMap);
	PrintText ("Test_UpdateVersioned FUNCIONA: " + $sucessTest_UpdateVersioned);
	PrintText ("Test_UpdateRemoved FUNCIONA: " + $sucessTest_UpdateRemoved);
	PrintText ("Test_UpdateModified FUNCIONA: " + $sucessTest_UpdateModified);
	PrintText ("Test_UpdateToVersion FUNCIONA: " + $sucessTest_UpdateToVersion);
	PrintText ("Test_UpdateToRemove FUNCIONA: " + $sucessTest_UpdateToRemove);
	PrintText ("Test_UpdateToModify FUNCIONA: " + $sucessTest_UpdateToModify);
	PrintText ("Test_RoboVersion_Input FUNCIONA: " + $sucessTest_RoboVersion_Input);
	PrintText ("Test_RoboVersion FUNCIONA: " + $sucessTest_RoboVersion);
	If(-Not $sucessTest_GetFileMap) { $sucessAll = $False; }
	If(-Not $sucessTest_UpdateVersioned) { $sucessAll = $False; }
	If(-Not $sucessTest_UpdateRemoved) { $sucessAll = $False; }
	If(-Not $sucessTest_UpdateModified) { $sucessAll = $False; }
	If(-Not $sucessTest_UpdateToVersion) { $sucessAll = $False; }
	If(-Not $sucessTest_UpdateToRemove) { $sucessAll = $False; }
	If(-Not $sucessTest_UpdateToModify) { $sucessAll = $False; }
	If(-Not $sucessTest_RoboVersion_Input) { $sucessAll = $False; }
	If(-Not $sucessTest_RoboVersion) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("TUDO FUNCIONA: " + $sucessAll);
}