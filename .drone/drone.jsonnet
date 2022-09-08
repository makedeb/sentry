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
        environment: {
            sentry_secret_key: {from_secret: "sentry_secret_key"},
            sentry_github_app_id: {from_secret: "sentry_github_app_id"},
            sentry_github_app_webhook_secret: {from_secret: "sentry_github_app_webhook_secret"},
            sentry_github_app_client_id: {from_secret: "sentry_github_app_client_id"},
            sentry_github_app_client_secret: {from_secret: "sentry_github_app_client_secret"},
            sentry_github_app_private_key: {from_secret: "sentry_github_app_private_key"}
        },
        commands: [".drone/scripts/deploy.sh"]
    }]
};

[deploy()]