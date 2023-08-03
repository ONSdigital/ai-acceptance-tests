package stepdefs;
import cucumber.api.DataTable;
import cucumber.api.PendingException;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import cucumber.api.java.en.Then;
import io.restassured.authentication.PreemptiveOAuth2HeaderScheme;
import io.restassured.builder.RequestSpecBuilder;
import io.restassured.http.ContentType;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import io.restassured.response.ResponseOptions;
import io.restassured.specification.RequestSpecification;
import io.restassured.authentication.PreemptiveBasicAuthScheme;
import org.hamcrest.Matchers;

import java.net.URI;
import java.util.List;
import java.util.Map;

import static io.restassured.RestAssured.given;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;


public class Postcode {
    private ResponseOptions<Response> response;
    private RequestSpecification spec;
    RequestSpecBuilder builder;
    private String uri_pc = API.baseUri + "addresses/postcode";
    private String bearer = API.bearer.replace("token: ","");

    @Given("^the user defines GET for postcode with these parameters$")
    public void the_user_defines_get_for_postcode_with_these_parameters(DataTable dataTable) throws Throwable {
        builder = new RequestSpecBuilder();
        builder.setBaseUri(uri_pc);
        builder.setContentType(ContentType.JSON);
        PreemptiveOAuth2HeaderScheme authenticationScheme = new PreemptiveOAuth2HeaderScheme();
        authenticationScheme.setAccessToken(bearer);
        builder.setAuth(authenticationScheme);
        builder.setRelaxedHTTPSValidation();
    //    builder.addHeader("Expect", "100-continue");
        builder.addQueryParam("epoch","101");
        List<Map<String, String>> data = dataTable.asMaps(String.class, String.class);
        for (int param=0; param < data.size(); param++) {
            builder.addQueryParam(data.get(param).get("param"), data.get(param).get("value"));
        }
        RequestSpecification requestSpec = builder.build();
        spec = given().spec(requestSpec);
    }

    @Then("^The postcode results should not include any of these classification codes$")
    public void thePostcodeResultsShouldNotIncludeAnyOfTheseClassificationCodes(DataTable classificationCodes) throws Throwable {
        API api = new API();
        boolean found = api.classificationCodeFound(classificationCodes, response);
        assertThat(found, Matchers.equalTo(false));
    }

    @When("^the user performs GET for postcode \"([^\"]*)\"$")
    public void the_user_performs_get_for_postcode(String postCode) throws Throwable {
        response = spec.get(postCode);
    }

    @Then("^the postcode results should not include UPRN \"([^\"]*)\"$")
    public void the_postcode_results_should_not_include_uprn(String uprn) throws Throwable {
        API api = new API();
        boolean uprnFound = api.uprnFound(uprn, response);
        api = null; //
        assertThat(uprnFound, Matchers.equalTo(false));
    }

    @Then("^I should be able to see the list of addresses in the postcode$")
    public void iShouldBeAbleToSeeTheListOfAddressesInThePostcode() {
        JsonPath jsonPath = response.getBody().jsonPath();
//        System.out.println(response.getBody().prettyPrint());
        assertThat(jsonPath.get("response.addresses.formattedAddress[0]"),
                Matchers.<Object>equalTo("6473FF-6623JJ, The Building Name, A Training Centre, 56HH-7755OP And Another Street Descriptor, Locality Xyz, Town B, KL3 7GQ"));
    }

    @Then("^the postcode results should contain these UPRNs at positions$")
    public void the_postcode_results_should_contain_these_uprns_at_positions(DataTable dataTable) {
        API api = new API();
        boolean match = api.uprnsAllFoundInCorrectOrder(response, dataTable);
        assertThat(match, Matchers.equalTo(true));
    }

    @Then("^the postcode results should contain all these UPRNs in any address$")
    public void the_postcode_results_should_contain_all_these_UPRNs_in_any_address(DataTable uprns) throws Exception {
        API api = new API();
        boolean found = api.allUprnsFound(uprns, response);
        assertThat(found, Matchers.equalTo(true));
    }

    @And("^Verify postcode response status$")
    public void verify_postcode_response_status(DataTable table) {
        List<List<String>> raw = table.raw();
        assertThat((response.getBody().jsonPath().get("status.code")).toString(), equalTo(raw.get(1).get(1)));
        assertThat((response.getBody().jsonPath().get("status.message")).toString(), equalTo(raw.get(2).get(1)));
    }

    @Then("^the results should all have formattedAddress includes \"([^\"]*)\"$")
    public void theResultsShouldAllHaveFormattedAddressIncludes(String postcode) throws Throwable {
        API api = new API();
        boolean allContain = api.allAddressesContain(postcode, response);
        assertThat(allContain, Matchers.equalTo(true));
    }

    @Then("^there should be (\\d+) addresses$")
    public void there_should_be_addresses(int numAddresses) throws Exception {
        API api = new API();
        int countAddresses = api.numAddresses(response);
        assertThat(countAddresses, Matchers.equalTo(numAddresses));
    }

    @Then("^the first (\\d+) addresses should have countryCode \"([^\"]*)\"$")
    public void theFirstAddressesShouldHaveCountryCode(int numAddresses, String countryCode) throws Throwable {
        API api = new API();
        boolean foundInAllTopNAddresses = api.countryCodeFoundInAllTopNAddresses(numAddresses, countryCode, response);
        assertThat(foundInAllTopNAddresses, Matchers.equalTo(true));
    }

    @Then("^the first (\\d+) addresses should not have countryCode \"([^\"]*)\"$")
    public void theFirstAddressesShouldNotHaveCountryCode(int numAddresses, String countryCode) throws Throwable {
        API api = new API();
        boolean foundInAllTopNAddresses = api.countryCodeFoundInAllTopNAddresses(numAddresses, countryCode, response);
        assertThat(foundInAllTopNAddresses, Matchers.equalTo(false));
    }
}
