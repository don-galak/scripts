alias clear_install="rm -rf node_modules package-lock.json && npm install"

# Stash all files
alias stashu="git stash --keep-index -u"
# Prune Origin
alias prune="git remote prune origin"


alias pop="git stash pop"
alias a="git branch -a"
alias ps="git push"
alias pl="git pull"
alias d="git switch dev"

# Merge dev to current branch
alias md="git merge dev"

# Switch to dev and pull
alias dpl="d && pl"

# Add all changes
alias add="git add ."

# NPM Scripts
alias sbuild="npm run build && serve -l 3000 -s build"
alias serve_prod="clear_install && sbuild"
alias s="npm start"
alias anal="npm run build && npm run analyze"

# Open .bashrc scripts
alias b="code .bashrc"

# Update .bashrc
alias u="source .bashrc"

##################################
#############FUNCTIONS############
##################################

# GIT CONFIG LIST
function list() {
    git config --list
}

# Get remote url
function geturl() {
    git config --get remote.origin.url
}

# Set remote url
function seturl() {
    git remote set-url origin $1
}

# Commit
function commit() {
    git commit -m "$1"
}

# Add and commit
function addmit() {
    git add . && git commit -m "$1"
}

# Add commit and push
function adp() {
    git add .&& git commit -m "$1" && git push
}

function pub() {
    git push -u origin HEAD
}

# Switch branch
function sw() {
    git switch $1
}

# Delete local branch
function del() {
    git branch -d $1
}

# Force delete local branch
function fdel() {
    git branch -D $1
}

# Delete branch from remote
function rdel() {
    git push origin :$1
}

# Creates and checks out to new branch
function new() {
    git checkout -b $1
}

# Clone git repo without its history
function no_his() {
    git clone $1 --depth 1
}

# Get IPv4 adress
function ip() {
    LOCAL_IP=${LOCAL_IP:-`ipconfig.exe | grep -im1 'IPv4 Address' | cut -d ':' -f2`}
    echo $LOCAL_IP
}

# Save current branch name
# Switch to dev branch
# pull
# switch to saved branch name
# merge dev into saved branch
function update() {
    CURRENT_BRANCH=$(git branch --show-current)
    dpl && sw $CURRENT_BRANCH && md
}

# Creates a new branch and checks out to it, adds all the changes, commits, pushes to origin, checks out to dev and deletes previous branch
# Accepts two command line arguments:
# 1: branch name
# 2: commit message
function create() {
    git checkout -b $1 &&
    git add . &&
    git commit -m "$2" &&
    git push -u origin $1 &&
    git switch dev &&
    git branch -d $1
}
