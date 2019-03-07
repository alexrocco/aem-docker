# AEM Docker

This project it's aimed to create an Adobe AEM image optimized even though that AEM it's not ready and prepared by Adobe to be dockerized.

## Getting Started

This project is a set of Dockerfiles with some scripts that will be an optimized Adobe AEM image at the end. It was create to not have to exec into the container and some configurations, it's all done through dockerfile and scripts.  

### Prerequisites

Since I cannot share these files, you'll need the cq-quickstart-\*.jar, your license.properties  and the service package copied in files directory.
Also you'll need Docker with [experimental features](https://github.com/docker/docker-ce/blob/master/components/cli/experimental/README.md.
) enabled.

### Steps

#### #1: Base Image

Builds a base image with CentOS and Oracle JDK 8. Note that CentOS and Oracle JDK were picked according the [Adobe Technical Requirements](https://helpx.adobe.com/experience-manager/6-3/sites/deploying/using/technical-requirements.html)

```
docker build . -f Dockerfile-centos-with-oraclejdk -t centos-with-oraclejdk --squash
```

#### #2: AEM Image

Builds the AEM image.

Build arguments:
- AEM_VERSION: AEM version. This should match with the jar name, e.g. cq-quickstart-*6.4.0*.jar (default: 6.4.0)
- AEM_RUNMODE: author or publish (default: author)
- HTTP_PORT: port to be exposed by AEM and docker (default: 4502)
- DEBUG_HTTP_PORT: debug port to be exposed by AEM and docker (default: 5502)

And repeat

author:
```
docker build . -f Dockerfile-aem -t author:6.4.0 --squash
```
publish:
```
docker build . -f Dockerfile-aem -t publish:6.4.0 --squash \
  --build-arg AEM_RUNMODE=publish \
  --build-arg HTTP_PORT=4503 \
  --build-arg DEBUG_HTTP_PORT=5503
```

#### #3: AEM Service Pack (optional)

Updates AEM image with Service Pack.

Build arguments:
- AEM_RUNMODE: author or publish (default: author)
- SERVICE_PACKAGE_VERSION: Adobe AEM service package version. This should match service package name, e.g. aem-service-pkg-*6.4.3*.zip (default: 6.4.3)

author:
```
docker build . -f Dockerfile-service-pack -t author:6.4.3 --squash
```
publish:
```
docker build . -f Dockerfile-service-pack -t publish:6.4.3 --squash \
  --build-arg AEM_RUNMODE=publish \
  --build-arg HTTP_PORT=4503
```

#### #4: Optimize (optional)

Optimize AEM image removing all packages from CRX Package Manager and running garbage collectors. This step is important if you had installed any service pack, because these kind of packages installs a lot of others packages, and after they're installed you don't need them anymore.

Build arguments:
- AEM_RUNMODE: author or publish (default: author)
- HTTP_PORT: port to be exposed by AEM and docker (default: 4502)
- DEBUG_HTTP_PORT: debug port to be exposed by AEM and docker (default: 5502)
- OAK_VERSION: The version of OAK run jar, used on [offline revision clean up](https://helpx.adobe.com/br/experience-manager/6-4/sites/deploying/using/revision-cleanup.html#HowtoRunOfflineRevisionCleanup). This version has to be the same used in the serice pack. You can get the right version on service pack release page or go to system/console/bundle a and search for oak (default: 1.8.9)

author:
```
docker build . -f Dockerfile-optimize -t author:6.4.3-slim --squash
```
publish:
```
docker build . -f Dockerfile-optimize -t publish:6.4.3-slim --squash \
  --build-arg AEM_RUNMODE=publish \
  --build-arg HTTP_PORT=4503 \
  --build-arg DEBUG_HTTP_PORT=5503
```

## Built With

* [Docker](https://www.docker.com/)

## Authors

* **Alexandre Alvarenga** - [alexrocco](https://github.com/alexrocco)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* This IS NOT PRODUCTION ready, it was created to improve dev and UAT environmets.
