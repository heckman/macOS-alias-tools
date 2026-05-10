import Foundation

// Copyright 2026 Erik Heckman <erik@heckman.ca>
// SPDX-License-Identifier: MIT
//
// mkalias

#if VERSION
    let version = "mkalias v\(VERSION)"
#else
    let version = "mkalias v0.0.1"  // Fallback for local dev
#endif

let usage = """
    Usage: mkalias [-f|--force] <path-of-original> <alias-file>
           mkalias -h|--help
    """
let help = """
    Create an alias file that points to the path of an original
    filesystem object.

    Will not overwrite and existing file with <alias-file> unless
    the `--force` (or `-f`) option is specified.

    On success, create the alias, print nothing, and exit with a
    zero exit status.

    On failure, print an error message to stderr and exit
    with a non-zero exit status: 2 if the file is not specified,

    On failure, print an error message to stderr and exit
    with a non-zero exit status: 2 if the file is not specified,
    not found, or not an alias file; 1 if the alias cannot be
    resolved; 71 on an unexpected file-system error.
    """

do {
    var force = false
    var args: [String] = CommandLine.arguments
    args.removeFirst()
    optionLoop: while !args.isEmpty && args[0].hasPrefix("-") {
        switch args[0] {
        case "-v", "--version":
            print("\(version)\n")
            exit(0)
        case "-h", "--help":
            print("\n\(usage)\n\n\(help)\n")
            exit(0)
        case "-f", "--force":
            force = true
            args.removeFirst()
        case "--":
            args.removeFirst()
            break optionLoop
        default:
            fputs(
                "Error: unknown option: \(args[0])\n",
                stderr
            )
            exit(2)
        }
    }
    guard args.count == 2 else {
        fputs(
            "\(usage)\n",
            stderr
        )
        exit(2)
    }

    let originalFile = args[0]
    let aliasFile = args[1]

    let originalURL = URL(fileURLWithPath: originalFile)
    let aliasURL = URL(fileURLWithPath: aliasFile)

    guard FileManager.default.fileExists(atPath: originalURL.path) else {
        fputs(
            "Error: original not found: \(originalFile)\n",
            stderr
        )
        exit(2)
    }

    var isDir: ObjCBool = false
    let exists = FileManager.default.fileExists(
        atPath: aliasURL.path,
        isDirectory: &isDir
    )
    if exists {
        if force {
            guard !isDir.boolValue else {
                fputs(
                    "Error: cannot overwrite directory: \(aliasFile)\n",
                    stderr
                )
                exit(2)
            }
        } else {
            fputs(
                "Error: \(isDir.boolValue ? "directory" : "file") exists: \(aliasFile)\n",
                stderr
            )
            exit(2)
        }

    }

    let bookmarkData: Data = try originalURL.bookmarkData(
        options: [URL.BookmarkCreationOptions.suitableForBookmarkFile],
        includingResourceValuesForKeys: nil,
        relativeTo: nil
    )

    try URL.writeBookmarkData(
        bookmarkData,
        to: aliasURL
    )

} catch {
    fputs(
        "Error: unable to create alias file.\n",
        stderr
    )
    exit(1)
}
