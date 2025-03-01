"""
Dependency installation for the cmangos repositories.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

CMANGOS_MANGOS_TBC_COMMIT = "54629be7c5c3e0e0d3f24cbf18efc4f9758f8975"
CMANGOS_PLAYERBOTS_COMMIT = "50a69d2071c723e4f49306ab1ccfb434fccb0661"

SOURCE_REF_LABELS = {
    # cmangos.net/mangos-tbc
    "net.cmangos.mangos-tbc.revision": CMANGOS_MANGOS_TBC_COMMIT,
    "net.cmangos.mangos-tbc.source": "https://github.com/cmangos/mangos-tbc",
    "net.cmangos.mangos-tbc.url": "https://github.com/cmangos/mangos-tbc",
    # cmangos.net/playerbots
    "net.cmangos.playerbots.revision": CMANGOS_PLAYERBOTS_COMMIT,
    "net.cmangos.playerbots.source": "https://github.com/cmangos/playerbots",
    "net.cmangos.playerbots.url": "https://github.com/cmangos/playerbots",
    # cmangos.net/tbc-db
    "net.cmangos.tbc-db.revision": "2025-02-22",
    "net.cmangos.tbc-db.source": "https://github.com/cmangos/tbc-db",
    "net.cmangos.tbc-db.url": "https://github.com/cmangos/tbc-db",
}

def import_dependencies(name = "cmangos"):
    """Setup the archives to pull the git repositories for cmangos-tbc

    Args:
        name: A name prefix for all repositories.
    """

    http_archive(
        name = "{name}_mangos_tbc".format(name = name),
        url = "https://github.com/cmangos/mangos-tbc/archive/{commit}.tar.gz".format(commit = CMANGOS_MANGOS_TBC_COMMIT),
        strip_prefix = "mangos-tbc-{commit}".format(commit = CMANGOS_MANGOS_TBC_COMMIT),
        sha256 = "38012ba17b47a2f24a508f30b6a694dff33e5d172791399b849b4679d25323af",
        build_file = "//:third_party/cmangos_mangos_tbc.BUILD",
        patches = [
            "//:third_party/patches/cmangos/mangos-tbc/CMakeLists.patch",
        ],
    )

    http_archive(
        name = "{name}_tbc_db".format(name = name),
        url = "https://github.com/ThoriumLXC/vmangos-database/releases/download/TBCDB/tbc-all-db.zip",
        sha256 = "4a02e09f0b7ec00440775b8805be0d80f1f80381f68bc344b29109a261a0dc73",
        build_file = "//:third_party/cmangos_tbc_db.BUILD",
    )

    http_archive(
        name = "{name}_tbc_playerbots".format(name = name),
        url = "https://github.com/cmangos/playerbots/archive/{commit}.tar.gz".format(commit = CMANGOS_PLAYERBOTS_COMMIT),
        strip_prefix = "playerbots-{commit}".format(commit = CMANGOS_PLAYERBOTS_COMMIT),
        sha256 = "42d1a37dd1043f9f2d26d046d7f57c3d8f8768df781b62261e778f12092741cf",
        build_file = "//:third_party/cmangos_tbc_playerbots.BUILD",
    )
