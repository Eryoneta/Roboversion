# Atualiza os arquivos-a-serem-deletados com um novo removido
#   Da lista de arquivos-modificados em $origPath, criar uma novo removido desta, com "removeIn[$remotionCountdown]"
#     Checar pelos removidos existentes
#     Se houver um removido já com $remotionCountdown:
#       Ele recebe $remotionCountdown-1, e este recebe $remotionCountdown
#       Se houver mais, todos trocam de r até o -1 ser removido
#     Dessa forma, existem removidos apenas de $remotionCountdown até 0
Function UpdateToRemove($modifiedFilesMap, $toModifyFilesMap, $remotionCountdown, $destructive, $listOnly) {
	
}
