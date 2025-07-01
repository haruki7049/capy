{
  description = "capy - Cross-platform Zig GUI library";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    
    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {  nixpkgs, flake-utils, zig-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ zig-overlay.overlays.default ];
        };
      in
      {
        devShells.default = pkgs.mkShell rec {
          nativeBuildInputs = [
            # Core development tools
            pkgs.zigpkgs."0.14.1"

            # Build tools
            pkgs.pkg-config
            pkgs.gnumake
            
            # Android development (optional)
            pkgs.android-tools

            # Development utilities
            pkgs.gdb
            pkgs.valgrind
            pkgs.strace
          ];

          buildInputs = [
            # GTK and related libraries for Linux backend
            pkgs.gtk3
            pkgs.gtk4
            pkgs.glib
            pkgs.cairo
            pkgs.pango
            pkgs.gdk-pixbuf
            
            # OpenGL/Graphics
            pkgs.libGL
            pkgs.libGLU
            pkgs.mesa
            
            # Audio libraries
            pkgs.alsa-lib.dev
            pkgs.pipewire.dev
            
            # Code formatting and linting
            pkgs.zls # Zig Language Server
            
            # Version control
            pkgs.git
          ];

          shellHook = ''
            echo "🎨 Capy Development Environment"
            echo "Zig version: $(zig version)"
            echo ""
            echo "Available commands:"
            echo "  zig build              - Build the project"
            echo "  zig build test         - Run tests"
            echo "  zig build <example>    - Build and run specific example"
            echo ""
            echo "Examples:"
            echo "  zig build 300-buttons"
            echo "  zig build abc"
            echo "  zig build balls"
            echo "  zig build border-layout"
            echo "  zig build calculator"
            echo "  zig build colors"
            echo "  zig build demo"
            echo "  zig build dev-tools"
            echo "  zig build dummy-installer"
            echo "  zig build entry"
            echo "  zig build fade"
            echo "  zig build foo_app"
            echo "  zig build graph"
            echo "  zig build hacker-news"
            echo "  zig build many-counters"
            echo "  zig build media-player"
            echo "  zig build notepad"
            echo "  zig build osm-viewer"
            echo "  zig build slide-viewer"
            echo "  zig build tabs"
            echo "  zig build test-backend"
            echo "  zig build time-feed"
            echo "  zig build totp"
            echo "  zig build transition"
            echo "  zig build weather"
            echo ""
          '';

          env = {
            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
          };
        };
      });
}
