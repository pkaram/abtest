#list all available variables that are available in the global environment
available_variables<-ls()[sapply(ls(), function(x) class(get(x))) %in% c('numeric','integer') ]
