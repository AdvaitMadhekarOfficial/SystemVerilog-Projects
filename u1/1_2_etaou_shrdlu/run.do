force CIPHER 8'h45
value "%c" CIPHER 
run -rel 1
value "%c" PLAIN

##RESET
reset
force CIPHER 8'h51
value "%c" CIPHER
run -rel 1   
value "%c" PLAIN
