function ,
    # Set default repository
    set REPO nixpkgs

    # Parse options
    while test (count $argv) -gt 0
        switch $argv[1]
            case '-l' '--latest'
                set REPO nixpkgs-latest
                set argv $argv[2..-1]  # Remove the latest argument
            case '*'
                break
        end
    end

    # Check if a package name is provided
    if test (count $argv) -eq 0
        echo "Usage: , [-l|--latest] PACKAGE [EXTRA_ARGS...]"
        return 1
    end

    # Get the package name
    set PKG $argv[1]

    # Remove the package name from arguments to get extra arguments
    set EXTRA_ARGS $argv[2..-1]

    # Run the command with extra arguments
    nix run $REPO#$PKG -- $EXTRA_ARGS
end
