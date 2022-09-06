local deploy() = {
    name: "deploy",
    kind: "pipeline",
    type: "exec",
    triggers: {
        branch: ["master"],
        repo: ["makedeb/sentry"]
    },
    node: {server: "homelab"},
    steps: [{
        name: "deploy",
        commands: [".drone/scripts/deploy.sh"]
    }]
};

[deploy()]