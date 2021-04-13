///*
//package stepdefs;
//
//import cucumber.api.DataTable;
//import cucumber.api.java.en.And;
//import cucumber.api.java.en.Given;
//import cucumber.api.java.en.Then;
//import io.restassured.builder.RequestSpecBuilder;
//import io.restassured.http.ContentType;
//import io.restassured.path.json.JsonPath;
//import io.restassured.response.Response;
//import io.restassured.response.ResponseOptions;
//import io.restassured.specification.RequestSpecification;
//import org.hamcrest.Matchers;
//
//import java.net.URI;
//import java.util.List;
//
//import static io.restassured.RestAssured.given;
//import static org.hamcrest.MatcherAssert.assertThat;
//import static org.hamcrest.Matchers.equalTo;
//
//public class AddressIndexDefinitions {
//    private ResponseOptions<Response> response;
//    private RequestSpecification spec;
//
//
//    @Given("^I perform get operation for postcode \"([^\"]*)\"$")
//    public void iPerformGetOperationForPostcode(String path) throws Throwable {
//        RequestSpecBuilder builder = new RequestSpecBuilder();
//        builder.setBaseUri("http://localhost:9001/addresses/postcode");
//        builder.setContentType(ContentType.JSON);
//        RequestSpecification requestSpec = builder.build();
//        spec = given().spec(requestSpec);
//    }
//
//    @And("^I perform GET for postcode \"([^\"]*)\"$")
//    public void iPerformGETForPostcode(String postCode) throws Throwable {
//        response = spec.get(new URI(postCode));
//    }
//
//    @Then("^I should be able to see the list of addresses in the postcode$")
//    public void iShouldBeAbleToSeeTheListOfAddressesInThePostcode() {
//        JsonPath jsonPath = response.getBody().jsonPath();
//        System.out.println(response.getBody().prettyPrint());
//        assertThat(jsonPath.get("response.addresses.formattedAddress[0]"),
//                Matchers.<Object>equalTo("6473FF-6623JJ, The Building Name, A Training Centre, 56HH-7755OP And Another Street Descriptor, Locality Xyz, Town B, KL3 7GQ"));
//    }
//
//
//    @Given("^I perform get operation for uprn  \"([^\"]*)\"$")
//    public void iPerformGetOperationForUprn(String arg0) throws Throwable {
//        RequestSpecBuilder builder = new RequestSpecBuilder();
//        builder.setBaseUri("http://localhost:9001/addresses/uprn");
//        builder.setContentType(ContentType.JSON);
//        RequestSpecification requestSpec = builder.build();
//        spec = given().spec(requestSpec);
//    }
//
//    @And("^I perform GET for uprn \"([^\"]*)\"$")
//    public void iPerformGETForUprn(String uprn) throws Throwable {
//        response = spec.get(new URI(uprn));
//    }
//
//    @Then("^I should be able to see the list of addresses in the given uprn$")
//    public void iShouldBeAbleToSeeTheListOfAddressesInTheGivenUprn() {
//        JsonPath jsonPath = response.getBody().jsonPath();
//        assertThat(jsonPath.get("response.address.formattedAddress"),
//                Matchers.<Object>equalTo("6473FF-6623JJ, The Building Name, A Training Centre, 56HH-7755OP And Another Street Descriptor, Locality Xyz, Town B, KL3 7GQ"));
//    }
//
//
//    @And("^Verify Response body contents matched with expected values$")
//    public void verifyResponseBodyContentsMatchedWithExpectedValues(DataTable table) {
//        List<List<String>> raw = table.raw();
//        assertThat((response.getBody().jsonPath().get("status.code")).toString(), equalTo(raw.get(1).get(1)));
//        assertThat((response.getBody().jsonPath().get("status.message")).toString(), equalTo(raw.get(2).get(1)));
//    }
//
//}
//*/
