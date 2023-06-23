# Atualiza os arquivos-a-serem-sobrescritos com uma nova versão
#   Da lista de arquivos-modificados em $origPath, criar uma nova versão desta, com " _version[v]"
#     Checar pelas versões existentes, e adicionar uma nova versão com index v maior de todos
#     Se o index v for maior do que $maxVersionLimit:
#       Este toma $maxVersionLimit, e o anterior toma $maxVersionLimit-1, etc
#       O que tiver " _version[0]" é deletado
#     Dessa forma, existem apenas versões de 1 até $maxVersionLimit
Function UpdateToVersion($modifiedFilesMap, $toModifyFilesMap, $maxVersionLimit, $destructive, $listOnly) {
	
}