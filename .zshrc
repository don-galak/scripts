autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# This loads nvm
source $(brew --prefix nvm)/nvm.sh

alias lox="cd && cd Documents/playground/lox && code ."

alias aliases="cd && code .zshrc"

alias sbc="source .zshrc"
alias gtb="go test -v --bench . --benchmem"

alias ..="cd ../"
alias ...="cd ../../"
alias ....="cd ../../../"

alias stash="git stash --keep-index -u"
alias pop="git stash pop"
alias a="git branch -a"
alias ps="git push"
alias pl="git pull"
alias d="git switch develop"
alias ys="BROWSER=none yarn start"
alias gen="yarn generate"
alias python="python3"

function getIp() {
ip r
}

function code() {
    VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;
}

# Kill port
function killPort() {
    echo "enter port:"
    read $port
    kill -9 `sudo lsof -t -i:$port`
}
# Expose localhost
function exposeLocalhost() {
    ssh -R 80:experts.local localhost.run
}

function clone_bare() {
    echo "Enter git url to clone: "
    git clone --bare "$REPLY"
}

function gw_add() {
    echo "Enter branch name to add: "
    git worktree add "$REPLY"
}

function gw_remove() {
    echo "Enter branch name to remove: "
    git worktree remove "$REPLY"
}

function gw_add_remote() {
    echo "Enter REMOTE branch name  to add: "
    git worktree add ../"$REPLY" "$REPLY"
}

function storeCreds() {
    echo "For how many days do you want your git credentials to be stored?"
    read
    TIMEOUT=$(( REPLY*86400 ))
    git config --global credential.helper "cache --timeout=$TIMEOUT"
}

function pub() {
    git push -u origin HEAD
}

function fpub() {
  git push -u -f --no-verify origin HEAD
}

# Delete branch from remote
function rdel() {
    echo "Remote branch to delete: "
    read BRANCH_NAME
    git push -f --no-verify origin :$BRANCH_NAME
}

function feat() {
    echo "Enter branch name: "
    read BRANCH_NAME
    git checkout -b "$BRANCH_NAME"
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
  branch=$(printf '%s\n' "${branches[@]}" | fzf --prompt="Select branch to delete:")
  # For ubuntu
  # branch=$(printf '%s\n' "${branches[@]}" | rofi -dmenu -p "Select branch to delete:")

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
  echo -n "$message"
  read confirmation
  case "$confirmation" in
    [yY][eE][sS]|[yY]) true ;;
    *) false ;;
  esac
}

alias delete_all_branches=delete_all_branches

function commit() {
  echo "please enter a commit message: "
  read COMMIT_MSG

  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  git commit -m "${CURRENT_BRANCH}: ${COMMIT_MSG}"
}

function mvc() {
  echo "please enter a commit message: "
  read COMMIT_MSG

  git add .
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  git commit -m "${CURRENT_BRANCH}: ${COMMIT_MSG}"
}
alias mvc=mvc

function switch() {
  # Get list of branches and store in array
  branches=($(git branch | cut -c 3-))

  # Check if there are any branches to switch to
  if [ ${#branches[@]} -eq 0 ]; then
    echo "No branches to switch to"
    return 0
  fi

  # Prompt user to select branch to switch to
  branch=$(printf '%s\n' "${branches[@]}" | fzf --height=30% --reverse --cycle)
  # ubuntu
  # branch=$(printf '%s\n' "${branches[@]}" | rofi -dmenu -p "Select branch to switch to:")

  if [ -n "$branch" ]; then
    git checkout "$branch"
  else
    echo "No branch selected to switch to"
  fi
}

function overwriteRemote() {
  CURRENT_BRANCH=$(git branch --show-current)
  read -p "please enter the name of the remote branch you want to overwrite: " remoteBranch
  git push -f --no-verify origin $CURRENT_BRANCH:$remoteBranch
}

alias switch=switch

# Function to compile and execute a C file
c() {
  # Check if the function is provided with an argument
  if [ $# -eq 0 ]; then
    echo "You need to provide a .c file argument"
    return 1
  fi

  # Extract the filename from the argument
  local name=$1

  # Check if the corresponding .c file exists
  if [ ! -f "$name.c" ]; then
    echo "File not found: $name.c"
    return 1
  fi

  # Compile the C file using gcc
  gcc -o "$name" "$name.c"

  # Check if the compilation was successful
  if [ $? -eq 0 ]; then
    echo "compiling..."
    # Execute the compiled program
    "./$name"
  else
    echo "Compilation failed"
  fi
}

function unstage() {
  echo 'reseting staged files\n\nIf you want to go back to head, type:\n"headate"'
	git reset --soft HEAD~
}

function headate() {
  git reset 'HEAD@{1}'
}

function fps() {
  git push -f --no-verify
}

function cl() {
  git clone $1
}

function c4() {
  corepack enable
  nvm use 18
}

alias sb="c4 && yarn storybook"

export PATH=/opt/homebrew/opt/openjdk/bin:/Users/panagiotis.tagkalakis/.nvm/versions/node/v16.13.2/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin

# opam configuration
[[ ! -r /Users/panagiotis.tagkalakis/.opam/opam-init/init.zsh ]] || source /Users/panagiotis.tagkalakis/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
