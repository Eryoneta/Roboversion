# Realiza a cópia
Function Mirror($OrigPath, $DestPath, $ListOnly) {
	$list = "";
	If($ListOnly) {
		$list = "/L";
	}
	Robocopy $OrigPath $DestPath /MIR /SJ /SL /R:1 /W:0 `
		/XF `
			$wildcardOfVersionedFile `
			$wildcardOfRemovedFile `
		/XD `
			$wildcardOfRemovedFolder `
		$list /NJH /NJS;
	PrintText ("");
}