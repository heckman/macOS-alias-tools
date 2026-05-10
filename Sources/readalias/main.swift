import Foundation
import config

// Copyright 2026 Erik Heckman <erik@heckman.ca>
// SPDX-License-Identifier: MIT
//
// readalias

let usage = """
    Usage: readalias <alias-file>
           readalias -h|--help
    """
let help = """
    Print the path to the original file of an alias file.

    On failure, print an error message to stderr and exit with
    a non-zero exit status: 2 if the file is not specified,
    not found, or not an alias file; 1 if the alias cannot
    be resolved; 71 on an unexpected file-system error.
    """

do {
    let args = CommandLine.arguments
    if args.count > 1 {
        if args[1] == "--version" || args[1] == "-v" {
            print("\(version)\n")
            exit(0)
        } else if args[1] == "--help" || args[1] == "-h" {
            print("\n\(usage)\n\n\(help)\n")
            exit(0)
        }
    }
    guard args.count == 2 else {
        fputs("\(usage)\n", stderr)
        exit(2)
    }

    let aliasFile = args[1]

    let aliasURL = URL(fileURLWithPath: aliasFile)
    guard FileManager.default.fileExists(atPath: aliasURL.path) else {
        fputs("Error: file not found: \(aliasFile)\n", stderr)
        exit(2)
    }

    let originalURL = try URL(resolvingAliasFileAt: aliasURL)
    let originalPath = originalURL.path
    if originalPath == aliasURL.path {
        let values = try aliasURL.resourceValues(forKeys: [.isAliasFileKey])
        if values.isAliasFile ?? false {
            fputs("Error: failed to resolve alias: \(aliasFile)\n", stderr)
            exit(1)
        } else {
            fputs("Error: not an alias file: \(aliasFile)\n", stderr)
            exit(2)
        }
    }

    print(originalPath)

} catch {
    fputs("Unexpected system error: \(error)\n", stderr)
    exit(71)
}
