
function main() {
  analyseHistory=false
  # detect if last commit concerns the .github/workflows/octofirst.yml file
  # (it means that the analysis is triggered for the first time or the configuration has changed)
  last_commit=$(git log -1 --name-only --pretty=format:"%H")
  if git diff-tree --no-commit-id --name-only -r $last_commit | grep -q ".github/workflows/octofirst.yml"; then
      text_info "Last commit concerns the .github/workflows/octofirst.yml file"
      analyseHistory=true
  fi


  # If the last commit concerns the .github/workflows/octofirst.yml file, then we need to analyze the history, week by week
  if [ "$analyseHistory" = true ]; then
      text_info "Analyzing history"
      currentBranch=$(git branch --show-current)

      # Get one commit per week, 4 weeks back
      for i in {0..4}
      do
          text_info "Analyzing week $i"
          git checkout $currentBranch

          # Get the first commit 7 days ago
          commit=$(git rev-list -n 1 --before="$(date -d "$i weeks ago" --iso-8601=seconds)" $currentBranch)
          if [ -z "$commit" ]; then
              text_info "No commit found for date $(date -d "$i weeks ago" --iso-8601=seconds)"
              continue
          fi

          git checkout $commit

          # get timestamp of the commit
          GIT_DATE=$(git show -s --format=%ci)
          GIT_SHA=$(git rev-parse HEAD)

          # Execute the analysis
          analyze
      done

      git checkout $currentBranch
  else
      # Analyze the current commit only
      text_info "Analyzing current commit"
      GIT_DATE=$(git show -s --format=%ci)
      analyze
  fi

  text_info "Done"
}