# ai-acceptance-tests

Developers site for Address Index API

## Running Locally in an IDE

* Add JWT token value to API.java then run the class RunCumberTest

## Running Through Docker

Command line

* Add the JWT token value to the Dockerfile
* Build and execute an image with  `docker build -t ai-acceptance-tests:latest .`


Concourse

* Ensure the pipeline has the JWT token supplied as a secret
* Excute the pipeline which will build and run the docker image