. "./FileMap.ps1";
. "./Functions.ps1";
. "./UpdateVersioned.ps1";
. "./UpdateRemoved.ps1";
. "./UpdateToVersion.ps1";
. "./UpdateToRemove.ps1";

Function RoboVersion($origPath, $destPath, $threads, $maxVersionLimit, $remotionCountdown, $destructive) {
	
	$origPath="D:\ \BKPM\LOC1";
	$destPath="D:\ \BKPM\LOC2";
	$threads=8;
	$maxVersionLimit=3;
	$remotionCountdown=5;
	$destructive=$True;
	$listOnly=$True;
	. "./FileMap.ps1";
	. "./Functions.ps1";
	. "./UpdateVersioned.ps1";
	. "./UpdateRemoved.ps1";
	. "./UpdateToVersion.ps1";
	. "./UpdateToRemove.ps1";
	. "./DevTools.ps1";
	
	
	# Lista os arquivos versionados e removidos
	$modifiedFilesMap = (GetModifiedFilesMap $destPath $threads);
	
	Echo "============ARQUIVOS MODIFICADOS: ";
	EchoFileMap $modifiedFilesMap;
	Echo "============";
	
	# Atualiza os arquivos versionados e removidos em $destPath
	$modifiedFilesMap = (UpdateModified $modifiedFilesMap $maxVersionLimit $remotionCountdown $destructive);
	Echo "============ARQUIVOS MODIFICADOS APÓS UPDATE: ";
	EchoFileMap $modifiedFilesMap;
	Echo "============";
	
	# Lista os arquivos a versionar ou remover
	$toModifyFilesList = (GetToModifyFilesMap $origPath $destPath $threads);
	Echo "============ARQUIVOS A MODIFICAR: ";
	EchoFileMap $toModifyFilesList;
	Echo "============";
	
	# Atualiza os arquivos a versionar ou remover em $destPath
	# updateToModify $modifiedFilesMap $toModifyFilesList $maxVersionLimit $remotionCountdown $destructive;
	# Realiza a cópia
	# Robocopy $origPath $destPath;
}
	Function UpdateModified($modifiedFilesMap, $maxVersionLimit, $remotionCountdown, $destructive, $listOnly) {
		$modifiedFilesMap = (UpdateVersioned $modifiedFilesMap $maxVersionLimit $destructive $listOnly);
		$modifiedFilesMap = (UpdateRemoved $modifiedFilesMap $remotionCountdown $destructive $listOnly);
		Return $modifiedFilesMap;
	}
	Function UpdateToModify($origPath, $destPath, $threads, $maxVersionLimit, $remotionCountdown, $destructive, $listOnly) {
		UpdateToVersion $origPath $destPath $threads $maxVersionLimit $remotionCountdown $destructive $listOnly
		UpdateToRemove $origPath $destPath $threads $maxVersionLimit $remotionCountdown $destructive $listOnly
	}
