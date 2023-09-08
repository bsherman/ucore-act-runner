# ucore-act-runner
A ucore based image pre-built for gitea act runner usage


## Features

Based on the upstream [ucore](https://github.com/ublue-os/ucore/) version of Fedora CoreOS, this makes some simple configurations to provide a ready-to-use [Gitea act_runner](https://gitea.com/gitea/act_runner) instance.

Changes:
- enables systemd `podman.socket`
- uses a custom systemd service to symlink `podman.sock` to `/var/run/docker.sock` - this is due an issue with act_runner's configuration and may be changed in the future
- configures podman containers to disable SELinux labels (`label=false`) - this is due an issue with act_runner's configuration and may be changed in the future
- provisions a `/var/act_data` directory for use by the act_runner container
- configures a [quadlet](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html) which auto runs act_runner
    - requires its EnvironmentFile to be provisioned before the service will attempt to start (can be done manually or with ignition, etc)
    - is configured for container to use Host networking to simplify the naming of the act_runner instance

## Usage


### Installation

Install using normal steps described in [ucore README](https://github.com/ublue-os/ucore/).

You can rebase to this image either manually, or as part of the [example autorebase method](https://github.com/ublue-os/ucore/#install-with-auto-rebase).

The rebase command would look like:

```bash
rpm-ostree rebase ostree-unverified-image:docker://ghcr.io/bsherman/ucore-act-runner:stable
```

### Configuration

Once running this image, the only required configuration should be to copy the example `act-runner.env` file and configure two required variables.

* `GITEA_INSTANCE_URL` - required: must point to your gitea instance
* `GITEA_RUNNER_REGISTRATION_TOKEN` - required: unique value is required per runner; found in your gitea instance

Do this as such:

```bash
cd /etc/containers/systemd
cp act-runner.env-example act-runner.env
# use editor vim or nano, to set the values specified above
vim act-runner.env
```

You can now either `systemctl start act-runner` or simply reboot, and the `act-runner` service should start.

For more information about `act_runner` itself, see [gitea's act_runner docs](https://gitea.com/gitea/act_runner).
