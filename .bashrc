alias clear_install="rm -rf node_modules package-lock.json && npm install"

alias vpn="openvpn3 session-start --config Downloads/profile-239.ovpn" 
alias killV="openvpn3 session-manage --config Downloads/profile-239.ovpn --disconnect"

# Navigating
alias ..="cd ../"
alias ...="cd ../../"
alias ....="cd ../../../"

# Stash all files
alias stash="git stash --keep-index -u"
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

function exposeLocalhost() {
        ssh -R 80:experts.local localhost.run
}

# Kill port
function killPort() {
        echo "Enter port to kill"
        sudo kill -9 `sudo lsof -t -i:$REPLY`
}

# Submit exercism solution
function exsub() {
    DIR="${PWD##*/}"
    FILE_TO_SUBMIT=${DIR//-/_}
    exercism submit "$FILE_TO_SUBMIT.go"
}

###### GIT WORKTREE FUNCTIONS #################

function clone_bare() {
    echo "Enter git url to clone: "
    read
    git clone --bare "$REPLY"
}

function gw_add() {
    echo "Enter branch name to add: "
    read
    git worktree add "$REPLY"
}

function gw_remove() {
    echo "Enter branch name to remove: "
    read
    git worktree remove "$REPLY"
}

function gw_add_remote() {
    echo "Enter REMOTE branch name  to add: "
    read
    git worktree add "$REPLY" "$REPLY"
}


# GIT Store credentials
function storeCreds() {
    echo "For how many days do you want your git credentials to be stored?"
    read
    TIMEOUT=$(( REPLY*86400 ))
    git config --global credential.helper "cache --timeout=$TIMEOUT"
}

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
    echo "Enter commit message: "
    read
    git commit -m "$REPLY"
}

# Add and commit
function addmit() {
    echo "Enter commit message: "
    read
    git add . && git commit -m "$REPLY"
}

# Add commit and push
function adp() {
    echo "Enter commit message: "
    read
    git add .&& git commit -m "$REPLY" && git push
}

function pub() {
    git push -u origin HEAD
}

# Commit and publish
function addpub() {
        addmit && pub
}

# Switch branch
function sw() {
    git switch $1
}

# Delete local branch
function del() {
    echo "Enter branch name: "
    read BRANCH_NAME
    git branch -d $BRANCH_NAME
}

# Force delete local branch
function fdel() {
    echo "Local branch to force delete: "
    read BRANCH_NAME
    git branch -D $BRANCH_NAME
}

# Delete branch from remote
function rdel() {
    echo "Remote branch to delete: "
    read BRANCH_NAME
    git push origin :$BRANCH_NAME
}

# Creates and checks out to new branch
function new() {
    echo "Enter branch name: "
    read BRANCH_NAME
    git checkout -b $BRANCH_NAME
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

function delete_branch() {
  # Get list of branches and store in array
  branches=($(git branch | cut -c 3-))

  # Check if there are any branches to delete
  if [ ${#branches[@]} -eq 0 ]; then
    echo "No branches to delete"
    return 0
  fi

  # Prompt user to select branch to delete
  branch=$(printf '%s\n' "${branches[@]}" | rofi -dmenu -p "Select branch to delete:")

  # Check if branch is selected
  if [ -n "$branch" ]; then
    # Delete selected branch
    git branch -D "$branch"
  else
    echo "No branch selected for deletion"
  fi
}

alias delete_branch=delete_branch

function delete_all_branches() {
  # Get the name of the currently checked out branch
  current_branch=$(git rev-parse --abbrev-ref HEAD)

  # Get list of branches and store in array
  branches=($(git branch | cut -c 3-))

  # Check if there are any branches to delete
  if [ ${#branches[@]} -eq 1 ]; then
    echo "No other branches to delete"
    return 0
  fi

  # Prompt user to confirm deletion of all branches except current
  message="Are you sure you want to delete all branches except $current_branch?"
  if ! confirm "$message"; then
    return 0
  fi

  # Loop through branches and delete all except current
  for branch in "${branches[@]}"; do
    if [ "$branch" != "$current_branch" ]; then
      git branch -D "$branch"
    fi
  done
}

function confirm() {
  # Prompt user to confirm an action
  message="$1 (y/N): "
  read -rp "$message" confirm
  case "$confirm" in
    [yY][eE][sS]|[yY]) true ;;
    *) false ;;
  esac
}

function exc() {
  read -p "please enter a commit message: " message
  git add .
  name=$(basename "$PWD")
  git commit -m "${name}: ${message}"
}
alias exc=exc
