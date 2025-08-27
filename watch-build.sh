while true; do
  go build -o _build/tmplutil ./cmd/main.go && pkill -f '_build/tmplutil' || true

  echo "Watching for Go file changes..."
  FILES=$(find . -type f -name "*.go" ! -path "./.devenv/*")

  if [ -z "$FILES" ]; then
    echo "No Go files found! Check your directory."
    exit 1
  fi

  echo "Found $(echo "$FILES" | wc -l) Go files to watch"
  inotifywait -e modify,create,delete $(find . -type f -name "*.go" ! -path "./.devenv/*") || exit
done