# load packages
library(learnr)  #carico il pacchetto learnr

system('git config --global user.name "valentinamartino"')
system('git config --global user.email "valentina.martino@student.univaq.it"')
system('git --global ')
system('git config --local -l')
"C:\Program Files\Git\git-cmd.exe"
install.packages(c("usethis","gitcreds"))
system('git config --global user.name "valentinamartino"')
system('git config --global user.email "valentina.martino@student.univaq.it"')
gitcreds::gitcreds_set()
3
system('git --help')

system('git config --global user.name "Valentina Martino"')
system('git config --global user.email "valentina.martino@student.univaq.it"')
system('git config --global --list')
system('git remote add origin https://github.com/valentinamartino/DataManagement2026.git')

gitcreds::gitcreds_set()

usethis::use_git_remote(name = "origin", url = 'https://github.com/valentinamartino/DataManagement2026.git')