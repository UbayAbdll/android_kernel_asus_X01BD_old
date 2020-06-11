updatream() {
    branch=$1
    git checkout $branch && git reset --hard HEAD~2
    git pull . rebase-20200313 --no-ff --no-commit && git commit -s -m "merge Branch 'rebase-20200313' into $1"
    git pull . rebase-20200313-vdso32 --no-ff --no-commit && git commit -s -m "merge Branch 'rebase-20200313-vdso32' into $1"
    git pull . rebase-20200313-upstream --no-ff --no-commit && git commit -s -m "merge Branch 'rebase-20200313-upstream' into $1"
    git pull . rebase-20200313-upstream-caf-latest --no-ff --no-commit && git commit -s -m "merge Branch 'rebase-20200313-upstream-caf-latest' into $1"
    git pull . rebase-20200313-pie-qcacld --no-ff --no-commit && git commit -s -m "merge Branch 'rebase-20200313-pie-qcacld' into $1"
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