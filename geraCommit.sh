ran=`awk -v min=5 -v max=10 'BEGIN{srand(); print int(min+rand()*(max-min+1))}'`

echo $ran >> commiter.txt

git status 
git add commiter.txt
git commit -m "forced commit"
currentBranch=`git branch | grep \* | cut -d ' ' -f2`
git push origin $currentBranch