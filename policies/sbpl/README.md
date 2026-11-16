# Seatbelt profiles

These are macOS Seatbelt (SBPL) profiles for `bin/crated`.
`crated <cmd> [args...]` runs `<cmd>` under `<cmd>.sb` from this directory.
Outbound HTTP(S) goes through the Squid proxy in `../squid/`.

## Layout

| File | Role |
|---|---|
| `common.sb` | Base rules. Every profile imports it first. |
| `homebrew.sb` | Run access to `/opt/homebrew/{bin,sbin}`. |
| `python-common.sb` | Python toolchain and caches. Shared by `python.sb` and `uv.sb`. |
| `git-guard.sb` | Denies writes to git hooks and config. Every profile imports it **last**. |
| `claude.sb`, `go.sb`, `python.sb`, `uv.sb` | Entry profiles, one per command name. |

## Parameters

`crated` passes these with `-D`:

| Parameter | Value |
|---|---|
| `HOME` | `$HOME`. Import paths and `home-*` helpers use it. |
| `PROJECT_PATH` | `$(pwd)`. The project is readable, writable and runnable. |
| `LOOPBACK` | Set by `crated --loopback`. It widens loopback to all ports. |

An unset parameter is false in SBPL, so `(if (param "LOOPBACK") ...)` works.

## Writing a new profile

1. Name it after the command, e.g. `node.sb` for `crated node`.
2. Start with `(version 1)` and `(deny default)`.
3. Import `common.sb`, then any shared fragments.
4. Add only what the tool needs. Give each rule a comment that says why.
5. End with the `git-guard.sb` import. Nothing may come after it.

```scheme
(version 1)
(deny default)

(import (string-append (param "HOME") "/.dotfiles/policies/sbpl/common.sb"))
(import (string-append (param "HOME") "/.dotfiles/policies/sbpl/homebrew.sb"))

;; ... tool-specific rules ...

;; Must stay last. See git-guard.sb.
(import (string-append (param "HOME") "/.dotfiles/policies/sbpl/git-guard.sb"))
```

## Rules of thumb

**The last matching rule wins.**
A later allow overrides an earlier deny.
That is why `git-guard.sb` goes last.
For example, `go.sb` allows all of `~/go`.
A project under `~/go/src` would get its hooks back if the guard came first.

**Seatbelt matches resolved paths.**
Symlinks are followed before rules are checked.
Write the resolved spelling, or the rule matches nothing.
- `/tmp` is `/private/tmp`. `/var` is `/private/var`. `/etc` is `/private/etc`.
- Homebrew's `bin/<tool>` and `opt/<tool>` point into `Cellar/<tool>/<version>`.
  Allow the `Cellar` path. For example, `uv.sb` allows `Cellar/uv`.
- `$TMPDIR` is under `/private/var/folders/<xx>/<hash>/T/`.

**Reading is not running.**
`file-read*` does not let a binary run or a library load.
Add `process-exec` and `file-map-executable` for that.
`go test` needed this for `$TMPDIR/go-build*`.

**Network addresses take one port or `*`.**
Ranges like `localhost:49152-65535` fail to parse.

**A mach service can reach past the sandbox.**
The service runs outside it, with its own rights.
Check what the service does before allowing it.
- `com.apple.trustd.agent` checks certificates. It also fetches revocation
  data around Squid. Only `go.sb` allows it, because Go needs it for TLS.
- `com.apple.securityd` and `com.apple.SecurityServer` reach the keychain.
  Only `claude.sb` allows them.

## Deliberately not allowed

Don't add these to `common.sb`.
Add one to a single profile only if that tool needs it, and say why.

| What | Why |
|---|---|
| `lsopen` | Launch Services starts apps through launchd, outside the sandbox. `open x.command` would run unsandboxed. |
| Direct DNS (`*:53`) | Lookups like `<data>.attacker.com` leak data around Squid. Proxied clients don't need it, because Squid resolves names. |
| All loopback ports by default | They reach local databases, Docker and dev servers. Use `crated --loopback` per run. `claude.sb` is the exception. |
| Writes to `.git/hooks`, `.git/config` | The next unsandboxed `git` would run planted code. |
| Renaming `.git` or the project root | It gets around the git-guard paths. |

With `LOOPBACK`, Docker 2375/2376, MySQL 3306, Postgres 5432 and Redis 6379
stay denied. See `allow-wide-loopback` in `common.sb`.

## Testing

Seatbelt can't nest.
Inside another sandbox, such as a Claude Code Bash tool, `sandbox-exec` fails
with `sandbox_apply: Operation not permitted`.
Run probes from a plain terminal.

Probe one operation:

```sh
sandbox-exec -D HOME=$HOME -D PROJECT_PATH=$PWD \
  -f ~/.dotfiles/policies/sbpl/go.sb /usr/bin/touch /tmp/sbpl-probe
```

Test both sides of every rule.
Check that what should work works, and that what should fail fails.
If every case fails, the profile may not have loaded at all.

Watch denials live in another terminal:

```sh
/usr/bin/log stream --style compact --predicate 'sender == "Sandbox"'
```

- Each line names the process, the operation and the resolved path, e.g.
  `deny(1) file-write-create /Users/me/x`.
- Use `/usr/bin/log`. In zsh, plain `log` is a shell builtin.
- `file-read-data /dev/dtracehelper` denials are harmless noise.

To test network rules, start Squid first:

```sh
squid -N -f ~/.dotfiles/policies/squid/squid.conf
```

Then set `HTTPS_PROXY=http://127.0.0.1:3128`, as `crated` does.
Squid takes about 30 seconds to exit after SIGTERM.
A quick restart can fail with "Squid is already running".
