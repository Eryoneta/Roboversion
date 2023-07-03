Function RoboVersion {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory = $True, Position = 0, ParameterSetName = "ByParams", HelpMessage = "Caminho absoluto dos arquivos a serem versionados")]
			[Alias("OP")]
			[ValidateScript({
				If(-Not (Test-Path -Path $_)) {
					Throw [System.Management.Automation.ItemNotFoundException] "A pasta '${_}' não foi encontrada!"
				} Else {
					$True;
				}
			})]
			[string] $OrigPath,
		[Parameter(Mandatory = $True, Position = 1, ParameterSetName = "ByParams", HelpMessage = "Caminho absoluto da pasta de destino dos arquivos versionados")]
			[Alias("DP")]
			[ValidateScript({
				If(-Not (Test-Path -Path $_ -IsValid)) {
					Throw [System.Management.Automation.ItemNotFoundException] "A pasta '${_}' não é válida!";
				} Else {
					$True;
				}
			})]
			[string] $DestPath,
		[Parameter()]
			[Alias("T")]
			[ValidateRange(1,128)]
			[int] $Threads = 8,
		[Parameter()]
			[Alias("V", "VL")]
			[ValidateRange(0,99999)]
			[int] $VersionLimit = 5,
		[Parameter()]
			[Alias("R", "RC")]
			[ValidateRange(0,99999)]
			[int] $RemotionCountdown = 10,
		[Parameter()]
			[Alias("D")]
			[switch] $Destructive = $False,
		[Parameter()]
			[Alias("L", "LO")]
			[switch] $ListOnly = $False
	)
	. "./FileMap.ps1";
	. "./Functions.ps1";
	. "./FileManager.ps1";
	. "./UpdateVersioned.ps1";
	. "./UpdateRemoved.ps1";
	. "./UpdateToVersion.ps1";
	. "./UpdateToRemove.ps1";

	# PrintText $OrigPath;
	# PrintText $DestPath;
	# PrintText $Threads;
	# PrintText $VersionLimit;
	# PrintText $RemotionCountdown;
	# PrintText $Destructive;
	# PrintText $ListOnly;
	# Return;
	
	If(-Not (isOrigPathValid $OrigPath)) {
		Return;
	}
	If(-Not (isDestPathValid $DestPath)) {
		Return;
	}
	$Threads = (validateThreads $Threads);
	$VersionLimit = (validateMaxVersionLimit $VersionLimit);
	$RemotionCountdown = (validateRemotionCountdown $RemotionCountdown);
	
	# Lista os arquivos versionados e removidos
	$modifiedFilesMap = (GetModifiedFilesMap $DestPath $Threads);
	
	PrintText "============ ARQUIVOS MODIFICADOS: ";
	EchoFileMap $modifiedFilesMap;
	PrintText "============";
	
	# Atualiza os arquivos versionados e removidos em $DestPath
	$modifiedFilesMap = (UpdateVersioned $modifiedFilesMap $VersionLimit $Destructive $ListOnly);
	$modifiedFilesMap = (UpdateRemoved $modifiedFilesMap $RemotionCountdown $Destructive $ListOnly);
	PrintText "============ ARQUIVOS MODIFICADOS APÓS UPDATE: ";
	EchoFileMap $modifiedFilesMap;
	PrintText "============";
	
	# Lista os arquivos a versionar ou remover
	$toModifyFilesMap = (GetToModifyFilesMap $OrigPath $DestPath $Threads);
	PrintText "============ ARQUIVOS A MODIFICAR: ";
	EchoFileMap $toModifyFilesMap;
	PrintText "============";
	
	# Atualiza os arquivos a versionar ou remover em $DestPath
	$modifiedFilesMap = (UpdateToVersion $modifiedFilesMap $toModifyFilesMap $VersionLimit $Destructive $ListOnly);
	$modifiedFilesMap = (UpdateToRemove $modifiedFilesMap $toModifyFilesMap $RemotionCountdown $Destructive $ListOnly);
	PrintText "============ ARQUIVOS A MODIFICADOS APÓS 2º UPDATE: ";
	EchoFileMap $modifiedFilesMap;
	PrintText "============";

	# Realiza a cópia
	# Robocopy $OrigPath $DestPath /MIR /SJ /SL /R:1 /W:0 /MT:$Threads `
	# 	/XF `
	# 		$wildcardOfVersionedFile `
	# 		$wildcardOfRemovedFile `
	# 		$wildcardOfVersionedAndRemovedFile `
	# 	/XD `
	# 		$wildcardOfRemovedFolder `
	# 	/NJH /NJS;
}



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
