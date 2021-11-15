package stepdefs;

import cucumber.api.DataTable;
import cucumber.api.PendingException;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;

import static java.lang.Thread.sleep;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;

import cucumber.api.java.en.When;
import io.restassured.authentication.PreemptiveBasicAuthScheme;
import io.restassured.authentication.PreemptiveOAuth2HeaderScheme;
import io.restassured.builder.RequestSpecBuilder;
import io.restassured.http.ContentType;
import io.restassured.response.Response;
import io.restassured.response.ResponseOptions;
import io.restassured.specification.RequestSpecification;
import org.hamcrest.Matchers;

import java.util.List;
import java.util.Map;

import static io.restassured.RestAssured.given;

public class Random {

    private ResponseOptions<Response> response;
    private RequestSpecification spec;
    RequestSpecBuilder builder;
    private String uri_random = API.baseUri + "addresses/random";
    private String bearer = API.bearer;


    @Given("^I setup GET for random address$")
    public void iSetupGETForRandomAddress() throws Throwable {
        builder = new RequestSpecBuilder();
        builder.setBaseUri(uri_random);
        builder.setContentType(ContentType.JSON);
        PreemptiveOAuth2HeaderScheme authenticationScheme = new PreemptiveOAuth2HeaderScheme();
        authenticationScheme.setAccessToken(bearer);
        builder.setAuth(authenticationScheme);
        builder.setRelaxedHTTPSValidation();
        builder.addHeader("Expect", "100-continue");
    }

    @And("^I set parameters for random address search$")
    public void iSetParametersForRandomAddressSearch(DataTable dataTable) throws Throwable {
        List<Map<String, String>> data =  dataTable.asMaps(String.class, String.class);
        builder.addQueryParam("epoch","87");
        for (int param=0; param < data.size(); param++) {
            builder.addQueryParam(data.get(param).get("param"), data.get(param).get("value"));
        }
        RequestSpecification requestSpec = builder.build();
        spec = given().spec(requestSpec);
    }

    @When("^I perform GET for random address$")
    public void iPerformGetForRandomAddress() throws Throwable {
        response = spec.get();
    }

    @Then("^The random response should contain (\\d+) address$")
    public void theRandomResponseShouldContainAddress(int numAddr) throws Throwable {
        API api = new API();
        sleep(1000);
        int numAddresses = api.numAddresses(response);
        assertThat(numAddr,Matchers.equalTo(numAddresses));
    }

    @Then("^the first (\\d+) random addresses should have countryCode \"([^\"]*)\"$")
    public void theFirstNRandomAddressesShouldHaveCountryCode(int numAddresses, String countryCode) throws Throwable {
        API api = new API();
        sleep(1000);
        boolean foundInAllTopNAddresses = api.countryCodeFoundInAllTopNAddresses(numAddresses, countryCode, response);
        assertThat(foundInAllTopNAddresses, Matchers.equalTo(true));
    }
}
