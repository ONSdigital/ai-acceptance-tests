package stepdefs;

import cucumber.api.DataTable;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import io.restassured.builder.RequestSpecBuilder;
import io.restassured.http.ContentType;
import io.restassured.response.Response;
import io.restassured.response.ResponseOptions;
import io.restassured.specification.RequestSpecification;

import java.util.List;
import java.util.Map;

import static io.restassured.RestAssured.given;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.emptyString;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;
import static org.hamcrest.Matchers.not;

public class ExtraApi {
    private ResponseOptions<Response> response;
    private RequestSpecification spec;
    private RequestSpecBuilder builder;
    private String requestBody;

    @Given("^I setup GET for API path \"([^\"]*)\"$")
    public void iSetupGetForApiPath(String path) {
        builder = new RequestSpecBuilder();
        builder.setBaseUri(API.baseUri + path);
        builder.setContentType(ContentType.JSON);
        builder.setRelaxedHTTPSValidation();
    }

    @Given("^I setup POST for API path \"([^\"]*)\"$")
    public void iSetupPostForApiPath(String path) {
        builder = new RequestSpecBuilder();
        builder.setBaseUri(API.baseUri + path);
        builder.setContentType(ContentType.JSON);
        builder.setRelaxedHTTPSValidation();
    }

    @And("^I set query parameters$")
    public void iSetQueryParameters(DataTable dataTable) {
        List<Map<String, String>> data = dataTable.asMaps(String.class, String.class);
        for (Map<String, String> datum : data) {
            builder.addQueryParam(datum.get("param"), datum.get("value"));
        }
        spec = given().spec(builder.build());
    }

    @And("^I set request body to:$")
    public void iSetRequestBodyTo(String body) {
        this.requestBody = body;
        if (spec == null) {
            spec = given().spec(builder.build());
        }
    }

    @When("^I perform GET request$")
    public void iPerformGetRequest() {
        if (spec == null) {
            spec = given().spec(builder.build());
        }
        response = spec.get();
    }

    @When("^I perform POST request$")
    public void iPerformPostRequest() {
        if (spec == null) {
            spec = given().spec(builder.build());
        }
        if (requestBody != null) {
            spec.body(requestBody);
        }
        response = spec.post();
    }

    @Then("^HTTP status code should be (\\d+)$")
    public void httpStatusCodeShouldBe(int expectedStatusCode) {
        assertThat(response.statusCode(), equalTo(expectedStatusCode));
    }

    @And("^response body should contain \"([^\"]*)\"$")
    public void responseBodyShouldContain(String text) {
        assertThat(response.getBody().asString(), containsString(text));
    }

    @And("^there should be at least (\\d+) addresses in the response$")
    public void thereShouldBeAtLeastAddressesInTheResponse(int minAddresses) {
        List<?> addresses = response.getBody().jsonPath().getList("response.addresses");
        int count = addresses == null ? 0 : addresses.size();
        assertThat(count, greaterThanOrEqualTo(minAddresses));
    }

    @And("^response body should not be empty$")
    public void responseBodyShouldNotBeEmpty() {
        assertThat(response.getBody().asString(), not(emptyString()));
    }
}


