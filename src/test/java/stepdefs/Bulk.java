package stepdefs;

import cucumber.api.DataTable;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import io.restassured.authentication.PreemptiveBasicAuthScheme;
import io.restassured.authentication.PreemptiveOAuth2HeaderScheme;
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
    private String uri_bulk = API.bulkUri + "bulk";
    private String bearer = API.bearer.replace("token: ","");


    @Given("^I setup POST for bulk addresses$")
    public void iSetupPOSTForBulkAddresses() throws Throwable {
        builder = new RequestSpecBuilder();
        builder.setBaseUri(uri_bulk);
        builder.setContentType(ContentType.JSON);
        PreemptiveOAuth2HeaderScheme authenticationScheme = new PreemptiveOAuth2HeaderScheme();
        authenticationScheme.setAccessToken(bearer);
        builder.setAuth(authenticationScheme);
        builder.setRelaxedHTTPSValidation();
    }

    @And("^I set parameters for bulk addresses search$")
    public void iSetParametersForBulkAddressesSearch(DataTable dataTable) throws Throwable {
        List<Map<String, String>> data =  dataTable.asMaps(String.class, String.class);
        for (int param=0; param < data.size(); param++) {
            builder.addQueryParam(data.get(param).get("param"), data.get(param).get("value"));
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
