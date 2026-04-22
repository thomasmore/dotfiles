function __pienv_usage
    printf '%s\n' \
        'Usage:' \
        '  pienv' \
        '  pienv <runtime-repo-path>' \
        '' \
        'Description:' \
        '  Magically detects project/resource paths from the current directory and' \
        '  export fish environment variables for pi-related resources.' \
        '' \
        '  Optionally accept a runtime repo path (relative or absolute). When provided,' \
        '  it overrides automatic runtime repo detection.'
end

function __pienv_find_build_dir_from_cwd --argument cwd
    set -l dir $cwd
    set -l builds_parent

    while true
        if test (basename -- "$dir") = builds
            set builds_parent $dir
            break
        end

        if test "$dir" = /
            break
        end

        set dir (dirname -- "$dir")
    end

    if test -z "$builds_parent"
        return 1
    end

    set dir $cwd
    while true
        if test -f "$dir/CMakeCache.txt"
            echo $dir
            return 0
        end

        if test "$dir" = "$builds_parent"
            break
        end

        set dir (dirname -- "$dir")
    end

    echo "pienv: found parent directory named 'builds', but no CMakeCache.txt between $cwd and $builds_parent" >&2
    return 1
end

function __pienv_find_runtime_repo_from_cwd --argument cwd
    set -l dir $cwd

    while true
        if test (basename -- "$dir") = static_core
            echo $dir
            return 0
        end

        if test "$dir" = /
            break
        end

        set dir (dirname -- "$dir")
    end

    return 1
end

function __pienv_find_latest_build_dir --argument builds_dir
    if not test -d "$builds_dir"
        echo "pienv: builds directory not found: $builds_dir" >&2
        return 1
    end

    set -l latest_dir (find "$builds_dir" -mindepth 1 -maxdepth 1 -type d -printf '%T@\t%p\n' | sort -nr | awk 'NR == 1 { print $2 }')
    if test -z "$latest_dir"
        echo "pienv: no build directories found in $builds_dir" >&2
        return 1
    end

    echo $latest_dir
end

function __pienv_read_cmake_cache_value --argument cache_file key
    awk -F= -v key="$key" '$1 == key { print substr($0, index($0, "=") + 1); exit }' "$cache_file"
end

function pienv --description 'Populate PI_* path environment variables for the current fish shell'
    if test (count $argv) -ge 1
        switch $argv[1]
            case -h --help
                __pienv_usage
                return 0
        end
    end

    if test (count $argv) -gt 1
        echo "pienv: expected at most one optional argument: <runtime-repo-path>" >&2
        return 1
    end

    set -l cwd (pwd -P)
    set -l runtime_repo_override
    if test (count $argv) -eq 1
        set runtime_repo_override $argv[1]
    end

    set -l build_dir
    set -l runtime_repo

    if test -n "$runtime_repo_override"
        set runtime_repo (realpath "$runtime_repo_override")
        if not test -d "$runtime_repo"
            echo "pienv: runtime repo path is not a directory: $runtime_repo_override" >&2
            return 1
        end
        set -l builds_dir (dirname -- "$runtime_repo")/builds
        set build_dir (__pienv_find_latest_build_dir "$builds_dir")
        or return 1
    else
        set build_dir (__pienv_find_build_dir_from_cwd "$cwd")
        if test $status -eq 0
            set -l cmake_cache "$build_dir/CMakeCache.txt"
            if not test -f "$cmake_cache"
                echo "pienv: expected CMakeCache.txt in build directory: $cmake_cache" >&2
                return 1
            end

            set runtime_repo (__pienv_read_cmake_cache_value "$cmake_cache" "PANDA_SOURCE_DIR:STATIC")
            if test -z "$runtime_repo"
                echo "pienv: PANDA_SOURCE_DIR:STATIC not found in $cmake_cache" >&2
                return 1
            end
            set runtime_repo (realpath "$runtime_repo")
        else
            set runtime_repo (__pienv_find_runtime_repo_from_cwd "$cwd")
            if test $status -ne 0
                echo "pienv: unsupported location: could not detect build tree or runtime repo for $cwd" >&2
                return 1
            end

            set runtime_repo (realpath "$runtime_repo")
            set -l builds_dir (dirname -- "$runtime_repo")/builds
            set build_dir (__pienv_find_latest_build_dir "$builds_dir")
            or return 1
        end
    end

    set -l frontend_link "$runtime_repo/tools/es2panda"
    if not test -e "$frontend_link"
        echo "pienv: expected frontend symlink/path does not exist: $frontend_link" >&2
        return 1
    end

    set -l frontend_repo (realpath "$frontend_link")
    set -l build_tests_dir "$build_dir/urunner-work"
    set -l spec_dir "$runtime_repo/plugins/ets/doc/spec"

    for required_dir in "$runtime_repo" "$frontend_repo" "$spec_dir" "$build_dir"
        if not test -d "$required_dir"
            echo "pienv: required directory not found: $required_dir" >&2
            return 1
        end
    end

    set -gx PI_BUILD_DIR "$build_dir"
    set -gx PI_TEST_DIR "$build_tests_dir"
    set -gx PI_LANG_SPEC "$spec_dir"
    set -gx PI_RESOURCE_RUNTIME_REPO "$runtime_repo"
    set -gx PI_RESOURCE_FRONTEND_REPO "$frontend_repo"

    printf '%s\n' \
        "PI_BUILD_DIR=$PI_BUILD_DIR" \
        "PI_TEST_DIR=$PI_TEST_DIR" \
        "PI_LANG_SPEC=$PI_LANG_SPEC" \
        "PI_RESOURCE_RUNTIME_REPO=$PI_RESOURCE_RUNTIME_REPO" \
        "PI_RESOURCE_FRONTEND_REPO=$PI_RESOURCE_FRONTEND_REPO"
end
