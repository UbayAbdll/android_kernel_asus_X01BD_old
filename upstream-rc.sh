git branch -D eg/20200313/f-rc
git branch -D eg/20200313/m-rc
git branch -D eg/20200313/h-rc
git branch -D qk/20200313/l-rc
git branch -D qk/20200313/n-rc
git branch -D qk/20200313/ul-rc
git branch -D private/20200313-rc
git branch -D private/20200313-oc-rc
updatream() {
    branch=$1
    git checkout $branch && git checkout -b $1-rc
    git pull . rebase-20200313 --no-ff --no-commit && git commit -s -m "merge Branch 'rebase-20200313' into $1"
    git pull . rebase-20200313-vdso32 --no-ff --no-commit && git commit -s -m "merge Branch 'rebase-20200313-vdso32' into $1"
    git pull . rebase-20200313-upstream --no-ff --no-commit && git commit -s -m "merge Branch 'rebase-20200313-upstream' into $1"
    git pull . rebase-20200313-upstream-caf-latest --no-ff --no-commit && git commit -s -m "merge Branch 'rebase-20200313-upstream-caf-latest' into $1"
    git pull . rebase-20200313-upstream-rc --no-ff --no-commit && git commit -s -m "merge Branch 'rebase-20200313-upstream-rc' into $1"
}
updatream eg/20200313/f
updatream eg/20200313/m
updatream eg/20200313/h
updatream qk/20200313/l
updatream qk/20200313/n
updatream qk/20200313/ul
updatream private/20200313
updatream private/20200313-oc
git checkout rebase-20200313
git push --all origin -f