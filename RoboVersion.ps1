# RoboVersion:
#   -OrigPath, -OP:
#     Cominho da pasta com os arquivos a serem versionados
#     O caminho deve existir
#   -DestPath, -DP:
#     Cominho da pasta com os arquivos versionados
#     O caminho deve ser válido
#   -Threads, -T:
#     Número de processos em paralelo
#     Deve ser entre 1 e 128
#   -VersionLimit, -VL, -V:
#     A quantidade máxima de versões antes de deletar os mais antigos
#     Deve ser entre 0 e 99999
#   -RemotionCountdown, -RC, -R:
#     A quantidade de execuções do script antes de deletar os arquivos marcados como removidos
#     Deve ser entre 0 e 99999
#   -Destructive, -D:
#     Garante que não haja arquivos versionados e removidos acima do valor da versão e remoção dados
#   - ListOnly, -LO, -L:
#     Lista apenas, sem alterar os arquivos
Function RoboVersion {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory = $True, Position = 0, HelpMessage = "Caminho absoluto dos arquivos a serem versionados")]
			[Alias("OP")]
			[ValidateScript({
				If(-Not (Test-Path -Path $_)) {
					Throw [System.Management.Automation.ItemNotFoundException] "A pasta '${_}' não foi encontrada!"
				} Else {
					$True;
				}
			})]
			[string] $OrigPath,
		[Parameter(Mandatory = $True, Position = 1, HelpMessage = "Caminho absoluto da pasta de destino dos arquivos versionados")]
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
	. (Join-Path -Path $PSScriptRoot -ChildPath "\Functions\FileMap.ps1");
	. (Join-Path -Path $PSScriptRoot -ChildPath "\Functions\Functions.ps1");
	. (Join-Path -Path $PSScriptRoot -ChildPath "\Functions\FileManager.ps1");
	. (Join-Path -Path $PSScriptRoot -ChildPath "\Functions\UpdateVersioned.ps1");
	. (Join-Path -Path $PSScriptRoot -ChildPath "\Functions\UpdateRemoved.ps1");
	. (Join-Path -Path $PSScriptRoot -ChildPath "\Functions\UpdateToVersion.ps1");
	. (Join-Path -Path $PSScriptRoot -ChildPath "\Functions\UpdateToRemove.ps1");
	. (Join-Path -Path $PSScriptRoot -ChildPath "\Functions\Mirror.ps1");
	PrintText ("");
	PrintText ("");
	PrintText ("RoboVersion: " + $OrigPath + " ---> " + $DestPath);
	PrintText ("");
	# Lista os arquivos versionados e removidos
	PrintText ("Escaneando por versionados e removidos...");
	$modifiedLists = (GetModifiedFilesMap $DestPath $Threads);
	$modifiedFilesMap = $modifiedLists.ModifiedFilesMap;
	$removedFoldersList = $modifiedLists.RemovedFoldersList;
	PrintText ("");
	# Atualiza os arquivos versionados e removidos em $DestPath
	PrintText ("Etapa 1: Tratar arquivos versionados no destino");
	$modifiedFilesMap = (UpdateVersioned $modifiedFilesMap $VersionLimit $Destructive $ListOnly);
	PrintText ("");
	PrintText ("Etapa 2: Tratar arquivos removidos no destino");
	$modifiedFilesMap = (UpdateRemoved $modifiedFilesMap $removedFoldersList $RemotionCountdown $Destructive $ListOnly);
	PrintText ("");
	# Lista os arquivos a versionar ou remover
	PrintText ("Escaneando por arquivos a serem modificados ou deletados...");
	$willModifyLists = (GetWillModifyFilesMap $OrigPath $DestPath $Threads);
	$toVersionList = $willModifyLists.WillModifyList;
	$toRemoveList = $willModifyLists.WillDeleteList;
	$toRemoveFolderList = $willModifyLists.WillDeleteFolderList;
	PrintText ("");
	# Atualiza os arquivos a versionar ou remover em $DestPath
	PrintText ("Etapa 3: Criar versões de arquivos modificados na origem");
	$modifiedFilesMap = (UpdateToVersion $modifiedFilesMap $toVersionList $VersionLimit $ListOnly);
	PrintText ("");
	PrintText ("Etapa 4: Criar remoções de arquivos deletados na origem");
	$modifiedFilesMap = (UpdateToRemove $modifiedFilesMap $toRemoveList $toRemoveFolderList $RemotionCountdown $ListOnly);
	PrintText ("");
	PrintText ("Etapa 5: Iniciar Robocopy e realizar espelhamento");
	# Realiza a cópia
	Mirror $OrigPath $DestPath $Threads $ListOnly;
	PrintText ("");
	PrintText ("RoboVersion: Concluído");
	PrintText ("");
}