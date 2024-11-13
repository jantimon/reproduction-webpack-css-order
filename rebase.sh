#!/bin/bash
# Print warning about destructive operation
echo "WARNING: This script will rebase all local branches onto their respective base branches and force push them."
echo "Branches ending with '-with-side-effect' will rebase onto 'side-effect'"
echo "All other branches will rebase onto 'main'"
echo "This is a destructive operation that will rewrite commit history."
echo "Make sure you understand the implications and have backups."
read -p "Do you want to continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Operation cancelled"
    exit 1
fi

# Function to handle errors
handle_error() {
    echo "Error: $1"
    exit 1
}

# Store current branch
current_branch=$(git symbolic-ref --short HEAD) || handle_error "Failed to get current branch"

# Fetch latest changes
echo "Fetching latest changes..."
git fetch origin || handle_error "Failed to fetch from origin"

# Ensure base branches exist
if ! git rev-parse --verify origin/main >/dev/null 2>&1; then
    handle_error "Main branch does not exist"
fi

if ! git rev-parse --verify origin/side-effect >/dev/null 2>&1; then
    handle_error "Side-effect branch does not exist"
fi

# Get all local branches using for-each-ref to handle spaces in branch names
git for-each-ref --format='%(refname:short)' refs/heads/ | while read -r branch; do
    # Skip main and side-effect branches
    if [[ "$branch" == "main" || "$branch" == "side-effect" ]]; then
        continue
    fi

    echo "Processing branch: $branch"
    
    # Determine base branch
    if [[ "$branch" == *-with-side-effect ]]; then
        base_branch="side-effect"
        echo "Will rebase onto side-effect branch"
    else
        base_branch="main"
        echo "Will rebase onto main branch"
    fi
    
    # Checkout the branch
    if ! git checkout "$branch"; then
        echo "Failed to checkout $branch, skipping..."
        continue
    fi
    
    # Rebase onto appropriate base branch
    if ! git rebase "$base_branch"; then
        echo "Rebase failed for $branch"
        echo "Aborting rebase and skipping this branch..."
        git rebase --abort
        continue
    fi

    # Install dependencies and build
    echo "Installing dependencies..."
    if ! pnpm install; then
        echo "Failed to install dependencies for $branch, skipping..."
        continue
    fi

    echo "Cleaning build artifacts..."
    rm -rf @applications/base/dist
    rm -rf @applications/base/.next

    echo "Building..."
    if ! pnpm run build; then
        echo "Build failed for $branch, skipping..."
        continue
    fi
    
    # Amend if changes
    if ! git diff-index --quiet HEAD --; then
        echo "Changes detected, amending commit..."
        git add .
        git commit --amend --no-edit || {
            echo "Failed to amend commit for $branch"
            continue
        }
    fi
    
    # Force push with lease
    echo "Pushing changes..."
    if ! git push --force-with-lease origin "$branch"; then
        echo "Failed to push $branch"
        continue
    fi
    
    echo "Successfully processed $branch"
done

# Return to original branch
if ! git checkout "$current_branch"; then
    handle_error "Failed to return to original branch: $current_branch"
fi

echo "All branches have been rebased and pushed"