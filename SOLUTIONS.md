[![codecov](https://codecov.io/gh/borjlp/the-real-devops-challenge/branch/master/graph/badge.svg?token=M95NXUJN0I)](https://codecov.io/gh/borjlp/the-real-devops-challenge)

# MY PROPOSED SOLUTIONS TO THIS CHALLENGE

Hi IGZ Team, let me introduce myself, my name is Borja and I am going to present the solutions for this challenge. First of all, here is the index for the challenge:

---------
## Table of contents

1. [Challenge 1](#challenge-1)
2. [Challenge 2](#challenge-2)
3. [Challenge 3 and 4](#challenge-3-and-4)
4. [Challenge 5](#challenge-5)
5. [Challenge 6](#challenge-6)
6. [Difficulties](#difficulties)
7. [Improvements to implement](#improvements-to-implement)
8. [Tools used](#tools)
9. [References](#references)

---------
---------
---------
---------

### **CHALLENGE 1**
_______

I need to write some python code to solve this challenge. First I need to install pyenv(more on this tool in the [tools section](#tools)), this tool manage different python versions and environments. I tested the application with the 3.6.13 version. 

There are a lots of unnecesary functions, flake8 is a great colleage for this one. I remove some functions, modules and files no needed. There are a lots of errors to execute the application, but finally, changing the variable id with the proper one and get the index 0 for the list with a one restaurant, be careful with that because if the list is empty we have a pretty IndexError in the application.

I did some improvements in the application and I would like to implement more than I did (I have written some of this features in the [improvements section](#improvements)). First I put some logging in the application, typing to control the output of the api calls and control some exceptions. For the output code, in my opinion a 204 code is when you found an id inside the database but this one doesn't have any data on it, so I prefer to put a 404 code when an id is not found.

In the test (tox) part I removed the old python versions and tested it with new ones. I have used parallel test with auto to make the testing fastest. Another thing that I implemented was the coverage for the code and the "linting" with flake8.

Another thing that I did is to remove the mock test to really test with a fresh mongo. I wrote the data inside the mongo when it's up, maybe an improvement for that is to implement a wait-for-it to wait an available mongo to connect.
```
- But this is the challenge 1 section Borja you didn't have to write this yet. This one goes on the improvements section.
- Oh really, forgot it for now. 
```
It implemented a exception too because the tests are in parallel in the same mongo, so I only need to execute once. 

One more thing, I implemented some healhchecks for the [kubernetes section](#challenge-6).

I think that I have explained the challenge in an easy way. So go with the next one.

----
----
### **CHALLENGE 2**
_____
I have used circle-ci as my CICD tool, I wrote a test section with coverage and I have used codecov to save the results. You can check the results [here](https://app.circleci.com/pipelines/github/borjlp/the-real-devops-challenge). I wrote the tests in parallel with tox and the test with docker-compose (build-and-test). Finally the cicd build the container images with kaniko and upload them to dockerhub. I have used anchors to avoid repeat code. 
Github-actions and gitleaks. I have used github-actions to implement a testing about the exposed secrets in my repository.
It would be better if I can deploy the k8s resources using argocd or another tool.

----
----
### **CHALLENGE 3 AND 4**
_____
I have written three different dockerfiles, one for the app with the application code, the other one for the mongo database and finally a mongo seed that it's used for seeding the mongo restaurant database. The different files are in the root of the project.
It has been easy to implement because I have used the officials images for python and mongo.
The dockerfiles follow the hadolint rules.

----
----
### **CHALLENGE 5**
_____
Nothing to explain here. The docker-compose build the image and all containers are deployed in the same network. You can see in circleci the interaction and the test with the containers. 

----
----
### **CHALLENGE 6**
_____
Final challenge. This consist in deploying the resources on a kubernetes cluster. I have used microk8s and I created a bash script that can be done all the steps for you (use help for more information). I have used helm to deplopy the resources.

First I deployed the different tools with his own chart, I have used a deployment for the app and for the mongo database and a job to seed the mongo database with the data provided. Finally all of this are deployed with helmfile that it is like a helm deployer. This tool is easy to use. (`helmfile apply` - to apply the charts or update them, `helmfile delete` - to delete the charts that contains the helmfile.yaml). I put a volume storage to keep the data of the mongo database because it's not part of a replica set (an improvement more) it's standalone.

----
----
### **DIFFICULTIES**
_____
The first difficulty that I found was to run the test in parallel. With tox I have some problems that I don't really found, because with a secuencial test, the problem didn't exist. 
Some other difficulties was the testing without a mock, using a real mongo connection i circle. Using microk8s I had some dns problems, to resolve it I edited the corefile to use the resolv.conf and remove the systemd-resolved that can cause a dns lookup loop. Another difficulty was the chain connection for the mongodb database. 

I think that they are all of the difficulties that I have with this challenge.

----
----
### **IMPROVEMENTS TO IMPLEMENT**
_____
Here I am going to enumerate my concerns about my challenge, and some improvements that I would like to do:
1. Secrets keep secret. All the secrets environment are exposed and this is a cool feature to implement, we can use sops, git-crypt, helm-secret, bitnami-secrets, etc.
2. Some security testing with code with static analisys and use any container vulnerability scan tool like trivy.
3. Improve testing and remove tox. Using enum and pytest in circle to generate a matrix and test the different python versions.
4. Use find_one_or_404 flask function to find an restaurant and return it if exists or a 404 code if it doesn't exist.
5. Install a logging architecture like fluentbit or fluentd for keeping the logs of the app.
6. Improve the logging on the app.
7. Improve the tagging generation of the images. Use stable tags on master/main branch and use tags with commit on the remaining branches.
8. Change mongo standalone with a replica set.
9. Implement monitoring for the app and for the database.
10. Deploy a prometheus operator.
11. Wait to mongo database is available in circle.
12. Use poetry or pipenv to manage the python dependencies.
13. Use network policies to control the access to the application.

----
----
### **TOOLS**
_____
1. [pyenv](https://github.com/pyenv/pyenv)
2. [docker](https://www.docker.com/) or [podman](https://podman.io/)
3. [circle](https://circleci.com/)
4. [mongo](https://docs.mongodb.com/)
5. [kaniko](https://github.com/GoogleContainerTools/kaniko)
6. [gitleaks](https://github.com/zricethezav/gitleaks)
7. [github-actions](https://docs.github.com/en/actions)
8. [docker-compose](https://docs.docker.com/compose/)
9. [helm](https://helm.sh/)
10. [helmfile](https://github.com/roboll/helmfile)
11. [microk8s](https://microk8s.io/)
12. [tox](https://tox.readthedocs.io/en/latest/)
13. [codecov](https://about.codecov.io/)
14. [hadolint](https://github.com/hadolint/hadolint)

----
----
### **REFERENCES**
_____
1. https://circleci.com/docs/2.0/
2. https://flake8.pycqa.org/en/latest/user/configuration.html
3. https://pytest-cov.readthedocs.io/en/latest/tox.html
4. https://circleci.com/docs/2.0/docker-compose/
5. https://pymongo.readthedocs.io/en/stable/index.html
6. https://circleci.com/docs/2.0/executor-types/#using-machine
7. https://flask.palletsprojects.com/en/2.0.x/
8. https://www.mongodb.com/features/mongodb-authentication
9. https://kubernetes.io/docs/concepts/services-networking/ingress/
10. https://docs.codecov.com/docs/codecovyml-reference