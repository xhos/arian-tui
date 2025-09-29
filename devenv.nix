{pkgs, ...}: {
  packages = with pkgs; [
    buf
    inotify-tools
    golangci-lint
  ];

  languages.go.enable = true;

  scripts.fmt.exec = "golangci-lint fmt";

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
  pre-commit.hooks = {
    alejandra.enable = true;
    golangci-lint = {
      enable = true;
      name = "golangci-lint";
      entry = "${pkgs.golangci-lint}/bin/golangci-lint fmt";
      types = ["go"];
    };
  };

  dotenv.enable = true;
}
