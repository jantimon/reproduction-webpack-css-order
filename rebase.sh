#!/bin/bash

# Print warning about destructive operation
echo "WARNING: This script will rebase all local branches onto main and force push them."
echo "This is a destructive operation that will rewrite commit history."
echo "Make sure you understand the implications and have backups."
read -p "Do you want to continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Operation cancelled"
    exit 1
fi

# Store current branch
current_branch=$(git symbolic-ref --short HEAD)

# Fetch latest changes
echo "Fetching latest changes..."
git fetch origin

# Get all local branches except main
branches=$(git branch | grep -v "main" | tr -d " *")

# For each branch
for branch in $branches; do
    echo "Processing branch: $branch"
    
    # Checkout the branch
    if ! git checkout "$branch"; then
        echo "Failed to checkout $branch, skipping..."
        continue
    fi
    
    # Rebase onto main
    if ! git rebase main; then
        echo "Rebase failed for $branch"
        echo "Aborting rebase and skipping this branch..."
        git rebase --abort
        continue
    fi
    
    # Force push with lease (safer than plain force push)
    if ! git push --force-with-lease origin "$branch"; then
        echo "Failed to push $branch"
        continue
    fi
    
    echo "Successfully processed $branch"
done

# Return to original branch
git checkout "$current_branch"

echo "All branches have been rebased and pushed"