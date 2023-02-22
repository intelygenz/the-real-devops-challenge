
- Challenge 1

  Tinkered a bit with the code, in app.py and src/mongoflask.py

  Just a note, I found that pymongo 4.0 dropped support for python 2.7 and 3.4
  https://pymongo.readthedocs.io/en/stable/changelog.html#changes-in-version-4-0
  
  python 2.7 works, because the regexp used by pymongo to decide if python version is supported is:

  ERROR: pymongo requires Python '>=2.7,!=3.0.*,!=3.1.*,!=3.2.*,!=3.3.*,!=3.4.*

  So python 2.7 passed (>=), but 3.4 don't (!=)

- Challenge 2

  Added a github action basic ci flow, with 3 steps:

  - run tests
  - lint code
  - scan api image for vulnerabilities

- Challenge 3

  I added dockerfiles for both the api, and the mongodb import - basically to copy the restaurant dataset to the image.

  In a "real world" scenario, this won't be needed, as production database state will not be needed to be reloaded everytime, as we do here with ephemeral clusters. We would ensure DR as well with database backups

- Challenge 4

  I added another deployment for mongodb import

- Challenge 5

  Added a docker-compose file,in repo's root

- Challenge 6

  Added a makefile to streamline ops. It creates a kind cluster (k8s rev 1.25), in which everything gets deployed. `make bootstrap` will make it happen.

  Dependencies:
  - kubectl
  - kind
  - helm

  Nginx-ingress installed as ingress controller.
  
  I considered creating a helm chart to deploy the app and mongo database. But you stated you wanted yaml manifests, so here they are.

  I wanted to add something in observability terms. So I added some yaml manifests (yaml folder), as well as some extra features: metrics-server.

  Added as well kube-prometheus stack (prometheus, grafana), promtail and loki, all deployed with helm. They use a basic setup in order to be able to fetch metrics and logs from the app.

  Nice upgrades to do here (in no particular order):

  - add nginx proxy in front of api, to filter healthz logs (we dont need to see a 200 for each healtcheck, only when they fail)

  - production readiness:
    - deploy on a cloud k8s cluster (EKS for example)
    - Design for HA. Have worker nodes multiaz
    - loadtest the app, then setup goldilocks and set k8s limits and request for the api
    - design autoscaling flow
    - of course, setup dns. Use external-dns to update dns records
    - use a prod ready observability setup, based on the POC I added here. Ideally adding all 
      the grafana LGTM stack and scaling properly
    - setup alertmanager rules to ensure 24x7 support
    - secrets management. Here, mongodb creds are added as a k8s secret. We should use a proper 
      secret management solution in prod (KMS & sops, vault...)
    - probably more, but probably that's enough :) 