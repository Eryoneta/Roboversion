# Realiza a cópia
Function Mirror($OrigPath, $DestPath, $Threads, $ListOnly) {
	$list = "";
	If($ListOnly) {
		$list = "/L";
	}
	Robocopy $OrigPath $DestPath /MIR /SJ /SL /R:1 /W:0 /MT:$Threads `
		/XF `
			$wildcardOfVersionedFile `
			$wildcardOfRemovedFile `
		/XD `
			$wildcardOfRemovedFolder `
		$list /NJH /NJS;
	PrintText ("");
}