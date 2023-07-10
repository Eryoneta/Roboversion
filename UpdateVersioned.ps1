# Atualiza os arquivos-versionados presentes no $destPath
#   Se $destructive = $True:
#     Apenas os $maxVersionLimit últimos arquivos-versionados são mantidos, o resto é deletado
#     Estes são nomeados de $maxVersionLimit até 1, do último ao primeiro
#     Dessa forma, os que sobrarem são sempre nomeados de 1 até $maxVersionLimit, do mais antigo ao mais novo
#   Se $destructive = $False:
#     Nada ocorre. Os arquivos com index maior do que $maxVersionLimit não são afetados e ficam indefinitivamente
Function UpdateVersioned($modifiedFilesMap, $maxVersionLimit, $destructive, $listOnly) {
	# Não-Destrutivo = Não faz nada
	If(-Not $destructive) {
		PrintText ("`tNenhuma ação necessária");
		Return $modifiedFilesMap;
	}
	# Destrutivo = Aplica $maxVersionLimit, listando arquivos para renomear ou deletar
	$filesToDelete = [System.Collections.ArrayList]::new();
	$filesToRename = [System.Collections.ArrayList]::new();
	ForEach($nameKey In $modifiedFilesMap.List()) {
		$unoccupiedVersionIndex = $maxVersionLimit;
		ForEach($versionKey In $modifiedFilesMap.Get($nameKey).List()) {
			# VersionIndex iguais a -1 são ignorados(São os sem versão)
			If($versionKey -eq -1) {
				Continue;
			}
			# Sem VersionIndex livres, então deletar
			If($unoccupiedVersionIndex -lt 1) {
				ForEach($remotionKey In $modifiedFilesMap.Get($nameKey).Get($versionKey).List()) {
					$removedFile = $modifiedFilesMap.Get($nameKey).Get($versionKey).Get($remotionKey);
					$Null = $filesToDelete.Add($removedFile);
				}
				Continue;
			}
			# VersionIndex menores que $maxVersionLimit devem permanecer assim
			If($versionKey -le $unoccupiedVersionIndex) {
				$unoccupiedVersionIndex = $versionKey;
				$unoccupiedVersionIndex--;
				Continue;
			}
			# Renomear com VersionIndex livre
			ForEach($remotionKey In $modifiedFilesMap.Get($nameKey).Get($versionKey).List()) {
				$removedFile = $modifiedFilesMap.Get($nameKey).Get($versionKey).Get($remotionKey);
				$Null = $filesToRename.Add([PSCustomObject]@{
					File = $removedFile;
					NewVersion = $unoccupiedVersionIndex;
				});
			}
			$unoccupiedVersionIndex--;
		}
	}
	# Output
	If($filesToDelete.Count -eq 0 -And $filesToRename.Count -eq 0) {
		PrintText ("`tNenhuma ação necessária");
	}
	# Da lista, deleta arquivos
	DeleteFilesList $modifiedFilesMap $filesToDelete $listOnly;
	# Da lista, renomeia arquivos
	RenameVersionedFilesList $modifiedFilesMap $filesToRename $listOnly;
	# Retorna mapa ordenado
	$modifiedFilesMap = (GetSortedFileMap $modifiedFilesMap);
	Return $modifiedFilesMap;
}