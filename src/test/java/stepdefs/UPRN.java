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
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import io.restassured.response.ResponseOptions;
import io.restassured.specification.RequestSpecification;
import org.hamcrest.Matchers;

import java.net.URI;
import java.util.List;
import java.util.Map;

import static io.restassured.RestAssured.given;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;

public class UPRN {

    private ResponseOptions<Response> response; // TODO: base class
    private RequestSpecification spec;
    RequestSpecBuilder builder;
    private String uri_uprn = API.baseUri + "addresses/uprn";
    private String bearer = API.bearer;

    @Given("^I setup GET for UPRN$")
    public void i_setup_GET() throws Throwable {
        builder = new RequestSpecBuilder();
        builder.setBaseUri(uri_uprn);
        builder.setContentType(ContentType.JSON);
        PreemptiveOAuth2HeaderScheme authenticationScheme = new PreemptiveOAuth2HeaderScheme();
        authenticationScheme.setAccessToken(bearer);
        builder.setAuth(authenticationScheme);

    }

    @And("^I set the following parameters for UPRN$")
    public void iSetTheFollowingParametersForUPRN(DataTable dataTable) {
        List<Map<String, String>> data = dataTable.asMaps(String.class, String.class);
        builder.addQueryParam("epoch","87");
        for (int param=0; param < data.size(); param++) {
            builder.addQueryParam(data.get(param).get("param"), data.get(param).get("value"));
        }
        RequestSpecification requestSpec = builder.build();
        spec = given().spec(requestSpec);
    }

    @When("^I perform GET for UPRN \"([^\"]*)\"$")
    public void iPerformGETForUPRN(String uprn) throws Throwable {
        response = spec.get(uprn);
    }

    @Then("^The result should be this postcode \"([^\"]*)\"$")
    public void the_result_should_be_this_postcode(String arg1) throws Exception {
        // Write code here that turns the phrase above into concrete actions
    }

    @And("^Verify UPRN Response body contents matched with expected values$")
    public void verifyUPRNResponseBodyContentsMatchedWithExpectedValues(DataTable table) {
        List<List<String>> raw = table.raw();
        assertThat((response.getBody().jsonPath().get("status.code")).toString(), equalTo(raw.get(1).get(1)));
        assertThat((response.getBody().jsonPath().get("status.message")).toString(), equalTo(raw.get(2).get(1)));
    }
}
