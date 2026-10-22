# Hosting and deployment status

Last reviewed: 2026-10-22

## Non-negotiable requirements

The intended host must provide all of the following:
- Linux with Docker Engine and Docker Compose.
- Hardware virtualization and a usable `/dev/kvm` device.
- Enough RAM, CPU and disk for an Android Emulator.
- Persistent disk storage for `/home/androidusr`.
- A way to access the web UI securely from the user's phone.
- Terms that allow a continuously running emulator without unexpected suspension or charges.

A free trial or a website dashboard is not proof that the Android device can run 24/7.

## Current status

- GitHub repository: source and configuration only.
- GitHub Actions: validates scripts and Compose syntax; it does not host the emulator.
- Vercel Hobby: may host a web dashboard, but is not assumed to provide KVM, a persistent Linux disk, or a 24/7 Android runtime.
- Android emulator: NOT deployed. No live device URL exists yet.
- Data persistence: configured in Compose by mounting `./data:/home/androidusr`; it has not yet been verified on a real host.

## Trial services to evaluate manually

These are leads, not endorsements or promises of free permanent hosting:
- HubSim: https://hubsim.com/ — advertises 100 free credits without a payment card. Verify what the credits cover and whether the device can be retained after the allowance ends.
- XCloudPhone trial: https://xcloudphone.net/free-trial — advertises a 2-hour no-card trial. Its trial documentation says devices are reset when the trial ends, so it does not meet permanent data retention on the free trial.

Do not add payment information or start a paid rental to test this project. Do not rely on a trial device for important files or account recovery.

## Safe deployment checklist

1. Run `./scripts/doctor.sh` on the target host.
2. Confirm `/dev/kvm` exists and is accessible.
3. Confirm the provider allows the workload and persistent storage.
4. Keep port 6080 private. Do not expose ADB ports 5554/5555 publicly.
5. Use a secure SSH tunnel or authenticated VPN for remote access.
6. Start with `./scripts/start.sh`; inspect `docker compose logs -f android`.
7. Check the container status using `docker compose ps` and, if available, `docker exec android-cloud-phone cat device_status`.
8. Install a non-sensitive test app, restart the container, and verify that the app and its data remain.
9. Test the backup script and keep backups private.
10. Do not call the system 24/7-ready until it survives a host reboot and an extended uptime test.

## Why GitHub Actions is not the phone

The hosted runner is an ephemeral CI machine. It is suitable for automated checks and may not expose KVM. Jobs are not a permanent interactive Android device and should not be used to evade runtime limits.
