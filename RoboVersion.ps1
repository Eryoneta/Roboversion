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
	$modifiedFilesMap = (UpdateModified $modifiedFilesMap $maxVersionLimit $remotionCountdown $destructive $listOnly);
	Echo "============ARQUIVOS MODIFICADOS APÓS UPDATE: ";
	EchoFileMap $modifiedFilesMap;
	Echo "============";
	
	# Lista os arquivos a versionar ou remover
	$toModifyFilesMap = (GetToModifyFilesMap $origPath $destPath $threads);
	Echo "============ARQUIVOS A MODIFICAR: ";
	EchoFileMap $toModifyFilesMap;
	Echo "============";
	
	# Atualiza os arquivos a versionar ou remover em $destPath
	$modifiedFilesMap = (UpdateToModify $modifiedFilesMap $toModifyFilesMap $maxVersionLimit $remotionCountdown $destructive $listOnly);

	# Realiza a cópia
	# Robocopy $origPath $destPath;
}
	Function UpdateModified($modifiedFilesMap, $maxVersionLimit, $remotionCountdown, $destructive, $listOnly) {
		$modifiedFilesMap = (UpdateVersioned $modifiedFilesMap $maxVersionLimit $destructive $listOnly);
		$modifiedFilesMap = (UpdateRemoved $modifiedFilesMap $remotionCountdown $destructive $listOnly);
		Return $modifiedFilesMap;
	}
	Function UpdateToModify($modifiedFilesMap, $toModifyFilesMap, $maxVersionLimit, $remotionCountdown, $destructive, $listOnly) {
		$modifiedFilesMap = (UpdateToVersion $modifiedFilesMap $toModifyFilesMap $maxVersionLimit $destructive $listOnly);
		$modifiedFilesMap = (UpdateToRemove $modifiedFilesMap $toModifyFilesMap $remotionCountdown $destructive $listOnly);
		Return $modifiedFilesMap;
	}