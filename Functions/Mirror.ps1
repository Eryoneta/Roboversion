# Realiza a cópia
Function Mirror($origPath, $destPath, $toModify, $listOnly) {
	If(-Not $toModify) {
		PrintText "`tNenhuma ação necessária" -FC "DarkCyan";
		# Return;  # Retirado por precaução. Mesmo que Robocopy não fazer nada, o executar
	}
	$list = "";
	If($listOnly) {
		$list = "/L";
	}
	Robocopy $origPath $destPath /MIR /SJ /SL /R:1 /W:0 `
		/XF `
			$wildcardOfVersionedFile `
			$wildcardOfRemovedFile `
		/XD `
			$wildcardOfRemovedFolder `
		$list /NJH /NJS /NDL;
	PrintText "";
}