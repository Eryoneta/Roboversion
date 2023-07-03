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
				Echo $fileMap.Get($nameKey).Get($versionKey).Get($remotionKey);
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
	Return $sucessAll;
}
Function Test_UpdateToModify() {
	$sucessAll = $True;
	#TODO
	Return $sucessAll;
}
Function Test_Update() {
	$sucessAll = $True;
	#TODO
	# RoboVersion -OrigPath "D:\ \BKPM\LOC1" -DestPath "D:\ \BKPM\LOC2" -Threads 8 -VersionLimit 3 -RemotionCountdown 5 -Destructive -ListOnly;
		# RoboVersion "D:\ \BKPM\LOC1" "D:\ \BKPM\LOC2" -Threads 8 -VersionLimit 3 -RemotionCountdown 5 -Destructive -ListOnly;
		# RoboVersion "D:\ \BKPM\LOC1" "D:\ \BKPM\LOC2" -Destructive -VersionLimit 3 -Threads 8 -RemotionCountdown 5 -ListOnly;
		# RoboVersion "D:\ \BKPM\LOC1" "D:\ \BKPM\LOC2" -Destructive -VersionLimit 3 -Threads 8 -RemotionCountdown 5 -ListOnly;
	# RoboVersion -VersionLimit 3 -Threads 8 -RemotionCountdown 5;
		# RoboVersion -OP "D:\ \BKPM\LOC1" -DP "D:\ \BKPM\LOC2"-V 3 -T 8 -RC 5;
	# RoboVersion "D:\ \BKPM\LOC1" "D:\ \BKPM\LOC2"-V -1 -T 8 -RC 5;
	# RoboVersion "D:\ \BKPM\LOC1" "D:\ \BKPM\LOC2"-V 999991 -T 8 -RC 5;
	# RoboVersion -OP "D:\ \BKPM\LOC9999" -DP "D:\ \BKPM\LOC2"-V 3 -T 8 -RC 5;
	# RoboVersion -OP "D:\ \BKPM\LOC1" -DP "*"-V 3 -T 8 -RC 5;
	# RoboVersion -OP "D:\ \BKPM\LOC1" -DP ""-V 3 -T 8 -RC 5;
	# RoboVersion -OP "D:\ \BKPM\LOC1" -DP "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"-V 3 -T 8 -RC 5;
	Return $sucessAll;
}
Function Test_All() {
	# Básico
	$sucessTest_GetFileMap = Test_GetFileMap;
	# Update dos arquivos versionados
	$sucessTest_UpdateVersioned = Test_UpdateVersioned;
	$sucessTest_UpdateRemoved = Test_UpdateRemoved;
	$sucessTest_UpdateModified = Test_UpdateModified;
	# Update com os arquivos modificados
	$sucessTest_UpdateToVersion = Test_UpdateToVersion;
	$sucessTest_UpdateToRemove = Test_UpdateToRemove;
	$sucessTest_UpdateToModify = Test_UpdateToModify;
	# Update de todos os arquivos
	$sucessTest_Update = Test_Update;
	# Resultado
	$sucessAll = $True;
	PrintText ("Test_GetFileMap FUNCIONA: " + $sucessTest_GetFileMap);
	PrintText ("Test_UpdateVersioned FUNCIONA: " + $sucessTest_UpdateVersioned);
	PrintText ("Test_UpdateRemoved FUNCIONA: " + $sucessTest_UpdateRemoved);
	PrintText ("Test_UpdateModified FUNCIONA: " + $sucessTest_UpdateModified);
	PrintText ("Test_UpdateToVersion FUNCIONA: " + $sucessTest_UpdateToVersion);
	PrintText ("Test_UpdateToRemove FUNCIONA: " + $sucessTest_UpdateToRemove);
	PrintText ("Test_UpdateToModify FUNCIONA: " + $sucessTest_UpdateToModify);
	PrintText ("Test_Update FUNCIONA: " + $sucessTest_Update);
	If(-Not $sucessTest_GetFileMap) { $sucessAll = $False; }
	If(-Not $sucessTest_UpdateVersioned) { $sucessAll = $False; }
	If(-Not $sucessTest_UpdateRemoved) { $sucessAll = $False; }
	If(-Not $sucessTest_UpdateModified) { $sucessAll = $False; }
	If(-Not $sucessTest_UpdateToVersion) { $sucessAll = $False; }
	If(-Not $sucessTest_UpdateToRemove) { $sucessAll = $False; }
	If(-Not $sucessTest_UpdateToModify) { $sucessAll = $False; }
	If(-Not $sucessTest_Update) { $sucessAll = $False; }
	PrintText ("");
	PrintText ("TUDO FUNCIONA: " + $sucessAll);
}