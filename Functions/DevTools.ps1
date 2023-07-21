. "./RoboVersion.ps1";
. "./Functions/FileMap.ps1";
. "./Functions/Functions.ps1";
. "./Functions/FileManager.ps1";
. "./Functions/UpdateVersioned.ps1";
. "./Functions/UpdateRemoved.ps1";
. "./Functions/UpdateToVersion.ps1";
. "./Functions/UpdateToRemove.ps1";
. "./Functions/Mirror.ps1";
# . "./Functions/DevTools.ps1"; precisa ser executada na pasta onde fica "RoboVersion.ps1"!

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
	EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", 4, 7),
		("C:\Folder\SubFolder\File.ext", 2, 5),
		("C:\Folder\SubFolder\File.ext", 1, 5),
		("C:\Folder\SubFolder\File.ext", 2, 3),
		("C:\Folder\SubFolder\File.ext", -1, 5),
		("C:\Folder\SubFolder\File.ext", 15, -1),
		("C:\Folder\SubFolder\File.ext", 12, 3),
		("C:\Folder\SubFolder\File.ext", 12, 2),
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("")) (
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
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
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File1.ext", 4, 7),
		("C:\Folder\SubFolder\File1.ext", 2, 5),
		("C:\Folder\SubFolder\File1.ext", 1, 5),
		("C:\Folder\SubFolder\File1.ext", -1, 5),
		("C:\Folder\SubFolder\File1.ext", 1, -1),
		("C:\Folder\SubFolder\File1.ext", 1, 3),
		("C:\Folder\SubFolder\File1.ext", -1, -1),
		("C:\Folder\SubFolder\File2.ext", 1, 5),
		("C:\Folder\SubFolder\File2.ext", -1, 5),
		("C:\Folder\SubFolder\File2.ext", 5, -1),
		("C:\Folder\SubFolder\File2.ext", 1, -1),
		("C:\Folder\SubFolder\File2.ext", 3, 5),
		("C:\Folder\SubFolder\File2.ext", 3, -1),
		("C:\Folder\SubFolder\File2.ext", -1, -1),
		("C:\Folder\SubFolder\File3.com.ext", -1, -1),
		("C:\Folder\SubFolder\File4", -1, -1),
		("C:\Folder\SubFolder\.file5", -1, -1),
		("C:\Folder\SubFolder\.file5", 9, -1),
		("C:\Folder\SubFolder\.file5", 3, 1),
		("C:\Folder\SubFolder\File6.ext", 6, 5),
		("")) (
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	Return $sucessAll;
}
Function TestFilePresence($orderedMap, $needsToHave, $cannotHave) {
	$sucess = $True;
	ForEach($item In $needsToHave) {
		If($item.Count -eq 3) {
			If(-Not $orderedMap.Get($item[0]).Get($item[1]).Get($item[2])) { $sucess = $False; }
		}
	}
	ForEach($item In $cannotHave) {
		If($item.Count -eq 3) {
			If($orderedMap.Get($item[0]).Get($item[1]).Get($item[2])) { $sucess = $False; }
		}
	}
	PrintText ("FUNCIONA: " + $sucess);
	PrintText ("");
	PrintText ("");
	PrintText ("");
	Return $sucess;
}
Function Test_UpdateVersioned() {
	$sucessAll = $True;
	PrintText ('TEST: Dest(F_v1(A), F_v2(B), F_v3(C), F_v4(D), F_v5(E)) --($maxVersionLimit=3)--> Dest(F_v1(A), F_v2(B), F_v3(C), F_v4(D), F_v5(E))');
	PrintText ("'UpdateVersioned /V=3 /L': Sem Destructive, não deve fazer nada");
	$orderedMap = UpdateVersioned_Case ("",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[3].ext",
		"C:\Folder\SubFolder\File _version[4].ext",
		"C:\Folder\SubFolder\File _version[5].ext",
		"") 3 $False;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", 1, -1),
		("C:\Folder\SubFolder\File.ext", 2, -1),
		("C:\Folder\SubFolder\File.ext", 3, -1),
		("C:\Folder\SubFolder\File.ext", 4, -1),
		("C:\Folder\SubFolder\File.ext", 5, -1),
		("")) (
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Dest(F_v1(A), F_v2(B)) --($maxVersionLimit=3,$destructive)--> Dest(F_v1(A), F_v2(B))');
	PrintText ("'UpdateVersioned /V=3 /L': Com Destructive, não deve fazer nada se menores que 3");
	$orderedMap = UpdateVersioned_Case ("",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[3].ext",
		"") 3 $False;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", 1, -1),
		("C:\Folder\SubFolder\File.ext", 2, -1),
		("C:\Folder\SubFolder\File.ext", 3, -1),
		("")) (
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Dest(F_v10(A), F_v12(B), F_v23(C)) --($maxVersionLimit=3,$destructive)--> Dest(F_v1(A), F_v2(B), F_v3(C))');
	PrintText ("'UpdateVersioned /V=3 /D /L': Com Destructive, os maiores que 3 devem ser diminuidos");
	$orderedMap = UpdateVersioned_Case ("",
		"C:\Folder\SubFolder\File _version[10].ext",
		"C:\Folder\SubFolder\File _version[12].ext",
		"C:\Folder\SubFolder\File _version[23].ext",
		"") 3 $True;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", 1, -1),
		("C:\Folder\SubFolder\File.ext", 2, -1),
		("C:\Folder\SubFolder\File.ext", 3, -1),
		("")) (
		("C:\Folder\SubFolder\File.ext", 10, -1),
		("C:\Folder\SubFolder\File.ext", 12, -1),
		("C:\Folder\SubFolder\File.ext", 23, -1),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Dest(F_v1(A), F_v2(B), F_v3(C), F_v4(D), F_v5(E)) --($maxVersionLimit=3,$destructive)--> Dest(F_v1(C), F_v2(D), F_v3(E))');
	PrintText ("'UpdateVersioned /V=3 /D /L': Com Destructive, devem sobrar apenas 3 versões no máximo");
	PrintText ("(v1 e v2 são deletados, e v3, v4, e v5 se tornam os novos v1, v2, e v3)");
	$orderedMap = UpdateVersioned_Case ("",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[3].ext",
		"C:\Folder\SubFolder\File _version[4].ext",
		"C:\Folder\SubFolder\File _version[5].ext",
		"") 3 $True;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", 1, -1),
		("C:\Folder\SubFolder\File.ext", 2, -1),
		("C:\Folder\SubFolder\File.ext", 3, -1),
		("")) (
		("C:\Folder\SubFolder\File.ext", 4, -1),
		("C:\Folder\SubFolder\File.ext", 5, -1),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Dest(F_v1(A), F_v2(B), F_v27(Y), F_v34(Z)) --($maxVersionLimit=5,$destructive)--> Dest(F_v1(A), F_v2(B), F_v4(Y), F_v5(Z))');
	PrintText ("'UpdateVersioned /V=5 /D /L': Com Destructive, os maiores que 5 devem ser diminuidos, mas aqui não afetam os menores");
	PrintText ("(v27 e v34 se tornam v4 e v5)");
	$orderedMap = UpdateVersioned_Case ("",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[27].ext",
		"C:\Folder\SubFolder\File _version[34].ext",
		"") 5 $True;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", 1, -1),
		("C:\Folder\SubFolder\File.ext", 2, -1),
		("C:\Folder\SubFolder\File.ext", 4, -1),
		("C:\Folder\SubFolder\File.ext", 5, -1),
		("")) (
		("C:\Folder\SubFolder\File.ext", 27, -1),
		("C:\Folder\SubFolder\File.ext", 34, -1),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Dest(F_v1(A), F_v2(B), F_v19(W), F_v25(X), F_v27(Y), F_v34(Z)) --($maxVersionLimit=5,$destructive)--> Dest(F_v1(B), F_v2(W), F_v3(X), F_v4(Y), F_v5(Z))');
	PrintText ("'UpdateVersioned /V=5 /D /L': Com Destructive, os maiores que 5 devem ser diminuidos, mas apagando os menores");
	PrintText ("(v2, v19, v25, v27, e v34 se tornam v1, v2, v3, v4, e v5)");
	$orderedMap = UpdateVersioned_Case ("",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[19].ext",
		"C:\Folder\SubFolder\File _version[25].ext",
		"C:\Folder\SubFolder\File _version[27].ext",
		"C:\Folder\SubFolder\File _version[34].ext",
		"") 5 $True;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", 1, -1),
		("C:\Folder\SubFolder\File.ext", 2, -1),
		("C:\Folder\SubFolder\File.ext", 3, -1),
		("C:\Folder\SubFolder\File.ext", 4, -1),
		("C:\Folder\SubFolder\File.ext", 5, -1),
		("")) (
		("C:\Folder\SubFolder\File.ext", 19, -1),
		("C:\Folder\SubFolder\File.ext", 25, -1),
		("C:\Folder\SubFolder\File.ext", 27, -1),
		("C:\Folder\SubFolder\File.ext", 34, -1),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Dest(F_v27(Y), F_v34(Z)) --($maxVersionLimit=5,$destructive)--> Dest(F_v4(Y), F_v5(Z))');
	PrintText ("'UpdateVersioned /V=5 /D /L': Com Destructive, os maiores que 5 devem ser diminuidos, do maior ao menor");
	PrintText ("(v27 e v34 se tornam v4 e v5)");
	$orderedMap = UpdateVersioned_Case ("",
		"C:\Folder\SubFolder\File _version[27].ext",
		"C:\Folder\SubFolder\File _version[34].ext",
		"") 5 $True;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", 4, -1),
		("C:\Folder\SubFolder\File.ext", 5, -1),
		("")) (
		("C:\Folder\SubFolder\File.ext", 25, -1),
		("C:\Folder\SubFolder\File.ext", 34, -1),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Dest(F_v9_r3(Y), F_v9_r1(Z)) --($maxVersionLimit=3,$destructive)--> Dest(F_v3_r3(Y), F_v3_r1(Z))');
	PrintText ("'UpdateVersioned /V=3 /D /L': Com Destructive, os removidos não devem ser afetados");
	PrintText ("(Removidos não são afetados pelos versionamentos)");
	$orderedMap = UpdateVersioned_Case ("",
		"C:\Folder\SubFolder\File _version[9] _removeIn[3].ext",
		"C:\Folder\SubFolder\File _version[9] _removeIn[1].ext",
		"") 3 $True;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", 9, 3),
		("C:\Folder\SubFolder\File.ext", 9, 1),
		("")) (
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Dest(F_v4(A), F_v5(B), F_v6(C), F_v7(D), F(E)) --($maxVersionLimit=3,$destructive)--> Dest(F_v1(B), F_v2(C), F_v3(D), F(E))');
	PrintText ("'UpdateVersioned /V=3 /D /L': Com Destructive, o sem-versão também deve ser considerado");
	$orderedMap = UpdateVersioned_Case ("",
		"C:\Folder\SubFolder\File _version[4].ext",
		"C:\Folder\SubFolder\File _version[5].ext",
		"C:\Folder\SubFolder\File _version[6].ext",
		"C:\Folder\SubFolder\File _version[7].ext",
		"C:\Folder\SubFolder\File.ext",
		"") 3 $True;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("C:\Folder\SubFolder\File.ext", 1, -1),
		("C:\Folder\SubFolder\File.ext", 2, -1),
		("C:\Folder\SubFolder\File.ext", 3, -1),
		("")) (
		("C:\Folder\SubFolder\File.ext", 4, -1),
		("C:\Folder\SubFolder\File.ext", 5, -1),
		("C:\Folder\SubFolder\File.ext", 6, -1),
		("C:\Folder\SubFolder\File.ext", 7, -1),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Dest(F_v-3(A), F_v-2(B), F_v-1(C), F_vA(1), F_vB(2), F_v1(D)) --($maxVersionLimit=3,$destructive)--> Dest(F_v1(D))');
	PrintText ("'UpdateVersioned /V=3 /D /L': Os negativos e letras são ignorados(São parte do nome!)");
	PrintText ("(Estes são ignorados durante o mirror, se tornando arquivos-fantasmas)");
	$orderedMap = UpdateVersioned_Case ("",
		"C:\Folder\SubFolder\File _version[-3].ext",
		"C:\Folder\SubFolder\File _version[-2].ext",
		"C:\Folder\SubFolder\File _version[-1].ext",
		"C:\Folder\SubFolder\File _version[A].ext",
		"C:\Folder\SubFolder\File _version[B].ext",
		"C:\Folder\SubFolder\File _version[1].ext",
		"") 3 $True;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File _version[-3].ext", -1, -1),
		("C:\Folder\SubFolder\File _version[-2].ext", -1, -1),
		("C:\Folder\SubFolder\File _version[-1].ext", -1, -1),
		("C:\Folder\SubFolder\File _version[A].ext", -1, -1),
		("C:\Folder\SubFolder\File _version[B].ext", -1, -1),
		("")) (
		("C:\Folder\SubFolder\File.ext", -3, -1),
		("C:\Folder\SubFolder\File.ext", -2, -1),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Dest(F1_v4(A), F1_v5(B), F2_v4(1), F2_v5(2)) --($maxVersionLimit=3,$destructive)--> Dest(F1_v2(A), F1_v3(B), F2_v2(1), F2_v3(2))');
	PrintText ("'UpdateVersioned /V=3 /D /L': Com Destructive, não deve haver conflito entre versões de diferentes arquivos");
	$orderedMap = UpdateVersioned_Case ("",
		"C:\Folder\SubFolder\File1 _version[4].ext",
		"C:\Folder\SubFolder\File1 _version[5].ext",
		"C:\Folder\SubFolder\File2 _version[4].ext",
		"C:\Folder\SubFolder\File2 _version[5].ext",
		"") 3 $True;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File1.ext", 2, -1),
		("C:\Folder\SubFolder\File1.ext", 3, -1),
		("C:\Folder\SubFolder\File2.ext", 2, -1),
		("C:\Folder\SubFolder\File2.ext", 3, -1),
		("")) (
		("C:\Folder\SubFolder\File1.ext", 4, -1),
		("C:\Folder\SubFolder\File1.ext", 5, -1),
		("C:\Folder\SubFolder\File2.ext", 4, -1),
		("C:\Folder\SubFolder\File2.ext", 5, -1),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Dest(F_v2(A), F_v6(B), F_v7(C), F(D)) --($maxVersionLimit=0,$destructive)--> Dest(F(D))');
	PrintText ("'UpdateVersioned /V=0 /D /L': Com Destructive, deve deletar todas as versões");
	$orderedMap = UpdateVersioned_Case ("",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[6].ext",
		"C:\Folder\SubFolder\File _version[7].ext",
		"C:\Folder\SubFolder\File.ext",
		"") 0 $True;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("")) (
		("C:\Folder\SubFolder\File1.ext", 2, -1),
		("C:\Folder\SubFolder\File1.ext", 6, -1),
		("C:\Folder\SubFolder\File2.ext", 7, -1),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Dest(F_v2(A), F_v6(B), F_v7(C), F(D)) --($maxVersionLimit=1,$destructive)--> Dest(F(D), F_v1(C))');
	PrintText ("'UpdateVersioned /V=1 /D /L': Com Destructive, deve manter apenas 1 versão");
	$orderedMap = UpdateVersioned_Case ("",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[6].ext",
		"C:\Folder\SubFolder\File _version[7].ext",
		"C:\Folder\SubFolder\File.ext",
		"") 1 $True;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("C:\Folder\SubFolder\File.ext", 1, -1),
		("")) (
		("C:\Folder\SubFolder\File1.ext", 2, -1),
		("C:\Folder\SubFolder\File1.ext", 6, -1),
		("C:\Folder\SubFolder\File2.ext", 7, -1),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	Return $sucessAll;
}
	Function UpdateVersioned_Case($filePathList, $maxVersionLimit, $destructive) {
		$orderedMap = GetFileMap $filePathList;
		$orderedMap = UpdateVersioned $orderedMap $maxVersionLimit $destructive $True;
		Return $orderedMap;
	}
Function Test_UpdateRemoved() {
	$sucessAll = $True;
	PrintText ('TEST: Dest(F_r0(A), F_r1(B), F_r3(C), F_r5(D)) --($remotionCountdown=3)--> Dest(F_r0(B), F_r2(C), F_r4(D))');
	PrintText ("'UpdateRemoved /R=3 /L': Sem Destructive, deve apenas diminuir o countdown");
	PrintText ("(O r0 é deletado e todos os outros recebem countdown - 1)");
	$orderedMap = UpdateRemoved_Case ("",
		"C:\Folder\SubFolder\File _removeIn[0].ext",
		"C:\Folder\SubFolder\File _removeIn[1].ext",
		"C:\Folder\SubFolder\File _removeIn[3].ext",
		"C:\Folder\SubFolder\File _removeIn[5].ext",
		"") 3 $False;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, 0),
		("C:\Folder\SubFolder\File.ext", -1, 2),
		("C:\Folder\SubFolder\File.ext", -1, 4),
		("")) (
		("C:\Folder\SubFolder\File.ext", -1, 1),
		("C:\Folder\SubFolder\File.ext", -1, 3),
		("C:\Folder\SubFolder\File.ext", -1, 5),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Dest(F_r1(A), F_r8(Y), F_r9(Z)) --($remotionCountdown=3,$destructive)--> Dest(F_r0(A), F_r4(Y), F_r5(Z))');
	PrintText ("'UpdateRemoved /R=3 /D /L': Com Destructive, os maiores que 3 devem ser diminuidos");
	$orderedMap = UpdateRemoved_Case ("",
		"C:\Folder\SubFolder\File _removeIn[1].ext",
		"C:\Folder\SubFolder\File _removeIn[8].ext",
		"C:\Folder\SubFolder\File _removeIn[9].ext",
		"") 3 $True;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, 0),
		("C:\Folder\SubFolder\File.ext", -1, 2),
		("C:\Folder\SubFolder\File.ext", -1, 3),
		("")) (
		("C:\Folder\SubFolder\File.ext", -1, 1),
		("C:\Folder\SubFolder\File.ext", -1, 8),
		("C:\Folder\SubFolder\File.ext", -1, 9),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Dest(F_r3(Y),F_r4(Z)) --($remotionCountdown=3,$destructive)--> Dest(F_r2(Y), F_r3(Z))');
	PrintText ("'UpdateRemoved /R=3 /D /L': Com Destructive, o 3 deve ser diminuido normalmente");
	$orderedMap = UpdateRemoved_Case ("",
		"C:\Folder\SubFolder\File _removeIn[3].ext",
		"C:\Folder\SubFolder\File _removeIn[4].ext",
		"") 3 $True;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, 2),
		("C:\Folder\SubFolder\File.ext", -1, 3),
		("")) (
		("C:\Folder\SubFolder\File.ext", -1, 4),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Dest(F_r1(A), F_r4(W), F_r5(X), F_r8(Y), F_r9(Z)) --($remotionCountdown=3,$destructive)--> Dest(F_r0(W), F_r1(X), F_r2(Y), F_r3(Z))');
	PrintText ("'UpdateRemoved /R=3 /D /L': Com Destructive, os maiores que 3 devem ser diminuidos, apagando os menores");
	$orderedMap = UpdateRemoved_Case ("",
		"C:\Folder\SubFolder\File _removeIn[1].ext",
		"C:\Folder\SubFolder\File _removeIn[4].ext",
		"C:\Folder\SubFolder\File _removeIn[5].ext",
		"C:\Folder\SubFolder\File _removeIn[8].ext",
		"C:\Folder\SubFolder\File _removeIn[9].ext",
		"") 3 $True;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, 0),
		("C:\Folder\SubFolder\File.ext", -1, 1),
		("C:\Folder\SubFolder\File.ext", -1, 2),
		("C:\Folder\SubFolder\File.ext", -1, 3),
		("")) (
		("C:\Folder\SubFolder\File.ext", -1, 4),
		("C:\Folder\SubFolder\File.ext", -1, 5),
		("C:\Folder\SubFolder\File.ext", -1, 8),
		("C:\Folder\SubFolder\File.ext", -1, 9),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Dest(F_v1_r2(A), F_v1_r9(Z), F_v2_r2(1), F_v2_r9(10)) --($remotionCountdown=3,$destructive)--> Dest(F_v1_r1(A), F_v1_r3(Z), F_v2_r1(1), F_v2_r3(10))');
	PrintText ("'UpdateRemoved /R=3 /D /L': Com Destructive, as diferentes versões não devem entrar em conflito");
	$orderedMap = UpdateRemoved_Case ("",
		"C:\Folder\SubFolder\File _version[1] _removeIn[2].ext",
		"C:\Folder\SubFolder\File _version[1] _removeIn[9].ext",
		"C:\Folder\SubFolder\File _version[2] _removeIn[2].ext",
		"C:\Folder\SubFolder\File _version[2] _removeIn[9].ext",
		"") 3 $True;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", 1, 1),
		("C:\Folder\SubFolder\File.ext", 1, 3),
		("C:\Folder\SubFolder\File.ext", 2, 1),
		("C:\Folder\SubFolder\File.ext", 2, 3),
		("")) (
		("C:\Folder\SubFolder\File.ext", 1, 2),
		("C:\Folder\SubFolder\File.ext", 1, 9),
		("C:\Folder\SubFolder\File.ext", 2, 2),
		("C:\Folder\SubFolder\File.ext", 2, 9),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Dest(F_r2(A), F_r9(B), F_r12(C), F(D)) --($remotionCountdown=0,$destructive)--> Dest(F(D)))');
	PrintText ("'UpdateRemoved /R=0 /D /L': Com Destructive, todos os removidos devem ser deletados");
	$orderedMap = UpdateRemoved_Case ("",
		"C:\Folder\SubFolder\File _removeIn[2].ext",
		"C:\Folder\SubFolder\File _removeIn[9].ext",
		"C:\Folder\SubFolder\File _removeIn[12].ext",
		"C:\Folder\SubFolder\File.ext",
		"") 0 $True;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("")) (
		("C:\Folder\SubFolder\File.ext", -1, 2),
		("C:\Folder\SubFolder\File.ext", -1, 9),
		("C:\Folder\SubFolder\File.ext", -1, 12),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Dest(F_r2(A), F_r9(B), F_r12(C), F(D)) --($remotionCountdown=1,$destructive)--> Dest(F_r0(B), F_r1(C), F(D)))');
	PrintText ("'UpdateRemoved /R=1 /D /L': Com Destructive, deve manter apenas os removidos 0 e 1");
	$orderedMap = UpdateRemoved_Case ("",
		"C:\Folder\SubFolder\File _removeIn[2].ext",
		"C:\Folder\SubFolder\File _removeIn[9].ext",
		"C:\Folder\SubFolder\File _removeIn[12].ext",
		"C:\Folder\SubFolder\File.ext",
		"") 1 $True;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("C:\Folder\SubFolder\File.ext", -1, 1),
		("C:\Folder\SubFolder\File.ext", -1, 0),
		("")) (
		("C:\Folder\SubFolder\File.ext", -1, 2),
		("C:\Folder\SubFolder\File.ext", -1, 9),
		("C:\Folder\SubFolder\File.ext", -1, 12),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	# PrintText ('TEST: Dest(P_r3(F_v1_r2(A), F_r2(B))) --($remotionCountdown=3,$destructive)--> Dest(P_r2(F_v1_r1(A), F_r1(B)))');
	# PrintText ("'UpdateRemoved /R=3 /L': Deve atualizar a pasta e seus arquivos");
	# $orderedMap = UpdateRemoved_Case ("",
	# 	"C:\Folder\SubFolder\Pasta _removeIfEmpty",
	# 	"C:\Folder\SubFolder\Pasta _removeIfEmpty\File _removeIn[2].ext",
	# 	"C:\Folder\SubFolder\Pasta _removeIfEmpty\File _version[1] _removeIn[2].ext",
	# 	"") 1 $False;
	# # EchoFileMap $orderedMap;
	# $sucess = TestFilePresence $orderedMap (
	# 	("C:\Folder\SubFolder\Pasta", -1, 0),
	# 	("C:\Folder\SubFolder\Pasta _removeIfEmpty\File.ext", -1, 1),
	# 	("C:\Folder\SubFolder\Pasta _removeIfEmpty\File.ext", 1, 1),
	# 	("")) (
	# 	(""));
	# If(-Not $sucess) { $sucessAll = $False; }
	#   Não há como marcar um como uma pasta. "Pasta _removeIfEmpty" é visto com arquivo = Erro 
	Return $sucessAll;
}
	Function UpdateRemoved_Case($filePathList, $remotionCountdown, $destructive) {
		$orderedMap = GetFileMap $filePathList;
		$orderedMap = UpdateRemoved $orderedMap $Null $remotionCountdown $destructive $True;
		Return $orderedMap;
	}
Function Test_UpdateModified() {
	$sucessAll = $True;
	PrintText ('TEST: Dest(F_v1_r2(A), F_v1_r9(Z), F_v2_r2(1), F_v2_r9(10)) --($maxVersionLimit=3,$remotionCountdown=5,$destructive)--> Dest(F_v1_r1(A), F_v1_r8(Z), F_v2_r1(1), F_v2_r8(10))');
	PrintText ("'UpdateModified /V=3 /R=5 /L': Sem Destructive, as diferentes versões não devem entrar em conflito");
	$orderedMap = UpdateModified_Case ("",
		"C:\Folder\SubFolder\File _version[1] _removeIn[2].ext",
		"C:\Folder\SubFolder\File _version[1] _removeIn[9].ext",
		"C:\Folder\SubFolder\File _version[2] _removeIn[2].ext",
		"C:\Folder\SubFolder\File _version[2] _removeIn[9].ext",
		"") 3 5 $False;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", 1, 1),
		("C:\Folder\SubFolder\File.ext", 1, 8),
		("C:\Folder\SubFolder\File.ext", 2, 1),
		("C:\Folder\SubFolder\File.ext", 2, 8),
		("")) (
		("C:\Folder\SubFolder\File.ext", 1, 2),
		("C:\Folder\SubFolder\File.ext", 1, 9),
		("C:\Folder\SubFolder\File.ext", 2, 2),
		("C:\Folder\SubFolder\File.ext", 2, 9),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Dest(F_v1_r2(A), F_v1_r9(Z), F_v6_r2(1), F_v6_r9(10)) --($maxVersionLimit=3,$remotionCountdown=5,$destructive)--> Dest(F_v1_r1(A), F_v1_r5(Z), F_v3_r1(1), F_v3_r5(10))');
	PrintText ("'UpdateModified /V=3 /R=5 /D /L': Com Destructive, as diferentes versões não devem entrar em conflito");
	PrintText ("(Os v6 se tornam v3, e os r9 se tornam r5)");
	$orderedMap = UpdateModified_Case ("",
		"C:\Folder\SubFolder\File _version[1] _removeIn[2].ext",
		"C:\Folder\SubFolder\File _version[1] _removeIn[9].ext",
		"C:\Folder\SubFolder\File _version[6] _removeIn[2].ext",
		"C:\Folder\SubFolder\File _version[6] _removeIn[9].ext",
		"") 3 5 $True;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", 1, 1),
		("C:\Folder\SubFolder\File.ext", 1, 5),
		("C:\Folder\SubFolder\File.ext", 6, 1),
		("C:\Folder\SubFolder\File.ext", 6, 5),
		("")) (
		("C:\Folder\SubFolder\File.ext", 1, 2),
		("C:\Folder\SubFolder\File.ext", 1, 9),
		("C:\Folder\SubFolder\File.ext", 6, 2),
		("C:\Folder\SubFolder\File.ext", 6, 9),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	Return $sucessAll;
}
	Function UpdateModified_Case($filePathList, $maxVersionLimit, $remotionCountdown, $destructive) {
		$orderedMap = GetFileMap $filePathList;
		$orderedMap = UpdateVersioned $orderedMap $maxVersionLimit $destructive $True;
		$orderedMap = UpdateRemoved $orderedMap $Null $remotionCountdown $destructive $True;
		Return $orderedMap;
	}
Function Test_UpdateToVersion() {
	$sucessAll = $True;
	PrintText ('TEST: Orig(F(4))->Dest(F_v1(1), F_v2(2), F(3)) --($maxVersionLimit=3)--> Dest(F_v1(1), F_v2(2), F_v3(3), F(3))');
	PrintText ("'UpdateToVersion /V=3 /L': Deve criar uma nova versão");
	$orderedMap = UpdateToVersion_Case ("",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File.ext",
		"") ("",
		"C:\Folder\SubFolder\File.ext",
		"") 3;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("C:\Folder\SubFolder\File.ext", 1, -1),
		("C:\Folder\SubFolder\File.ext", 2, -1),
		("C:\Folder\SubFolder\File.ext", 3, -1),
		("")) (
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Orig(F(5))->Dest(F_v1(1), F_v2(2), F_v3(3), F(4)) --($maxVersionLimit=3)--> Dest(F_v1(2), F_v2(3), F_v3(4), F(4))');
	PrintText ("'UpdateToVersion /V=3 /L': Deve criar uma nova versão, mudando a versão de todas as outras e deletando a v0");
	PrintText ("(v1 é deletada, v2 se torna v1, v3 se torna v2, e F é copiado para v3)");
	$orderedMap = UpdateToVersion_Case ("",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[3].ext",
		"C:\Folder\SubFolder\File.ext",
		"") ("",
		"C:\Folder\SubFolder\File.ext",
		"") 3;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("C:\Folder\SubFolder\File.ext", 1, -1),
		("C:\Folder\SubFolder\File.ext", 2, -1),
		("C:\Folder\SubFolder\File.ext", 3, -1),
		("")) (
		("C:\Folder\SubFolder\File.ext", 4, -1),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Orig(F(5))->Dest(F_v1(1), F(4)) --($maxVersionLimit=3)--> Dest(F_v1(1), F_v2(4), F(4))');
	PrintText ("'UpdateToVersion /V=3 /L': Deve criar uma nova versão 2");
	PrintText ("(F é copiado para v2)");
	$orderedMap = UpdateToVersion_Case ("",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File.ext",
		"") ("",
		"C:\Folder\SubFolder\File.ext",
		"") 3;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("C:\Folder\SubFolder\File.ext", 1, -1),
		("C:\Folder\SubFolder\File.ext", 2, -1),
		("")) (
		("C:\Folder\SubFolder\File.ext", 3, -1),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Orig(F(5))->Dest(F_v3(1), F(4)) --($maxVersionLimit=3)--> Dest(F_v2(1), F_v3(4), F(4))');
	PrintText ("'UpdateToVersion /V=3 /L': Deve criar uma nova versão 3, mudando a versão do outro");
	PrintText ("(F é copiado para v2)");
	$orderedMap = UpdateToVersion_Case ("",
		"C:\Folder\SubFolder\File _version[3].ext",
		"C:\Folder\SubFolder\File.ext",
		"") ("",
		"C:\Folder\SubFolder\File.ext",
		"") 3;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("C:\Folder\SubFolder\File.ext", 2, -1),
		("C:\Folder\SubFolder\File.ext", 3, -1),
		("")) (
		("C:\Folder\SubFolder\File.ext", 1, -1),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Orig(F(5))->Dest(F_v3(1), F(4)) --($maxVersionLimit=0)--> Dest(F_v3(4), F(4))');
	PrintText ("'UpdateToVersion /V=0 /L': Com valor 0, não deve fazer nada");
	$orderedMap = UpdateToVersion_Case ("",
		"C:\Folder\SubFolder\File _version[3].ext",
		"C:\Folder\SubFolder\File.ext",
		"") ("",
		"C:\Folder\SubFolder\File.ext",
		"") 0;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("C:\Folder\SubFolder\File.ext", 3, -1),
		("")) (
		("C:\Folder\SubFolder\File.ext", 1, -1),
		("C:\Folder\SubFolder\File.ext", 2, -1),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Orig(F(5))->Dest(F_v3(1), F(4)) --($maxVersionLimit=0)--> Dest(F_v3(4), F(4))');
	PrintText ("'UpdateToVersion /V=0 /L': Com valor 0, não deve fazer nada");
	$orderedMap = UpdateToVersion_Case ("",
		"C:\Folder\SubFolder\File _version[3].ext",
		"C:\Folder\SubFolder\File.ext",
		"") ("",
		"C:\Folder\SubFolder\File.ext",
		"") 0;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("C:\Folder\SubFolder\File.ext", 3, -1),
		("")) (
		("C:\Folder\SubFolder\File.ext", 1, -1),
		("C:\Folder\SubFolder\File.ext", 2, -1),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Orig(F(5))->Dest(F_v3(1), F(4)) --($maxVersionLimit=1)--> Dest(F_v3(4), F_v1(4), F(4))');
	PrintText ("'UpdateToVersion /V=1 /L': Com valor 1, deve criar 1 versão");
	$orderedMap = UpdateToVersion_Case ("",
		"C:\Folder\SubFolder\File _version[3].ext",
		"C:\Folder\SubFolder\File.ext",
		"") ("",
		"C:\Folder\SubFolder\File.ext",
		"") 1;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("C:\Folder\SubFolder\File.ext", 1, -1),
		("C:\Folder\SubFolder\File.ext", 3, -1),
		("")) (
		("C:\Folder\SubFolder\File.ext", 2, -1),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Orig(F(5))->Dest(F_v1_r5(1), F(4)) --($maxVersionLimit=3)--> Dest(F_v1_r5(1), F_v1(4), F(4))');
	PrintText ("'UpdateToVersion /V=3 /L': Não deve ter conflito com removidos");
	$orderedMap = UpdateToVersion_Case ("",
		"C:\Folder\SubFolder\File _version[1] _removeIn[5].ext",
		"C:\Folder\SubFolder\File.ext",
		"") ("",
		"C:\Folder\SubFolder\File.ext",
		"") 3;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("C:\Folder\SubFolder\File.ext", 1, -1),
		("C:\Folder\SubFolder\File.ext", 1, 5),
		("")) (
		("C:\Folder\SubFolder\File.ext", 2, -1),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Orig(F(5))->Dest(`
		F_v1_r5(11), F_v1(1),`
		F_v2_r5(21), F_v2(2),`
		F_v3_r5(31), F_v3(3),`
		F(4)`
	) --($maxVersionLimit=3)--> Dest(`
		F_v1_r5(11), F_v1(2),`
		F_v2_r5(21), F_v2(3),`
		F_v3_r5(31), F_v3(4),`
		F(4)`
	)');
	PrintText ("'UpdateToVersion /V=3 /L': Não deve ter conflito com removidos");
	$orderedMap = UpdateToVersion_Case ("",
		"C:\Folder\SubFolder\File _version[1] _removeIn[5].ext",
		"C:\Folder\SubFolder\File _version[2] _removeIn[5].ext",
		"C:\Folder\SubFolder\File _version[3] _removeIn[5].ext",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[3].ext",
		"C:\Folder\SubFolder\File.ext",
		"") ("",
		"C:\Folder\SubFolder\File.ext",
		"") 3;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("C:\Folder\SubFolder\File.ext", 1, 5),
		("C:\Folder\SubFolder\File.ext", 2, 5),
		("C:\Folder\SubFolder\File.ext", 3, 5),
		("C:\Folder\SubFolder\File.ext", 1, -1),
		("C:\Folder\SubFolder\File.ext", 2, -1),
		("C:\Folder\SubFolder\File.ext", 3, -1),
		("")) (
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	Return $sucessAll;
}
	Function UpdateToVersion_Case($filePathList, $filePathListToModify, $maxVersionLimit) {
		$orderedMap = GetFileMap $filePathList;
		$orderedMapToModify = GetFileMap $filePathListToModify;
		$toModifyList = [System.Collections.ArrayList]::new();
		ForEach($nameKey In $orderedMapToModify.List()) {
			$toModifyFile = $orderedMapToModify.Get($nameKey).Get(-1).Get(-1);
			$Null = $toModifyList.Add($toModifyFile);
		}
		$orderedMap = UpdateToVersion $orderedMap $toModifyList $maxVersionLimit $True;
		Return $orderedMap;
	}
Function Test_UpdateToRemove() {
	$sucessAll = $True;
	PrintText ('TEST: Orig()->Dest(F_v3(3), F(4)) --($remotionCountdown=3)--> Dest(F_v3_r3(3), F_r3(4), F(4))');
	PrintText ("'UpdateToRemove /R=3 /L': Deve criar uma nova remoção 3, renomeando todas as versões e copiando o arquivo");
	PrintText ("(v3 se torna v3_r3 e F é copiado para r3)");
	$orderedMap = UpdateToRemove_Case ("",
		"C:\Folder\SubFolder\File _version[3].ext",
		"C:\Folder\SubFolder\File.ext",
		"") ("",
		"C:\Folder\SubFolder\File.ext",
		"") 3;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("C:\Folder\SubFolder\File.ext", -1, 3),
		("C:\Folder\SubFolder\File.ext", 3, 3),
		("")) (
		("C:\Folder\SubFolder\File.ext", 3, -1),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Orig()->Dest(F_v3_r2(3), F_r2(4), F(5)) --($remotionCountdown=3)--> Dest(F_v3_r2(3), F_r2(4), F_r3(5), F(5))');
	PrintText ("'UpdateToRemove /R=3 /L': Deve criar uma nova remoção 3, sem afetar os outros removidos");
	$orderedMap = UpdateToRemove_Case ("",
		"C:\Folder\SubFolder\File _version[3] _removeIn[2].ext",
		"C:\Folder\SubFolder\File _removeIn[2].ext",
		"C:\Folder\SubFolder\File.ext",
		"") ("",
		"C:\Folder\SubFolder\File.ext",
		"") 3;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("C:\Folder\SubFolder\File.ext", 3, 2),
		("C:\Folder\SubFolder\File.ext", -1, 2),
		("C:\Folder\SubFolder\File.ext", -1, 3),
		("")) (
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Orig()->Dest(F_v3_r3(3), F_r3(4), F(5)) --($remotionCountdown=3)--> Dest(F_v3_r2(3), F_r2(4), F_r3(5), F(5))');
	PrintText ("'UpdateToRemove /R=3 /L': Deve criar uma nova remoção 3, e renomear os outros para remoção 2, se tiverem remoção 3");
	$orderedMap = UpdateToRemove_Case ("",
		"C:\Folder\SubFolder\File _version[3] _removeIn[3].ext",
		"C:\Folder\SubFolder\File _removeIn[3].ext",
		"C:\Folder\SubFolder\File.ext",
		"") ("",
		"C:\Folder\SubFolder\File.ext",
		"") 3;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("C:\Folder\SubFolder\File.ext", 3, 2),
		("C:\Folder\SubFolder\File.ext", -1, 2),
		("C:\Folder\SubFolder\File.ext", -1, 3),
		("")) (
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Orig()->Dest(F(5)) --($remotionCountdown=0)--> Dest(F(5))');
	PrintText ("'UpdateToRemove /R=0 /L': Com 0, não deve fazer nada");
	$orderedMap = UpdateToRemove_Case ("",
		"C:\Folder\SubFolder\File.ext",
		"") ("",
		"C:\Folder\SubFolder\File.ext",
		"") 0;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("")) (
		("C:\Folder\SubFolder\File.ext", -1, 0),
		("C:\Folder\SubFolder\File.ext", -1, 1),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Orig()->Dest(F(5)) --($remotionCountdown=1)--> Dest(F_r1(5), F(5))');
	PrintText ("'UpdateToRemove /R=1 /L': Com 1, deve criar uma remoção 1");
	$orderedMap = UpdateToRemove_Case ("",
		"C:\Folder\SubFolder\File.ext",
		"") ("",
		"C:\Folder\SubFolder\File.ext",
		"") 1;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("C:\Folder\SubFolder\File.ext", -1, 1),
		("")) (
		("C:\Folder\SubFolder\File.ext", -1, 0),
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	Return $sucessAll;
}
	Function UpdateToRemove_Case($filePathList, $filePathListToDelete, $remotionCountdown) {
		$orderedMap = GetFileMap $filePathList;
		$orderedMapToModify = GetFileMap $filePathListToDelete;
		$toModifyList = [System.Collections.ArrayList]::new();
		ForEach($nameKey In $orderedMapToModify.List()) {
			$toModifyFile = $orderedMapToModify.Get($nameKey).Get(-1).Get(-1);
			$Null = $toModifyList.Add($toModifyFile);
		}
		$orderedMap = UpdateToRemove $orderedMap $toModifyList $Null $remotionCountdown $True;
		Return $orderedMap;
	}
Function Test_UpdateToModify() {
	$sucessAll = $True;
	PrintText ('TEST: Orig(F1(B))->Dest(F1(A), F2(1)) --($maxVersionLimit=1,$remotionCountdown=1)--> Dest(F1_v1(A), F1(A), F2_r1(1), F2(1))');
	PrintText ("'UpdateToRemove /V=1 /R=1 /L': Deve criar uma versão e remoção");
	$orderedMap = UpdateToModify_Case ("",
		"C:\Folder\SubFolder\File1.ext",
		"C:\Folder\SubFolder\File2.ext",
		"") ("",
		"C:\Folder\SubFolder\File1.ext",
		"") 1 ("",
		"C:\Folder\SubFolder\File2.ext",
		"") 1;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File1.ext", -1, -1),
		("C:\Folder\SubFolder\File2.ext", -1, -1),
		("C:\Folder\SubFolder\File1.ext", 1, -1),
		("C:\Folder\SubFolder\File2.ext", -1, 1),
		("")) (
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ('TEST: Orig(F(5))->Dest(F_v1_r1(1), F_v1(1), F_v2(3), F_v3(3), F(4)) --($maxVersionLimit=3,$remotionCountdown=5)--> Dest(F_v1(2), F_v2(3), F_v3(4), F(4))');
	PrintText ("'UpdateToRemove /V=3 /R=5 /L': Deve remover v1");
	PrintText ("(v3 se torna v2, v2 se torna v1, e v1 é deletado, mas não v1_r1)");
	$orderedMap = UpdateToModify_Case ("",
		"C:\Folder\SubFolder\File _version[1] _removeIn[1].ext",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[3].ext",
		"C:\Folder\SubFolder\File.ext",
		"") ("",
		"C:\Folder\SubFolder\File.ext",
		"") 3 ("",
		"") 5;
	# EchoFileMap $orderedMap;
	$sucess = TestFilePresence $orderedMap (
		("C:\Folder\SubFolder\File.ext", -1, -1),
		("C:\Folder\SubFolder\File.ext", 1, -1),
		("C:\Folder\SubFolder\File.ext", 2, -1),
		("C:\Folder\SubFolder\File.ext", 3, -1),
		("C:\Folder\SubFolder\File.ext", 1, 1),
		("")) (
		(""));
	If(-Not $sucess) { $sucessAll = $False; }
	Return $sucessAll;
}
	Function UpdateToModify_Case($filePathList, $filePathListToModify, $maxVersionLimit, $filePathListToDelete, $remotionCountdown) {
		$orderedMap = GetFileMap $filePathList;
		$orderedMapToModify = GetFileMap $filePathListToModify;
		$toModifyList = [System.Collections.ArrayList]::new();
		ForEach($nameKey In $orderedMapToModify.List()) {
			$toModifyFile = $orderedMapToModify.Get($nameKey).Get(-1).Get(-1);
			$Null = $toModifyList.Add($toModifyFile);
		}
		$orderedMapToRemove = GetFileMap $filePathListToDelete;
		$toRemoveList = [System.Collections.ArrayList]::new();
		ForEach($nameKey In $orderedMapToRemove.List()) {
			$toRemoveFile = $orderedMapToRemove.Get($nameKey).Get(-1).Get(-1);
			$Null = $toRemoveList.Add($toRemoveFile);
		}
		$orderedMap = UpdateToVersion $orderedMap $toModifyList $maxVersionLimit $True;
		$orderedMap = UpdateToRemove $orderedMap $toRemoveList $Null $remotionCountdown $True;
		Return $orderedMap;
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
	$sucessTest_RoboVersion_3 = Test_RoboVersion_3 $testOrigPath $testDestPath;
	$sucessTest_RoboVersion_4 = Test_RoboVersion_4 $testOrigPath $testDestPath;
	$sucessTest_RoboVersion_5 = Test_RoboVersion_5 $testOrigPath $testDestPath;
	$sucessTest_RoboVersion_6 = Test_RoboVersion_6 $testOrigPath $testDestPath;
	$sucessTest_RoboVersion_7 = Test_RoboVersion_7 $testOrigPath $testDestPath;
	$sucessTest_RoboVersion_8 = Test_RoboVersion_8 $testOrigPath $testDestPath;
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
	Function NewFile($fileRootPath, $fileName, $fileContent) {
		$dummyFilePath = (Join-Path -Path $fileRootPath -ChildPath $fileName);
		$Null = New-Item -Path $dummyFilePath;
		$Null = Set-Content -LiteralPath $dummyFilePath $fileContent;
		Return $dummyFilePath;
	}
	Function NewFolder($folderRootPath, $folderName) {
		$dummyFolderPath = (Join-Path -Path $folderRootPath -ChildPath $folderName);
		$Null = New-Item -Path $dummyFolderPath -ItemType Directory;
		Return $dummyFolderPath;
	}
	Function ModFile($filePath, $content) {
		$Null = Set-Content -LiteralPath $filePath $content;
	}
	Function DelFile($filePath) {
		$Null = Remove-Item -LiteralPath $filePath -Recurse -Force;
	}
	Function DelFolder($folderPath) {
		$Null = Remove-Item -LiteralPath $folderPath -Recurse -Force;
	}
	Function TestRealFilePresence($needsToHave, $cannotHave) {
		$sucess = $True;
		ForEach($file In $needsToHave) {
			If($file.Count -eq 3) {
				$filePath = (Join-Path -Path $file[0] -ChildPath $file[1]);
				If(-Not (Test-Path -LiteralPath $filePath)) {
					$sucess = $False;
				} Else {
					If($file[2] -eq "") {
						Continue;
					}
					$fileContent = (Get-Content -LiteralPath $filePath);
					If(-Not ($fileContent -eq $file[2])) { $sucess = $False; }
				}
			}
		}
		ForEach($file In $cannotHave) {
			If($file.Count -eq 3) {
				$filePath = (Join-Path -Path $file[0] -ChildPath $file[1]);
				If(Test-Path -LiteralPath $filePath) {
					$sucess = $False;
				}
			}
		}
		PrintText ("FUNCIONA: " + $sucess);
		PrintText ("");
		PrintText ("");
		PrintText ("");
		Return $sucess;
	}
Function Test_RoboVersion_1($testOrigPath, $testDestPath) {
	$sucessAll = $True;
	PrintText ("TEST BATCH: Versionamento e remoção básicos");
	PrintText ("");
	PrintText ("TEST: Orig(New_F(A)) --(V=3,R=5)--> Dest(F(A))");
	PrintText ("'RoboVersion /V=3 /R=5': Espelhamento básico de 1 arquivo");
	$dummyFilePath = (NewFile $testOrigPath "FILE" "A");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_F(B)) --(V=3,R=5)--> Dest(F_v1(A), F(B))");
	PrintText ("'RoboVersion /V=3 /R=5': 1º versionamento");
	ModFile $dummyFilePath "B";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "B"),
		($testDestPath, "FILE _version[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_F(C)) --(V=3,R=5)--> Dest(F_v1(A), F_v2(B), F(C))");
	PrintText ("'RoboVersion /V=3 /R=5': 2º versionamento");
	ModFile $dummyFilePath "C";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "C"),
		($testDestPath, "FILE _version[2]", "B"),
		($testDestPath, "FILE _version[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_F(D)) --(V=3,R=5)--> Dest(F_v1(A), F_v2(B), F_v3(C), F(D))");
	PrintText ("'RoboVersion /V=3 /R=5': 3º versionamento");
	ModFile $dummyFilePath "D";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "D"),
		($testDestPath, "FILE _version[3]", "C"),
		($testDestPath, "FILE _version[2]", "B"),
		($testDestPath, "FILE _version[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_F(E)) --(V=3,R=5)--> Dest(F_v1(B), F_v2(C), F_v3(D), F(E))");
	PrintText ("'RoboVersion /V=3 /R=5': 4º versionamento, removendo velhas versões");
	ModFile $dummyFilePath "E";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "E"),
		($testDestPath, "FILE _version[3]", "D"),
		($testDestPath, "FILE _version[2]", "C"),
		($testDestPath, "FILE _version[1]", "B"),
	("")) (
		($testDestPath, "FILE _version[0]", "A"),
		($testDestPath, "FILE _version[4]", "D"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_F(F)) --(V=3,R=5)--> Dest(F_v1(C), F_v2(D), F_v3(E), F(F))");
	PrintText ("'RoboVersion /V=3 /R=5': 5º versionamento, removendo velhas versões");
	ModFile $dummyFilePath "F";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "F"),
		($testDestPath, "FILE _version[3]", "E"),
		($testDestPath, "FILE _version[2]", "D"),
		($testDestPath, "FILE _version[1]", "C"),
	("")) (
		($testDestPath, "FILE _version[0]", "B"),
		($testDestPath, "FILE _version[4]", "E"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Del_F(F)) --(V=3,R=5)--> Dest(F_v1_r5(C), F_v2_r5(D), F_v3_r5(E), F_r5(F))");
	PrintText ("'RoboVersion /V=3 /R=5': Remoção");
	DelFile $dummyFilePath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[5]", "F"),
		($testDestPath, "FILE _version[3] _removeIn[5]", "E"),
		($testDestPath, "FILE _version[2] _removeIn[5]", "D"),
		($testDestPath, "FILE _version[1] _removeIn[5]", "C"),
	("")) (
		($testDestPath, "FILE", "F"),
		($testDestPath, "FILE _version[3]", "E"),
		($testDestPath, "FILE _version[2]", "D"),
		($testDestPath, "FILE _version[1]", "C"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_v1_r4(C), F_v2_r4(D), F_v3_r4(E), F_r4(F))");
	PrintText ("'RoboVersion /V=3 /R=5': 1º countdown");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[4]", "F"),
		($testDestPath, "FILE _version[3] _removeIn[4]", "E"),
		($testDestPath, "FILE _version[2] _removeIn[4]", "D"),
		($testDestPath, "FILE _version[1] _removeIn[4]", "C"),
	("")) (
		($testDestPath, "FILE _removeIn[5]", "F"),
		($testDestPath, "FILE _version[3] _removeIn[5]", "E"),
		($testDestPath, "FILE _version[2] _removeIn[5]", "D"),
		($testDestPath, "FILE _version[1] _removeIn[5]", "C"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_v1_r3(C), F_v2_r3(D), F_v3_r3(E), F_r3(F))");
	PrintText ("'RoboVersion /V=3 /R=5': 2º countdown");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[3]", "F"),
		($testDestPath, "FILE _version[3] _removeIn[3]", "E"),
		($testDestPath, "FILE _version[2] _removeIn[3]", "D"),
		($testDestPath, "FILE _version[1] _removeIn[3]", "C"),
	("")) (
		($testDestPath, "FILE _removeIn[4]", "F"),
		($testDestPath, "FILE _version[3] _removeIn[4]", "E"),
		($testDestPath, "FILE _version[2] _removeIn[4]", "D"),
		($testDestPath, "FILE _version[1] _removeIn[4]", "C"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_v1_r2(C), F_v2_r2(D), F_v3_r2(E), F_r2(F))");
	PrintText ("'RoboVersion /V=3 /R=5': 3º countdown");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[2]", "F"),
		($testDestPath, "FILE _version[3] _removeIn[2]", "E"),
		($testDestPath, "FILE _version[2] _removeIn[2]", "D"),
		($testDestPath, "FILE _version[1] _removeIn[2]", "C"),
	("")) (
		($testDestPath, "FILE _removeIn[3]", "F"),
		($testDestPath, "FILE _version[3] _removeIn[3]", "E"),
		($testDestPath, "FILE _version[2] _removeIn[3]", "D"),
		($testDestPath, "FILE _version[1] _removeIn[3]", "C"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_v1_r1(C), F_v2_r1(D), F_v3_r1(E), F_r1(F))");
	PrintText ("'RoboVersion /V=3 /R=5': 4º countdown");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[1]", "F"),
		($testDestPath, "FILE _version[3] _removeIn[1]", "E"),
		($testDestPath, "FILE _version[2] _removeIn[1]", "D"),
		($testDestPath, "FILE _version[1] _removeIn[1]", "C"),
	("")) (
		($testDestPath, "FILE _removeIn[2]", "F"),
		($testDestPath, "FILE _version[3] _removeIn[2]", "E"),
		($testDestPath, "FILE _version[2] _removeIn[2]", "D"),
		($testDestPath, "FILE _version[1] _removeIn[2]", "C"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_v1_r0(C), F_v2_r0(D), F_v3_r0(E), F_r0(F))");
	PrintText ("'RoboVersion /V=3 /R=5': 5º countdown, o último");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[0]", "F"),
		($testDestPath, "FILE _version[3] _removeIn[0]", "E"),
		($testDestPath, "FILE _version[2] _removeIn[0]", "D"),
		($testDestPath, "FILE _version[1] _removeIn[0]", "C"),
	("")) (
		($testDestPath, "FILE _removeIn[1]", "F"),
		($testDestPath, "FILE _version[3] _removeIn[1]", "E"),
		($testDestPath, "FILE _version[2] _removeIn[1]", "D"),
		($testDestPath, "FILE _version[1] _removeIn[1]", "C"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest()");
	PrintText ("'RoboVersion /V=3 /R=5': Deve deletar tudo!");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, "FILE _removeIn[0]", "F"),
		($testDestPath, "FILE _version[3] _removeIn[0]", "E"),
		($testDestPath, "FILE _version[2] _removeIn[0]", "D"),
		($testDestPath, "FILE _version[1] _removeIn[0]", "C"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	Return $sucessAll;
}
Function Test_RoboVersion_2($testOrigPath, $testDestPath) {
	$sucessAll = $True;
	PrintText ("TEST: Orig(New_F(A)) --(V=3,R=5)--> Dest(F(A))");
	PrintText ("'RoboVersion /V=3 /R=5': Deve espelhar");
	$dummyFilePath = (NewFile $testOrigPath "FILE" "A");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_F(B)) --(V=3,R=5)--> Dest(F_v1(A), F(B))");
	PrintText ("'RoboVersion /V=3 /R=5': 1º versão");
	ModFile $dummyFilePath "B";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "B"),
		($testDestPath, "FILE _version[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_F(C)) --(V=3,R=5)--> Dest(F_v1(A), F_v2(B), F(C))");
	PrintText ("'RoboVersion /V=3 /R=5': 2º versão");
	ModFile $dummyFilePath "C";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "C"),
		($testDestPath, "FILE _version[2]", "B"),
		($testDestPath, "FILE _version[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_F(D)) --(V=3,R=5)--> Dest(F_v1(A), F_v2(B), F_v3(C), F(D))");
	PrintText ("'RoboVersion /V=3 /R=5': 3º versão");
	ModFile $dummyFilePath "D";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "D"),
		($testDestPath, "FILE _version[3]", "C"),
		($testDestPath, "FILE _version[2]", "B"),
		($testDestPath, "FILE _version[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Del_F(D)) --(V=3,R=5)--> Dest(F_v1_r5(A), F_v2_r5(B), F_v3_r5(C), F_r5(D))");
	PrintText ("'RoboVersion /V=3 /R=5': Remoção");
	DelFile $dummyFilePath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[5]", "D"),
		($testDestPath, "FILE _version[3] _removeIn[5]", "C"),
		($testDestPath, "FILE _version[2] _removeIn[5]", "B"),
		($testDestPath, "FILE _version[1] _removeIn[5]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(New_F(Z)) --(V=3,R=5)--> Dest(F_v1_r4(A), F_v2_r4(B), F_v3_r4(C), F_r4(D), F(Z))");
	PrintText ("'RoboVersion /V=3 /R=5': 1º countdown, com espelhamento");
	$dummyFilePath = (NewFile $testOrigPath "FILE" "Z");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "Z"),
		($testDestPath, "FILE _removeIn[4]", "D"),
		($testDestPath, "FILE _version[3] _removeIn[4]", "C"),
		($testDestPath, "FILE _version[2] _removeIn[4]", "B"),
		($testDestPath, "FILE _version[1] _removeIn[4]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_F(Y)) --(V=3,R=5)--> Dest(F_v1_r3(A), F_v2_r3(B), F_v3_r3(C), F_r3(D), F_v1(Z), F(Y))");
	PrintText ("'RoboVersion /V=3 /R=5': 2º countdown, 1ª versão");
	ModFile $dummyFilePath "Y";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "Y"),
		($testDestPath, "FILE _version[1]", "Z"),
		($testDestPath, "FILE _removeIn[3]", "D"),
		($testDestPath, "FILE _version[3] _removeIn[3]", "C"),
		($testDestPath, "FILE _version[2] _removeIn[3]", "B"),
		($testDestPath, "FILE _version[1] _removeIn[3]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_F(W)) --(V=3,R=5)--> Dest(F_v1_r2(A), F_v2_r2(B), F_v2_r2(C), F_r2(D), F_v1(Z), F_v2(Y), F(W))");
	PrintText ("'RoboVersion /V=3 /R=5': 3º countdown, 2ª versão");
	ModFile $dummyFilePath "W";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "W"),
		($testDestPath, "FILE _version[2]", "Y"),
		($testDestPath, "FILE _version[1]", "Z"),
		($testDestPath, "FILE _removeIn[2]", "D"),
		($testDestPath, "FILE _version[3] _removeIn[2]", "C"),
		($testDestPath, "FILE _version[2] _removeIn[2]", "B"),
		($testDestPath, "FILE _version[1] _removeIn[2]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Del_F(W)) --(V=3,R=5)--> Dest(F_v1_r1(A), F_v2_r1(B), F_v1_r1(C), F_r1(D), F_v1_r5(Z), F_v2_r5(Y), F_r5(W))");
	PrintText ("'RoboVersion /V=3 /R=5': 4º countdown, e remoção");
	DelFile $dummyFilePath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[5]", "W"),
		($testDestPath, "FILE _version[2] _removeIn[5]", "Y"),
		($testDestPath, "FILE _version[1] _removeIn[5]", "Z"),
		($testDestPath, "FILE _removeIn[1]", "D"),
		($testDestPath, "FILE _version[3] _removeIn[1]", "C"),
		($testDestPath, "FILE _version[2] _removeIn[1]", "B"),
		($testDestPath, "FILE _version[1] _removeIn[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_v1_r0(A), F_v2_r0(B), F_v1_r0(C), F_r0(D), F_v1_r4(Z), F_v2_r4(Y), F_r4(W))");
	PrintText ("'RoboVersion /V=3 /R=5': 5º countdown, o último, 1º countdown");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[4]", "W"),
		($testDestPath, "FILE _version[2] _removeIn[4]", "Y"),
		($testDestPath, "FILE _version[1] _removeIn[4]", "Z"),
		($testDestPath, "FILE _removeIn[0]", "D"),
		($testDestPath, "FILE _version[3] _removeIn[0]", "C"),
		($testDestPath, "FILE _version[2] _removeIn[0]", "B"),
		($testDestPath, "FILE _version[1] _removeIn[0]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_v1_r3(Z), F_v2_r3(Y), F_r3(W))");
	PrintText ("'RoboVersion /V=3 /R=5': Deletar os removidos, e 2º countdown");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[3]", "W"),
		($testDestPath, "FILE _version[2] _removeIn[3]", "Y"),
		($testDestPath, "FILE _version[1] _removeIn[3]", "Z"),
	("")) (
		($testDestPath, "FILE _removeIn[0]", "D"),
		($testDestPath, "FILE _version[3] _removeIn[0]", "C"),
		($testDestPath, "FILE _version[2] _removeIn[0]", "B"),
		($testDestPath, "FILE _version[1] _removeIn[0]", "A"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_v1_r2(Z), F_v2_r2(Y), F_r2(W))");
	PrintText ("'RoboVersion /V=3 /R=5': 3º countdown");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[2]", "W"),
		($testDestPath, "FILE _version[2] _removeIn[2]", "Y"),
		($testDestPath, "FILE _version[1] _removeIn[2]", "Z"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_v1_r1(Z), F_v2_r1(Y), F_r1(W))");
	PrintText ("'RoboVersion /V=3 /R=5': 4º countdown");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[1]", "W"),
		($testDestPath, "FILE _version[2] _removeIn[1]", "Y"),
		($testDestPath, "FILE _version[1] _removeIn[1]", "Z"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_v1_r0(Z), F_v2_r0(Y), F_r0(W))");
	PrintText ("'RoboVersion /V=3 /R=5': 5º countdown, o último");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[0]", "W"),
		($testDestPath, "FILE _version[2] _removeIn[0]", "Y"),
		($testDestPath, "FILE _version[1] _removeIn[0]", "Z"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest()");
	PrintText ("'RoboVersion /V=3 /R=5': Deletar os removidos");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, "FILE _removeIn[0]", "W"),
		($testDestPath, "FILE _version[2] _removeIn[0]", "Y"),
		($testDestPath, "FILE _version[1] _removeIn[0]", "Z"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	Return $sucessAll;
}
Function Test_RoboVersion_3($testOrigPath, $testDestPath) {
	$sucessAll = $True;
	PrintText ("TEST BATCH: Conflito entre remoção automática e remoção manual");
	PrintText ("");
	PrintText ("TEST: Orig(New_F(A)) --(V=3,R=5)--> Dest(F(A))");
	$dummyFilePath = (NewFile $testOrigPath "FILE" "A");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Del_F(A)) --(V=3,R=5)--> Dest(F_r5(A))");
	DelFile $dummyFilePath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[5]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_r4(A))");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[4]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Dest(Ren_F_r7(A), Orig(New_F(Z))) --(V=3,R=5)--> Dest(F_r6(A), F(Z))");
	$Null = Rename-Item -LiteralPath ((Join-Path -Path $testDestPath -ChildPath "FILE _removeIn[4]")) -NewName "FILE _removeIn[7]" -Force;
	$dummyFilePath = (NewFile $testOrigPath "FILE" "Z");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[6]", "A"),
		($testDestPath, "FILE", "Z"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Del_F(Z))) --(V=3,R=5)--> Dest(F_r4(A), F_r5(Z))");
	PrintText ("(r6 se torna r4, com o r5 sendo ocupado pelo novo removido)");
	DelFile $dummyFilePath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[4]", "A"),
		($testDestPath, "FILE _removeIn[5]", "Z"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_r3(A), F_r4(Z))");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[3]", "A"),
		($testDestPath, "FILE _removeIn[4]", "Z"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_r2(A), F_r3(Z))");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[2]", "A"),
		($testDestPath, "FILE _removeIn[3]", "Z"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_r1(A), F_r2(Z))");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[1]", "A"),
		($testDestPath, "FILE _removeIn[2]", "Z"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_r0(A), F_r1(Z))");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[0]", "A"),
		($testDestPath, "FILE _removeIn[1]", "Z"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest(F_r0(Z))");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[0]", "Z"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=5)--> Dest()");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, "FILE _removeIn[0]", "Z"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	Return $sucessAll;
}
Function Test_RoboVersion_4($testOrigPath, $testDestPath) {
	$sucessAll = $True;
	PrintText ("TEST BATCH: Conflito entre versão automática e versão manual");
	PrintText ("");
	PrintText ("TEST: Orig(New_F(A)) --(V=3,R=1)--> Dest(F(A))");
	$dummyFilePath = (NewFile $testOrigPath "FILE" "A");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_F(B)) --(V=3,R=1)--> Dest(F_v1(A), F(B))");
	ModFile $dummyFilePath "B";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "B"),
		($testDestPath, "FILE _version[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_F(C)) --(V=3,R=1)--> Dest(F_v1(A), F_v2(B), F(C))");
	ModFile $dummyFilePath "C";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "C"),
		($testDestPath, "FILE _version[2]", "B"),
		($testDestPath, "FILE _version[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Dest(Ren_F_v3(A)), Orig(Mod_F(D)) --(V=3,R=1)--> Dest(F_v1(B), F_v2(A), F_v3(C), F(D))");
	$Null = Rename-Item -LiteralPath ((Join-Path -Path $testDestPath -ChildPath "FILE _version[1]")) -NewName "FILE _version[3]" -Force;
	ModFile $dummyFilePath "D";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "D"),
		($testDestPath, "FILE _version[3]", "C"),
		($testDestPath, "FILE _version[2]", "A"),
		($testDestPath, "FILE _version[1]", "B"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Del_F(D)) --(V=3,R=1)--> Dest(F_v1_r1(B), F_v2_r1(A), F_v3_r1(C), F_r1(D))");
	DelFile $dummyFilePath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[1]", "D"),
		($testDestPath, "FILE _version[3] _removeIn[1]", "C"),
		($testDestPath, "FILE _version[2] _removeIn[1]", "A"),
		($testDestPath, "FILE _version[1] _removeIn[1]", "B"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest(F_v1_r0(B), F_v2_r0(A), F_v3_r0(C), F_r0(D))");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[0]", "D"),
		($testDestPath, "FILE _version[3] _removeIn[0]", "C"),
		($testDestPath, "FILE _version[2] _removeIn[0]", "A"),
		($testDestPath, "FILE _version[1] _removeIn[0]", "B"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest()");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, "FILE _removeIn[0]", "D"),
		($testDestPath, "FILE _version[3] _removeIn[0]", "C"),
		($testDestPath, "FILE _version[2] _removeIn[0]", "A"),
		($testDestPath, "FILE _version[1] _removeIn[0]", "B"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	Return $sucessAll;
}
Function Test_RoboVersion_5($testOrigPath, $testDestPath) {
	$sucessAll = $True;
	PrintText ("TEST BATCH: `"Esmagamento`" de versões presentes além do limite");
	PrintText ("");
	PrintText ("TEST: Orig(New_F(A)) --(V=3,R=1)--> Dest(F(A))");
	$dummyFilePath = (NewFile $testOrigPath "FILE" "A");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_F(B)) --(V=3,R=1)--> Dest(F_v1(A), F(B))");
	ModFile $dummyFilePath "B";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "B"),
		($testDestPath, "FILE _version[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_F(C)) --(V=3,R=1)--> Dest(F_v1(A), F_v2(B), F(C))");
	ModFile $dummyFilePath "C";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "C"),
		($testDestPath, "FILE _version[2]", "B"),
		($testDestPath, "FILE _version[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_F(D)) --(V=3,R=1)--> Dest(F_v1(A), F_v2(B), F_v3(C), F(D))");
	ModFile $dummyFilePath "D";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "D"),
		($testDestPath, "FILE _version[3]", "C"),
		($testDestPath, "FILE _version[2]", "B"),
		($testDestPath, "FILE _version[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Dest(New_F_v5(Z)), Orig() --(V=3,R=1)--> Dest(F_v1(A), F_v2(B), F_v3(C), F(D), F_v5(Z))");
	$extraDummyFilePath = (NewFile $testDestPath "FILE _version[5]" "Z");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _version[5]", "Z"),
		($testDestPath, "FILE", "D"),
		($testDestPath, "FILE _version[3]", "C"),
		($testDestPath, "FILE _version[2]", "B"),
		($testDestPath, "FILE _version[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Dest(New_F_v6(Y)), Orig() --(V=3,R=1)--> Dest(F_v1(A), F_v2(B), F_v3(C), F(D), F_v5(Z), F_v6(Y))");
	$extraDummyFilePath = (NewFile $testDestPath "FILE _version[6]" "Y");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _version[6]", "Y"),
		($testDestPath, "FILE _version[5]", "Z"),
		($testDestPath, "FILE", "D"),
		($testDestPath, "FILE _version[3]", "C"),
		($testDestPath, "FILE _version[2]", "B"),
		($testDestPath, "FILE _version[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=1,D)--> Dest(F_v1(C), F_v2(Z), F_v3(Y), F(D))");
	PrintText ("(v6 se torna v3, v5 se torna v2, e v3 se torna v1, o resto sendo deletado)");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1 -D;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _version[3]", "Y"),
		($testDestPath, "FILE _version[2]", "Z"),
		($testDestPath, "FILE", "D"),
		($testDestPath, "FILE _version[1]", "C"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=0,R=1,D)--> Dest(F(D))");
	$Null = Roboversion $testOrigPath $testDestPath -V 0 -R 1 -D;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "D"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Del_F(D)) --(V=3,R=1)--> Dest(F_r1(D))");
	DelFile $dummyFilePath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1 -D;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[1]", "D"),
	("")) (
		($testDestPath, "FILE", "D"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest(F_r0(D))");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1 -D;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[0]", "D"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest()");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1 -D;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, "FILE _removeIn[0]", "D"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	Return $sucessAll;
}
Function Test_RoboVersion_6($testOrigPath, $testDestPath) {
	$sucessAll = $True;
	PrintText ("TEST BATCH: `"Esmagamento`" de remoções presentes além do limite");
	PrintText ("");
	PrintText ("TEST: Orig(New_F(A)) --(V=3,R=5)--> Dest(F(A))");
	$dummyFilePath = (NewFile $testOrigPath "FILE" "A");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Del_F(A)) --(V=3,R=5)--> Dest(F_r5(A))");
	DelFile $dummyFilePath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[5]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Dest(New_F_r6(Z), New_F_r7(Y), New_F_r8(X), New_F_r9(W)), Orig() --(V=3,R=5)--> Dest(F_r1(A), F_r2(Z), F_r3(Y), F_r4(X), F_r5(W))");
	$dummyFilePath = (NewFile $testDestPath "FILE _removeIn[6]" "Z");
	$dummyFilePath = (NewFile $testDestPath "FILE _removeIn[7]" "Y");
	$dummyFilePath = (NewFile $testDestPath "FILE _removeIn[8]" "X");
	$dummyFilePath = (NewFile $testDestPath "FILE _removeIn[9]" "W");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 5 -D;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE _removeIn[5]", "W"),
		($testDestPath, "FILE _removeIn[4]", "X"),
		($testDestPath, "FILE _removeIn[3]", "Y"),
		($testDestPath, "FILE _removeIn[2]", "Z"),
		($testDestPath, "FILE _removeIn[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=0,D)--> Dest()");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 0 -D;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, "FILE _removeIn[5]", "W"),
		($testDestPath, "FILE _removeIn[4]", "X"),
		($testDestPath, "FILE _removeIn[3]", "Y"),
		($testDestPath, "FILE _removeIn[2]", "Z"),
		($testDestPath, "FILE _removeIn[1]", "A"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	Return $sucessAll;
}
Function Test_RoboVersion_6($testOrigPath, $testDestPath) {
	$sucessAll = $True;
	PrintText ("TEST BATCH: Versões devem seguir de 1 a V");
	PrintText ("");
	PrintText ("TEST: Orig(New_F(A)) --(V=5,R=1)--> Dest(F(A))");
	$dummyFilePath = (NewFile $testOrigPath "FILE" "A");
	$Null = Roboversion $testOrigPath $testDestPath -V 5 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Dest(New_F_v3(Z)), Orig(Mod_F(B)) --(V=5,R=1)--> Dest(F_v3(Z), F_v4(A), F(B))");
	$extraDummyFilePath = (NewFile $testDestPath "FILE _version[3]" "Z");
	ModFile $dummyFilePath "B";
	$Null = Roboversion $testOrigPath $testDestPath -V 5 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "B"),
		($testDestPath, "FILE _version[4]", "A"),
		($testDestPath, "FILE _version[3]", "Z"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_F(C)) --(V=5,R=1)--> Dest(F_v3(Z), F_v4(A), F_v5(B), F(C))");
	ModFile $dummyFilePath "C";
	$Null = Roboversion $testOrigPath $testDestPath -V 5 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "C"),
		($testDestPath, "FILE _version[5]", "B"),
		($testDestPath, "FILE _version[4]", "A"),
		($testDestPath, "FILE _version[3]", "Z"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_F(D)) --(V=5,R=1)--> Dest(F_v2(Z), F_v3(A), F_v4(B), F_v5(C), F(D))");
	ModFile $dummyFilePath "D";
	$Null = Roboversion $testOrigPath $testDestPath -V 5 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "D"),
		($testDestPath, "FILE _version[5]", "C"),
		($testDestPath, "FILE _version[4]", "B"),
		($testDestPath, "FILE _version[3]", "A"),
		($testDestPath, "FILE _version[2]", "Z"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_F(E)) --(V=5,R=1)--> Dest(F_v1(Z), F_v2(A), F_v3(B), F_v4(C), F_v5(D), F(E))");
	ModFile $dummyFilePath "E";
	$Null = Roboversion $testOrigPath $testDestPath -V 5 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "E"),
		($testDestPath, "FILE _version[5]", "D"),
		($testDestPath, "FILE _version[4]", "C"),
		($testDestPath, "FILE _version[3]", "B"),
		($testDestPath, "FILE _version[2]", "A"),
		($testDestPath, "FILE _version[1]", "Z"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_F(F)) --(V=5,R=1)--> Dest(F_v1(A), F_v2(B), F_v3(C), F_v4(D), F_v5(E), F(F))");
	ModFile $dummyFilePath "F";
	$Null = Roboversion $testOrigPath $testDestPath -V 5 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "FILE", "F"),
		($testDestPath, "FILE _version[5]", "E"),
		($testDestPath, "FILE _version[4]", "D"),
		($testDestPath, "FILE _version[3]", "C"),
		($testDestPath, "FILE _version[2]", "B"),
		($testDestPath, "FILE _version[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Del_F(F)) --(V=0,R=0,D)--> Dest()");
	DelFile $dummyFilePath;
	$Null = Roboversion $testOrigPath $testDestPath -V 0 -R 0 -D;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, "FILE", "F"),
		($testDestPath, "FILE _version[5]", "E"),
		($testDestPath, "FILE _version[4]", "D"),
		($testDestPath, "FILE _version[3]", "C"),
		($testDestPath, "FILE _version[2]", "B"),
		($testDestPath, "FILE _version[1]", "A"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	Return $sucessAll;
}
Function Test_RoboVersion_7($testOrigPath, $testDestPath) {
	$sucessAll = $True;
	PrintText ("TEST BATCH: Sub-Pastas");
	PrintText ("");
	PrintText ("TEST: Orig(New_P()) --(V=3,R=3)--> Dest(P())");
	$dummyFolderPath = (NewFolder $testOrigPath "P");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P", ""),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(P(New_F(A))) --(V=3,R=3)--> Dest(P(F(A)))");
	$dummyFilePath = (NewFile $dummyFolderPath "FILE" "A");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P", ""),
		($testDestPath, "P/FILE", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(P(Mod_F(B))) --(V=3,R=3)--> Dest(P(F_v1(A), F(B)))");
	ModFile $dummyFilePath "B";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P", ""),
		($testDestPath, "P/FILE", "B"),
		($testDestPath, "P/FILE _version[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(P(Del_F(B))) --(V=3,R=3)--> Dest(P(F_v1_r3(A), F_r3(B)))");
	DelFile $dummyFilePath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P", ""),
		($testDestPath, "P/FILE _removeIn[3]", "B"),
		($testDestPath, "P/FILE _version[1] _removeIn[3]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Del_P()) --(V=3,R=3)--> Dest(P_r(F_v1_r2(A), F_r2(B)))");
	DelFolder $dummyFolderPath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P _removeIfEmpty", ""),
		($testDestPath, "P _removeIfEmpty/FILE _removeIn[2]", "B"),
		($testDestPath, "P _removeIfEmpty/FILE _version[1] _removeIn[2]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=3)--> Dest(P_r(F_v1_r1(A), F_r1(B)))");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P _removeIfEmpty", ""),
		($testDestPath, "P _removeIfEmpty/FILE _removeIn[1]", "B"),
		($testDestPath, "P _removeIfEmpty/FILE _version[1] _removeIn[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=3)--> Dest(P_r(F_v1_r0(A), F_r0(B)))");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P _removeIfEmpty", ""),
		($testDestPath, "P _removeIfEmpty/FILE _removeIn[0]", "B"),
		($testDestPath, "P _removeIfEmpty/FILE _version[1] _removeIn[0]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=3)--> Dest(P_r())");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P _removeIfEmpty", ""),
	("")) (
		($testDestPath, "P _removeIfEmpty/FILE _removeIn[0]", "B"),
		($testDestPath, "P _removeIfEmpty/FILE _version[1] _removeIn[0]", "A"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=3)--> Dest()");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, "P _removeIfEmpty", ""),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("==============================================");
	PrintText ("TEST: Orig(New_P()) --(V=3,R=3)--> Dest(P())");
	$dummyFolderPath = (NewFolder $testOrigPath "P");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P", ""),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(P(New_F(A))) --(V=3,R=3)--> Dest(P(F(A)))");
	$dummyFilePath = (NewFile $dummyFolderPath "FILE" "A");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P", ""),
		($testDestPath, "P/FILE", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(P(Mod_F(B))) --(V=3,R=3)--> Dest(P(F_v1(A),F(B)))");
	ModFile $dummyFilePath "B";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P", ""),
		($testDestPath, "P/FILE", "B"),
		($testDestPath, "P/FILE _version[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(P(Del_F(B))) --(V=3,R=1)--> Dest(P(F_v1_r1(A),F_r1(B)))");
	DelFile $dummyFilePath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "P", ""),
		($testDestPath, "P/FILE _removeIn[1]", "B"),
		($testDestPath, "P/FILE _version[1] _removeIn[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(P()) --(V=3,R=3)--> Dest(P(F_v1_r0(A),F_r0(B)))");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P", ""),
		($testDestPath, "P/FILE _removeIn[0]", "B"),
		($testDestPath, "P/FILE _version[1] _removeIn[0]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(P()) --(V=3,R=3)--> Dest(P())");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P", ""),
	("")) (
		($testDestPath, "P/FILE _removeIn[0]", "B"),
		($testDestPath, "P/FILE _version[1] _removeIn[0]", "A"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Del_P()) --(V=3,R=3)--> Dest(P_r())");
	DelFolder $dummyFolderPath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P _removeIfEmpty", ""),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=3)--> Dest()");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, "P _removeIfEmpty", ""),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("==============================================");
	PrintText ("TEST: Orig(New_P()) --(V=3,R=3)--> Dest(P())");
	$dummyFolderPath_1 = (NewFolder $testOrigPath "P");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P", ""),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(P(New_PF(AA),New_PP())) --(V=3,R=3)--> Dest(P(PF(AA),PP()))");
	$dummyFolderPath_2 = (NewFolder $dummyFolderPath_1 "PP");
	$dummyFilePath = (NewFile $dummyFolderPath_1 "PF" "AA");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P", ""),
		($testDestPath, "P/PF", "AA"),
		($testDestPath, "P/PP", ""),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(P(PF(AA),PP(New_PPF(AAA),New_PPP()))) --(V=3,R=3)--> Dest(P(PF(AA),PP(PPF(AAA),PPP())))");
	$dummyFolderPath_3 = (NewFolder $dummyFolderPath_2 "PPP");
	$dummyFilePath = (NewFile $dummyFolderPath_2 "PPF" "AAA");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P", ""),
		($testDestPath, "P/PF", "AA"),
		($testDestPath, "P/PP", ""),
		($testDestPath, "P/PP/PPF", "AAA"),
		($testDestPath, "P/PP/PPP", ""),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(P(PF(AA),PP(PPF(AAA),PPP(New_PPPF(AAAA))))) --(V=3,R=3)--> Dest(P(PF(AA),PP(PPF(AAA),PPP(PPPF(AAAA)))))");
	$dummyFilePath = (NewFile $dummyFolderPath_3 "PPPF" "AAAA");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P", ""),
		($testDestPath, "P/PF", "AA"),
		($testDestPath, "P/PP", ""),
		($testDestPath, "P/PP/PPF", "AAA"),
		($testDestPath, "P/PP/PPP", ""),
		($testDestPath, "P/PP/PPP/PPPF", "AAAA"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(P(PF(AA),PP(PPF(AAA),PPP(Mod_PPPF(BBBB))))) --(V=3,R=3)--> Dest(P(PF(AA),PP(PPF(AAA),PPP(PPPF_v1(AAAA),PPPF(BBBB)))))");
	ModFile $dummyFilePath "BBBB";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P", ""),
		($testDestPath, "P/PF", "AA"),
		($testDestPath, "P/PP", ""),
		($testDestPath, "P/PP/PPF", "AAA"),
		($testDestPath, "P/PP/PPP", ""),
		($testDestPath, "P/PP/PPP/PPPF _version[1]", "AAAA"),
		($testDestPath, "P/PP/PPP/PPPF", "BBBB"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(P(PF(AA),PP(PPF(AAA),PPP(Del_PPPF(BBBB))))) --(V=3,R=3)--> Dest(P(PF(AA),PP(PPF(AAA),PPP(PPPF_v1_r3(AAAA),PPPF_r3(BBBB)))))");
	DelFile $dummyFilePath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P", ""),
		($testDestPath, "P/PF", "AA"),
		($testDestPath, "P/PP", ""),
		($testDestPath, "P/PP/PPF", "AAA"),
		($testDestPath, "P/PP/PPP", ""),
		($testDestPath, "P/PP/PPP/PPPF _version[1] _removeIn[3]", "AAAA"),
		($testDestPath, "P/PP/PPP/PPPF _removeIn[3]", "BBBB"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Del_P(PF(AA),PP(PPF(AAA),PPP()))) --(V=3,R=3)--> Dest(P_r(PF_r3(AA),PP_r(PPF_r3(AAA),PPP_r(PPPF_v1_r2(AAAA),PPPF_r2(BBBB)))))");
	DelFolder $dummyFolderPath_1;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P _removeIfEmpty", ""),
		($testDestPath, "P _removeIfEmpty/PF _removeIn[3]", "AA"),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty", ""),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty/PPF _removeIn[3]", "AAA"),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty/PPP _removeIfEmpty", ""),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty/PPP _removeIfEmpty/PPPF _version[1] _removeIn[2]", "AAAA"),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty/PPP _removeIfEmpty/PPPF _removeIn[2]", "BBBB"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=3)--> Dest(P_r(PF_r2(AA),PP_r(PPF_r2(AAA),PPP_r(PPPF_v1_r1(AAAA),PPPF_r1(BBBB)))))");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P _removeIfEmpty", ""),
		($testDestPath, "P _removeIfEmpty/PF _removeIn[2]", "AA"),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty", ""),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty/PPF _removeIn[2]", "AAA"),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty/PPP _removeIfEmpty", ""),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty/PPP _removeIfEmpty/PPPF _version[1] _removeIn[1]", "AAAA"),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty/PPP _removeIfEmpty/PPPF _removeIn[1]", "BBBB"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=3)--> Dest(P_r(PF_r1(AA),PP_r(PPF_r1(AAA),PPP_r(PPPF_v1_r0(AAAA),PPPF_r0(BBBB)))))");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P _removeIfEmpty", ""),
		($testDestPath, "P _removeIfEmpty/PF _removeIn[1]", "AA"),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty", ""),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty/PPF _removeIn[1]", "AAA"),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty/PPP _removeIfEmpty", ""),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty/PPP _removeIfEmpty/PPPF _version[1] _removeIn[0]", "AAAA"),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty/PPP _removeIfEmpty/PPPF _removeIn[0]", "BBBB"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=3)--> Dest(P_r(PF_r0(AA),PP_r(PPF_r0(AAA),PPP_r())))");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P _removeIfEmpty", ""),
		($testDestPath, "P _removeIfEmpty/PF _removeIn[0]", "AA"),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty", ""),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty/PPF _removeIn[0]", "AAA"),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty/PPP _removeIfEmpty", ""),
	("")) (
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty/PPP _removeIfEmpty/PPPF _version[1] _removeIn[0]", "AAAA"),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty/PPP _removeIfEmpty/PPPF _removeIn[0]", "BBBB"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=3)--> Dest(P_r(PP_r()))");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
		($testDestPath, "P _removeIfEmpty", ""),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty", ""),
	("")) (
		($testDestPath, "P _removeIfEmpty/PF _removeIn[0]", "AA"),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty/PPF _removeIn[0]", "AAA"),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty/PPP _removeIfEmpty", ""),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=3)--> Dest()");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 3;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, "P _removeIfEmpty", ""),
		($testDestPath, "P _removeIfEmpty/PP _removeIfEmpty", ""),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	Return $sucessAll;
}
Function Test_RoboVersion_8($testOrigPath, $testDestPath) {
	$sucessAll = $True;
	PrintText ("TEST BATCH: Arquivos com nomes estranhos");
	PrintText ("");
	PrintText ("TEST: Orig(New_`".file`"(A)) --(V=3,R=1)--> Dest(`".file`"(A))");
	$dummyFilePath = (NewFile $testOrigPath ".file" "A");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, ".file", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_`".file`"(B)) --(V=3,R=1)--> Dest(`"_v1.file`"(A), `".file`"(B))");
	ModFile $dummyFilePath "B";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, ".file", "B"),
		($testDestPath, " _version[1].file", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Del_`".file`"(B)) --(V=3,R=1)--> Dest(`"_v1_r1.file`"(A), `"_r1.file`"(B))");
	DelFile $dummyFilePath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, " _removeIn[1].file", "B"),
		($testDestPath, " _version[1] _removeIn[1].file", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest(`"_v1_r0.file`"(A), `"_r0.file`"(B))");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, " _removeIn[0].file", "B"),
		($testDestPath, " _version[1] _removeIn[0].file", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest()");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, " _removeIn[0].file", "B"),
		($testDestPath, " _version[1] _removeIn[0].file", "A"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("==============================================");
	PrintText ("TEST: Orig(New_`"F _version[1]`"(A)) --(V=3,R=1)--> Dest()");
	$dummyFilePath = (NewFile $testOrigPath "FILE _version[1]" "A");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, "FILE _version[1]", "A"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Del_`"F _version[1]`"(A)) --(V=3,R=1)--> Dest()");
	DelFile $dummyFilePath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, "FILE _version[1]", "A"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("==============================================");
	PrintText ("TEST: Orig(New_`"F _version[AAA]`"(A)) --(V=3,R=1)--> Dest()");
	$dummyFilePath = (NewFile $testOrigPath "FILE _version[AAA]" "A");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, "FILE _version[AAA]", "A"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Del_`"F _version[AAA]`"(A)) --(V=3,R=1)--> Dest()");
	DelFile $dummyFilePath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, "FILE _version[AAA]", "A"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("==============================================");
	PrintText ("TEST: Orig(New_`"F.ext _version[1]`"(A)) --(V=3,R=1)--> Dest()");
	PrintText ("(Infelizmente, o nome do arquivo não deve ter a tag em nenhuma posição)");
	$dummyFilePath = (NewFile $testOrigPath "FILE.ext _version[1]" "A");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, "FILE.ext _version[1]", "A"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Del_`"F.ext _version[1]`"(A)) --(V=3,R=1)--> Dest()");
	DelFile $dummyFilePath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, "FILE.ext _version[1]", "A"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("==============================================");
	PrintText ("TEST: Orig(New_`"F.ext _removeIn[1]`"(A)) --(V=3,R=1)--> Dest()");
	PrintText ("(Infelizmente, o nome do arquivo não deve ter a tag em nenhuma posição)");
	$dummyFilePath = (NewFile $testOrigPath "FILE.ext _removeIn[1]" "A");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, "FILE.ext _removeIn[1]", "A"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Del_`"F.ext _removeIn[1]`"(A)) --(V=3,R=1)--> Dest()");
	DelFile $dummyFilePath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, "FILE.ext _removeIn[1]", "A"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("==============================================");
	PrintText ("TEST: Orig(New_`"F-F+my+two.2.1_beta.ext`"(A)) --(V=3,R=1)--> Dest(`"F-F+my+two.2.1_beta.ext`"(A))");
	$dummyFilePath = (NewFile $testOrigPath "F-F+my+two.2.1_beta.ext" "A");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "F-F+my+two.2.1_beta.ext", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_`"F-F+my+two.2.1_beta.ext`"(B)) --(V=3,R=1)--> Dest(`"F-F+my+two.2.1_beta_v1.ext`"(A), `"F-F+my+two.2.1_beta.ext`"(B))");
	ModFile $dummyFilePath "B";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "F-F+my+two.2.1_beta.ext", "B"),
		($testDestPath, "F-F+my+two.2.1_beta _version[1].ext", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Del_`"F-F+my+two.2.1_beta.ext`"(B)) --(V=3,R=1)--> Dest(`"F-F+my+two.2.1_beta_v1_r1.ext`"(A), `"F-F+my+two.2.1_beta_r1.ext`"(B))");
	DelFile $dummyFilePath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "F-F+my+two.2.1_beta _removeIn[1].ext", "B"),
		($testDestPath, "F-F+my+two.2.1_beta _version[1] _removeIn[1].ext", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest(`"F-F+my+two.2.1_beta_v1_r0.ext`"(A), `"F-F+my+two.2.1_beta_r0.ext`"(B))");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "F-F+my+two.2.1_beta _removeIn[0].ext", "B"),
		($testDestPath, "F-F+my+two.2.1_beta _version[1] _removeIn[0].ext", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest()");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, "F-F+my+two.2.1_beta _removeIn[0].ext", "B"),
		($testDestPath, "F-F+my+two.2.1_beta _version[1] _removeIn[0].ext", "A"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("==============================================");
	PrintText ("TEST: Orig(New_`"$%&#@!.;`^[]{}ºª=¨§`"(A)) --(V=3,R=1)--> Dest(`"$%&#@!.;`^[]{}ºª=¨§`"(A))");
	$dummyFilePath = (NewFile $testOrigPath "$%&#@!.;`^[]{}ºª=¨§" "A");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "$%&#@!.;`^[]{}ºª=¨§", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_`"$%&#@!.;`^[]{}ºª=¨§`"(A)) --(V=3,R=1)--> Dest(`"$%&#@!_v1.;`^[]{}ºª=¨§`"(A), `"$%&#@!.;`^[]{}ºª=¨§`"(B))");
	ModFile $dummyFilePath "B";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "$%&#@!.;`^[]{}ºª=¨§", "B"),
		($testDestPath, "$%&#@! _version[1].;`^[]{}ºª=¨§", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Del_`"$%&#@!.;`^[]{}ºª=¨§`"(A)) --(V=3,R=1)--> Dest(`"$%&#@!_v1_r1.;`^[]{}ºª=¨§`"(A), `"$%&#@!_r1.;`^[]{}ºª=¨§`"(B))");
	DelFile $dummyFilePath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "$%&#@! _removeIn[1].;`^[]{}ºª=¨§", "B"),
		($testDestPath, "$%&#@! _version[1] _removeIn[1].;`^[]{}ºª=¨§", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest(`"$%&#@!_v1_r0.;`^[]{}ºª=¨§`"(A), `"$%&#@!_r0.;`^[]{}ºª=¨§`"(B))");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, "$%&#@! _removeIn[0].;`^[]{}ºª=¨§", "B"),
		($testDestPath, "$%&#@! _version[1] _removeIn[0].;`^[]{}ºª=¨§", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest()");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, "$%&#@! _removeIn[0].;`^[]{}ºª=¨§", "B"),
		($testDestPath, "$%&#@! _version[1] _removeIn[0].;`^[]{}ºª=¨§", "A"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("==============================================");
	PrintText ("TEST: Orig(New_`" ˸`”ʔ∕`"(A)) --(V=3,R=1)--> Dest(`" ˸`”ʔ∕`"(A))");
	$dummyFilePath = (NewFile $testOrigPath " ˸`”ʔ∕" "A");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, " ˸`”ʔ∕", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Mod_`" ˸`”ʔ∕`"(B)) --(V=3,R=1)--> Dest(`" ˸`”ʔ∕_v1`"(A), `" ˸`”ʔ∕`"(B))");
	ModFile $dummyFilePath "B";
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, " ˸`”ʔ∕", "B"),
		($testDestPath, " ˸`”ʔ∕ _version[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig(Del_`" ˸`”ʔ∕`"(B)) --(V=3,R=1)--> Dest(`" ˸`”ʔ∕_v1_r1`"(A), `" ˸`”ʔ∕_r1`"(B))");
	DelFile $dummyFilePath;
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, " ˸`”ʔ∕ _removeIn[1]", "B"),
		($testDestPath, " ˸`”ʔ∕ _version[1] _removeIn[1]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest(`" ˸`”ʔ∕_v1_r0`"(A), `" ˸`”ʔ∕_r0`"(B))");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
		($testDestPath, " ˸`”ʔ∕ _removeIn[0]", "B"),
		($testDestPath, " ˸`”ʔ∕ _version[1] _removeIn[0]", "A"),
	("")) (
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("TEST: Orig() --(V=3,R=1)--> Dest()");
	$Null = Roboversion $testOrigPath $testDestPath -V 3 -R 1;
	$sucess = TestRealFilePresence (
	("")) (
		($testDestPath, " ˸`”ʔ∕ _removeIn[0]", "B"),
		($testDestPath, " ˸`”ʔ∕ _version[1] _removeIn[0]", "A"),
	(""));
	If(-Not $sucess) { $sucessAll = $False; }
	PrintText ("==============================================");
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
	PrintText ("=======================================================================");
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