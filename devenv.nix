{ pkgs, ... }:
{
  packages = with pkgs; [
    buf
    inotify-tools
    golangci-lint
    gofumpt
  ];

  languages.go.enable = true;

  scripts.fmt.exec = "gofumpt -l -w cmd internal";

  scripts.run.exec = "go run cmd/main.go";

  scripts.watch-exec.exec = ''
    while true; do
      tmp/arian-tui
    done
  '';

  scripts.watch-build.exec = ''
    while true; do
      go build -o tmp/arian-tui ./cmd/main.go && pkill -f 'tmp/arian-tui' || true

      echo "watching for Go file changes..."
      FILES=$(find . -type f -name "*.go" ! -path "./.devenv/*")

      if [ -z "$FILES" ]; then
        echo "no Go files found! check your directory."
        exit 1
      fi

      echo "found $(echo "$FILES" | wc -l) Go files to watch"
      inotifywait -e modify,create,delete $(find . -type f -name "*.go" ! -path "./.devenv/*") || exit
    done
  '';
  git-hooks.hooks.unit-tests = {
    enable = true;

    # The name of the hook (appears on the report table):
    name = "gofumpt";

    # The command to execute (mandatory):
    entry = "gofumpt";

    # List of file types to run on (default: [ "file" ] (all files))
    # see also https://pre-commit.com/#filtering-files-with-types
    # You probably only need to specify one of `files` or `types`:
    types = [
      "go"
    ];

    # Exclude files that were matched by these patterns (default: [ ] (none)):
    excludes = [
      "direnv"
      ".devenv"
    ];

    pass_filenames = false;
  };
  dotenv.enable = true;
}
