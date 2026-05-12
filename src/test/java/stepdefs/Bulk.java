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
import org.hamcrest.Matchers;

import java.io.File;
import java.util.List;
import java.util.Map;

import static io.restassured.RestAssured.given;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;

public class Bulk {

    private ResponseOptions<Response> response;
    private RequestSpecification spec;
    RequestSpecBuilder builder;
    private final String uri_bulk = API.bulkUri + "/bulk";
    private String requestBodyFixturePath = "src/test/resources/bulktest.json";


    @Given("^I setup POST for bulk addresses$")
    public void iSetupPOSTForBulkAddresses() throws Throwable {
        builder = new RequestSpecBuilder();
        builder.setBaseUri(uri_bulk);
        builder.setContentType(ContentType.JSON);
        builder.setRelaxedHTTPSValidation();
    }

    @And("^I set parameters for bulk addresses search$")
    public void iSetParametersForBulkAddressesSearch(DataTable dataTable) throws Throwable {
        List<Map<String, String>> data =  dataTable.asMaps(String.class, String.class);
        for (Map<String, String> datum : data) {
            builder.addQueryParam(datum.get("param"), datum.get("value"));
        }
        RequestSpecification requestSpec = builder.build();
        spec = given().spec(requestSpec);
    }

    @And("^I use bulk request body fixture \"([^\"]*)\"$")
    public void iUseBulkRequestBodyFixture(String fixtureFileName) {
        requestBodyFixturePath = "src/test/resources/" + fixtureFileName;
    }

    @When("^I perform POST for bulk addresses$")
    public void iPerformPostForBulkAddress() throws Throwable {
        File jsonDataInFile = new File(requestBodyFixturePath);
        spec.body(jsonDataInFile);
        spec.contentType("application/json");
        response = spec.post();
    }

    @And("^The bulk response status code should be (\\d+)$")
    public void theBulkResponseStatusCodeShouldBe(int expectedStatusCode) {
        assertThat(response.statusCode(), equalTo(expectedStatusCode));
    }

    @Then("^The bulk response should return in (\\d+) milliseconds$")
    public void theBulkResponseShouldReturnInMilliSeconds(long timeAllowed) {
        long timeTaken = response.getTime(); // test
        System.out.println(timeTaken);
        assertThat(timeAllowed,Matchers.greaterThan(timeTaken));
    }

}
