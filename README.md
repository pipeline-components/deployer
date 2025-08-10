# Pipeline Components: Deployer

[![][gitlab-repo-shield]][repository]
![Project Stage][project-stage-shield]
![Project Maintenance][maintenance-shield]
[![License][license-shield]](LICENSE.md)
[![GitLab CI][gitlabci-shield]][gitlabci]

## Docker status

[![Image Size][size-shield]][dockerhub]
[![Docker Pulls][pulls-shield]][dockerhub]

## Usage

The image has for running deployer in a small container and supporting all of
the default deployer recipes

## Examples

```yaml
# Deploy templates
.deploy: &deploy
  stage: deploy
  image: registry.gitlab.com/pipeline-components/deployer:latest
  dependencies: []
  before_script:
    - eval $(ssh-agent -s)
    - >-
      [[ ${CI_ENVIRONMENT_NAME:-local} == "testing"  && ! -z ${TESTING_DEPLOYMENT_KEY} ]] &&
      echo "${TESTING_DEPLOYMENT_KEY}"    | tr -d "\r" | ssh-add -
    - >-
      [[ ${CI_ENVIRONMENT_NAME:-local} == "acceptance" && ! -z ${ACCEPTANCE_DEPLOYMENT_KEY} ]] &&
      echo "${ACCEPTANCE_DEPLOYMENT_KEY}" | tr -d "\r" | ssh-add -
    - >-
      [[ ${CI_ENVIRONMENT_NAME:-local} == "production" && ! -z  ${PRODUCTION_DEPLOYMENT_KEY} ]] &&
      echo "${PRODUCTION_DEPLOYMENT_KEY}" | tr -d "\r" | ssh-add -
  script:
    - dep deploy ${CI_ENVIRONMENT_NAME:-local}

deploy production:
  <<: *deploy
  only:
    - /^v[0-9.]+$/
  environment:
    name: production
```

- `*_DEPLOYMENT_KEY` contains the ssh key used for accessing the deployment server
- `CI_ENVIRONMENT_NAME` environment defined by gitlab

## Versioning

This project uses [Semantic Versioning][semver] for its version numbering.

## Support

Got questions?

Check the [discord channel][discord]

You could also [open an issue here][issue]

## Contributing

This is an active open-source project. We are always open to people who want to
use the code or contribute to it.

We've set up a separate document for our [contribution guidelines][contributing-link].

Thank you for being involved! 😍

## Authors & contributors

The original setup of this repository is by [Robbert Müller][mjrider].

The Build pipeline is large based on [Community Hass.io Add-ons
][hassio-addons] by [Franck Nijhof][frenck].

For a full list of all authors and contributors,
check [the contributor's page][contributors].

## License

This project is licensed under the [MIT License](./LICENSE) by [Robbert Müller][mjrider].

[contributing-link]: https://pipeline-components.dev/contributing/
[contributors]: https://gitlab.com/pipeline-components/deployer/-/graphs/main
[discord]: https://discord.gg/vhxWFfP
[dockerhub]: https://hub.docker.com/r/pipelinecomponents/deployer
[frenck]: https://github.com/frenck
[gitlab-repo-shield]: https://img.shields.io/badge/Source-Gitlab-orange.svg?logo=gitlab
[gitlabci-shield]: https://img.shields.io/gitlab/pipeline/pipeline-components/deployer.svg
[gitlabci]: https://gitlab.com/pipeline-components/deployer/-/commits/main
[hassio-addons]: https://github.com/hassio-addons
[issue]: https://gitlab.com/pipeline-components/deployer/issues
[license-shield]: https://img.shields.io/badge/License-MIT-green.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2025.svg
[mjrider]: https://gitlab.com/mjrider
[project-stage-shield]: https://img.shields.io/badge/project%20stage-production%20ready-brightgreen.svg
[pulls-shield]: https://img.shields.io/docker/pulls/pipelinecomponents/deployer.svg?logo=docker
[repository]: https://gitlab.com/pipeline-components/deployer
[semver]: http://semver.org/spec/v2.0.0.html
[size-shield]: https://img.shields.io/docker/image-size/pipelinecomponents/deployer.svg?logo=docker
