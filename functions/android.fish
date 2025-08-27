function android
    set -l dir .
    test (count $argv) -ge 1 && set dir $argv[1]
    test -x "$dir"; or begin
        echo "path at $dir does not exist"
        return 1
    end

    if test (uname -s) = "Darwin"
        set studio_macos /Applications/Android Studio.app/
        if test -x "$studio_macos"
            open -na "Android Studio.app" $dir
        else
            echo "Can't find Android Studio"
            return 1
        end
    else
        set -l studio_bin /opt/android-studio/bin/studio.sh
        if test -x $studio_bin
            $studio_bin $dir
        else
            echo "Can't find Android Studio"
            return 1
        end
    end

    return 0
end
