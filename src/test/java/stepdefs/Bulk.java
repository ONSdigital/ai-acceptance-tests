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

public class Bulk {

    private ResponseOptions<Response> response;
    private RequestSpecification spec;
    RequestSpecBuilder builder;
    private final String uri_bulk = API.bulkUri + "bulk";


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

    @When("^I perform POST for bulk addresses$")
    public void iPerformPostForBulkAddress() throws Throwable {
        File jsonDataInFile = new File("src/test/resources/bulktest.json");
        spec.body(jsonDataInFile);
        spec.contentType("application/json");
        response = spec.post();
    }

    @Then("^The bulk response should return in (\\d+) milliseconds$")
    public void theBulkResponseShouldReturnInMilliSeconds(long timeAllowed) {
        long timeTaken = response.getTime(); // test
        System.out.println(timeTaken);
        assertThat(timeAllowed,Matchers.greaterThan(timeTaken));
    }

}
