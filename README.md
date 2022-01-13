# Pipeline Components: Deployer

![Project Stage][project-stage-shield]
![Project Maintenance][maintenance-shield]
[![License][license-shield]](LICENSE.md)

[![GitLab CI][gitlabci-shield]][gitlabci]

## Docker status

[![Docker Version][version-shield]][microbadger]
[![Docker Layers][layers-shield]][microbadger]
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

We've set up a separate document for our [contribution guidelines](CONTRIBUTING.md).

Thank you for being involved! :heart_eyes:

## Authors & contributors

The original setup of this repository is by [Robbert Müller][mjrider].

The Build pipeline is large based on [Community Hass.io Add-ons
][hassio-addons] by [Franck Nijhof][frenck].

For a full list of all authors and contributors,
check [the contributor's page][contributors].

## License

MIT License

Copyright (c) 2018 Robbert Müller

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[commits]: https://gitlab.com/pipeline-components/deployer/commits/master
[contributors]: https://gitlab.com/pipeline-components/deployer/graphs/master
[dockerhub]: https://hub.docker.com/r/pipelinecomponents/deployer
[license-shield]: https://img.shields.io/badge/License-MIT-green.svg
[mjrider]: https://gitlab.com/mjrider
[discord]: https://discord.gg/vhxWFfP
[gitlabci-shield]: https://img.shields.io/gitlab/pipeline/pipeline-components/deployer.svg
[gitlabci]: https://gitlab.com/pipeline-components/deployer/commits/master
[issue]: https://gitlab.com/pipeline-components/deployer/issues
[keepchangelog]: http://keepachangelog.com/en/1.0.0/
[layers-shield]: https://images.microbadger.com/badges/image/pipelinecomponents/deployer.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2022.svg
[microbadger]: https://microbadger.com/images/pipelinecomponents/deployer
[project-stage-shield]: https://img.shields.io/badge/project%20stage-production%20ready-brightgreen.svg
[pulls-shield]: https://img.shields.io/docker/pulls/pipelinecomponents/deployer.svg
[releases]: https://gitlab.com/pipeline-components/deployer/tags
[repository]: https://gitlab.com/pipeline-components/repository
[semver]: http://semver.org/spec/v2.0.0.html
[version-shield]: https://images.microbadger.com/badges/version/pipelinecomponents/deployer.svg

[frenck]: https://github.com/frenck
[hassio-addons]: https://github.com/hassio-addons
