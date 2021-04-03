package stepdefs;

import cucumber.api.DataTable;
import cucumber.api.PendingException;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import io.restassured.authentication.PreemptiveBasicAuthScheme;
import io.restassured.builder.RequestSpecBuilder;
import io.restassured.http.ContentType;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import io.restassured.response.ResponseOptions;
import io.restassured.specification.RequestSpecification;
import org.hamcrest.Matchers;

import java.util.List;
import java.util.Map;

import static io.restassured.RestAssured.given;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;

public class Addresses {
    private ResponseOptions<Response> response;
    private RequestSpecification spec;
    RequestSpecBuilder builder;
    private String uri = "https://ai-accp-tests-ai-api.ai.census-gcp.onsdigital.uk/addresses";

    @Given("^I setup GET for address$")
    public void iSetupGETForAddress() throws Throwable {
        builder = new RequestSpecBuilder();
        builder.setBaseUri(uri);
        builder.setContentType(ContentType.JSON);
        PreemptiveBasicAuthScheme authenticationScheme = new PreemptiveBasicAuthScheme();
        authenticationScheme.setUserName("allamr");
        authenticationScheme.setPassword("N3wport@1225");
        builder.setAuth(authenticationScheme);
    }

    @And("^I set parameters for address search$")
    public void i_set_parameters_for_address_search(DataTable dataTable) throws Throwable {
        List<Map<String, String>> data =  dataTable.asMaps(String.class, String.class);
        for (int param=0; param < data.size(); param++) {
            builder.addQueryParam(data.get(param).get("param"), data.get(param).get("value"));
        }
        //data.forEach(param->builder.addQueryParam(data.get(param).get("param"), data.get(param).get("value")));
        RequestSpecification requestSpec = builder.build();
        spec = given().spec(requestSpec);
    }

    @When("^I perform GET for address$")
    public void iPerformGetForAddress() throws Throwable {
        response = spec.get();
    }

    @Then("^The first address should contain \"([^\"]*)\"$")
    public void the_first_address_should_contain(String address) throws Throwable {
        JsonPath path = response.getBody().jsonPath();
        String address_result = response.getBody().jsonPath().get("response.addresses[0].formattedAddress");
        assertThat(address_result, Matchers.containsString(address));
    }

    @Then("^The results should include an address which contains \"([^\"]*)\"$")
    public void theResultsShouldIncludeAnAddressWhichContains(String addressContents) throws Throwable {
        API api = new API();
        boolean found = api.addressStringFound(addressContents, response);
        assertThat(found, Matchers.equalTo(true));
    }

    @Then("^The results should not include an address which contains \"([^\"]*)\"$")
    public void theResultsShouldNotIncludeAnAddressWhichContains(String addressContents) throws Throwable {
        API api = new API();
        boolean found = api.addressStringFound(addressContents, response);
        assertThat(found, Matchers.equalTo(false));
    }

    @Then("^The results should include an address with any of these classification codes$")
    public void theResultsShouldIncludeAnAddressWithAnyOfTheseClassificationCodes(DataTable classificationCodes) throws Throwable {
        API api = new API();
        boolean found = api.classificationCodeFound(classificationCodes, response);
        assertThat(found, Matchers.equalTo(true));
    }

    @Then("^The results should not include any of these classification codes$")
    public void theResultsShouldNotIncludeAnyOfTheseClassificationCodes(DataTable classificationCodes) throws Throwable {
        API api = new API();
        boolean found = api.classificationCodeFound(classificationCodes, response);
        assertThat(found, Matchers.equalTo(false));
    }

    @Then("^The results should include these UPRNs at positions$")
    public void the_results_should_include_these_UPRNs_at_positions(DataTable dataTable) throws Throwable {
        JsonPath jsonPath = response.getBody().jsonPath();
        List<Map<String, String>> uprn =  dataTable.asMaps(String.class, String.class);
        assertThat(jsonPath.get("response.addresses.uprn[0]"), Matchers.<Object>equalTo(uprn.get(0).get("uprn")));
        assertThat(jsonPath.get("response.addresses.uprn[1]"), Matchers.<Object>equalTo(uprn.get(1).get("uprn")));
        assertThat(jsonPath.get("response.addresses.uprn[2]"), Matchers.<Object>equalTo(uprn.get(2).get("uprn")));
    }

    @Then("^I should be able to see the address$")
    public void iShouldBeAbleToSeeTheListOfAddressesInTheAddress() throws Throwable {
        JsonPath jsonPath = response.getBody().jsonPath();
        assertThat(jsonPath.get("response.addresses.formattedAddress[0]"),
                Matchers.<Object>equalTo("6473FF-6623JJ, The Building Name, A Training Centre, 56HH-7755OP And Another Street Descriptor, Locality Xyz, Town B, KL3 7GQ"));
    }

    @Then("^I should be able to see the first (\\d+) addresses$")
    public void i_should_be_able_to_see_the_first_addresses(int arg1, DataTable arg2) throws Throwable {
        // Write code here that turns the phrase above into concrete actions
        // For automatic transformation, change DataTable to one of
        // List<YourType>, List<List<E>>, List<Map<K,V>> or Map<K,V>.
        // E,K,V must be a scalar (String, Integer, Date, enum etc)

    }

    // TODO: base class
    @And("^Verify Address Response body contents matched with expected values$")
    public void verifyAddressResponseBodyContentsMatchedWithExpectedValues(DataTable table) throws Throwable {
        List<List<String>> raw = table.raw();
        assertThat((response.getBody().jsonPath().get("status.code")).toString(), equalTo(raw.get(1).get(1)));
        assertThat((response.getBody().jsonPath().get("status.message")).toString(), equalTo(raw.get(2).get(1)));
    }

    // TODO: can I pass by ref?
    public boolean addressStringFound(String addressContents) throws Throwable {
        JsonPath path = response.getBody().jsonPath();
        int numAddresses = path.get("response.total");
        boolean found = false;
        for (int nAddress = 0; nAddress < numAddresses; nAddress++) {
            String addressPath = String.format("response.addresses[%d].formattedAddress", nAddress);
            String address = path.get(addressPath).toString();

            if (address.contains(addressContents))
                return true;
        }
        return false;
    }

    public boolean classificationCodeFound(DataTable classification_codes) {
        List<String> codes =  classification_codes.asList(String.class);
        int limit = Integer.parseInt(response.getBody().jsonPath().get("response.limit").toString());
        int total = Integer.parseInt(response.getBody().jsonPath().get("response.total").toString());
        int numAddresses = limit < total ? limit : total;
        boolean found = false;
        for (int nAddress = 0; nAddress < numAddresses; nAddress++) {
            String classificationPath = String.format("response.addresses[%d].classificationCode", nAddress);
            String classificationCode = response.getBody().jsonPath().get(classificationPath).toString();

            for (int nCode = 0; nCode < codes.size(); nCode++) {
                if (classificationCode.contentEquals(codes.get(nCode)))
                    return true;
            }
        }
        return false;
    }
}
