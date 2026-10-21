use std/assert
use bf

const src = "/etc/bf/src/send"


#======================================================================================================================
# installation
#======================================================================================================================

export def install__send_version_matches_build [] {
    let build = with-env {BF_ETC: "/etc/bf"} { bf build | get Send }
    let package = open $"($src)/package.json" | get version

    assert equal $build $package
}

export def install__server_is_installed [] {
    assert ($"($src)/server/bin/prod.js" | path exists)
    assert ($"($src)/server/bin/start.js" | path exists) "start.js should be copied next to prod.js"
    assert ($"($src)/version.json" | path exists) "version.json should link to dist/version.json"
    assert ($"($src)/node_modules" | path exists) "production dependencies should be installed"
}

export def install__routes_do_not_log_base_url [] {
    assert not (open --raw $"($src)/server/routes/index.js" | str contains "console.log([baseUrl") "the base URL should not be logged on every request"
}

export def install__express_ws_does_not_need_esm [] {
    # the 'esm' package fails on newer versions of Node.js, so express-ws is converted to CommonJS during the build
    let dir = $"($src)/node_modules/@dannycoates/express-ws"
    assert not (open --raw $"($dir)/index.js" | str contains "esm") "express-ws should not load through esm"
    for file in (glob $"($dir)/src/*.js") {
        assert not (open --raw $file | lines | any {|x| $x =~ '^\s*(import|export)\b' }) $"($file) should be CommonJS"
    }
}

export def install__source_is_read_only_and_owned_by_node [] {
    assert equal "node:node 500" (^stat -c "%U:%G %a" $src | str trim)
}


#======================================================================================================================
# scripts
#======================================================================================================================

export def scripts__parse [] {
    for path in ["/etc/periodic/hourly/send-cleanup" "/etc/bf/init.d/20-env.nu" "/etc/bf/init.d/21-conf.nu"] {
        let result = ^$nu.current-exe --no-config-file --commands $"nu-check ($path)" | complete
        assert equal "true" ($result.stdout | str trim) $"($path) does not parse: ($result.stderr)"
    }
}
