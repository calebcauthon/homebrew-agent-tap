class Agent < Formula
  desc "Docker-backed isolated coding-agent rooms"
  homepage "https://github.com/calebcauthon/agent"
  url "https://github.com/calebcauthon/agent/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "29323258cc8b54b6a8adb2192d13be1a7721f6e6e12a77d1eb69a716d7988952"
  version "0.1.6"
  head "https://github.com/calebcauthon/agent.git", branch: "main"

  depends_on "docker"
  depends_on "git"

  def install
    libexec.install "Dockerfile"
    libexec.install "claude-settings.json"
    libexec.install "shell.sh"
    libexec.install "VERSION"
    libexec.install "scripts"
    libexec.install "tmux"
    libexec.install "zsh"

    %w[room agent logs rooms agents].each do |cmd|
      (bin/cmd).write <<~EOS
        #!/usr/bin/env bash
        set -e
        _ROOMS_DIR="#{libexec}"
        if [[ "${1:-}" == "--version" || "${1:-}" == "-v" ]]; then
          printf '%s %s\n' "#{cmd}" "$(cat "#{libexec}/VERSION")"
          exit 0
        fi
        source "#{libexec}/shell.sh"
        #{cmd} "$@"
      EOS
      chmod 0755, bin/cmd
    end
  end

  def caveats
    <<~EOS
      Installed commands: room, agent, logs, rooms, agents

      For shell functions instead of wrapper executables, add this to ~/.zshrc:
        export ROOMS_DIR="#{libexec}"
        source "#{libexec}/shell.sh"
    EOS
  end

  test do
    system "bash", "-n", libexec/"shell.sh"
    system "bash", "-n", libexec/"scripts/start-room.sh"
    system "bash", "-n", libexec/"scripts/start-session.sh"
    assert_match version.to_s, shell_output("#{bin}/agent --version")
  end
end
