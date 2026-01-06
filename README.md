Dockerfile that runs OpenTofu under Docker builder emulation to demonstrate a
sporadic crash that looks something like:

```
0.076 + tofu providers lock                                                                                                                                                                                                                 
1.441 - Fetching gitlabhq/gitlab 18.6.1 for linux_arm64...
3.694 runtime: marked free object in span 0x4000474d9400, elemsize=96 freeindex=1 (bad use of unsafe.Pointer or having race conditions? try -d=checkptr or -race)
```

OpenTofu crash reproduction steps
=================================

1. Install docker.
2. Clone this repo.
3. Run `bash test-tofu.sh`.

This will create a docker builder called "tofu-crash-builder". It will then use
it to repeatedly perform a docker build for a platform different to that of
your host until a failure occurs. If you don't have QEMU already set up with
binfmt-support to do platform emulation, the tofu-crash-builder builder will
use buildkit's builtin QEMU to do the emulation.

Notes
=====

- The problem only occurs under emulation - native (same platform as host)
  Docker builds will never have a problem
- The problem happens on Docker Desktop on macOS 15 and Docker Engine on Ubuntu
  24.04 (x86\_64 and aarch64 hosts)
- `tofu` typically crashes within 30 loops when the host platform is arm64 and
  amd64 is the emulated platform but crashes also happen the other way around
  (arm64 being emulated on amd64) but the loops required can be far more (e.g.
  over 200)
- On Linux hosts with Docker Engine installed, if QEMU has been installed (e.g.
  via the distro package (`apt-get install qemu-user-static`) or via `docker
  run --privileged --rm tonistiigi/binfmt --install all`) then the problem
  still occurs (even though I can see the non-buildkit QEMU being used in `ps
  ax`). However when a builder (`--builder tofu-crash-builder`) is NOT used,
  even though emulation will still take place the problem will NOT occur (this
  is why I'm filing the issue here first)!
- Trying to slim the terraform files down further can stop the issue from
  occurring
- This problem is not https://github.com/golang/go/issues/69255 because it
  doesn't happen every time and [tofu 1.11.2 has been compiled with Go
  1.25.3](https://github.com/opentofu/opentofu/commit/5f4eadb9ae3fb7ded831d9cc4e252abe7d9b1721)
