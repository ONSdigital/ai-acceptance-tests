# ai-acceptance-tests

Acceptance Tests for Address Index API

## Running Locally in an IDE

* You need a locally running instance of the Address Index API to run the tests against. You can run this locally by running the [API project](https://github.com/ONSdigital/aims-api) in your IDE.

## Running Through Docker

You need a locally running instance of the Address Index API to run the tests against. Try the [AIMS DIY](https://github.com/ONSdigital/aims-diy) project.
> **NOTE** Some tests may fail without the full version of AddressBase Premium.

Build and execute an image with:
* `docker build -t ai-acceptance-tests .`
* `docker run --rm -e API_URL="https://your-api-host" ai-acceptance-tests`