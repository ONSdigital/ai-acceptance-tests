package stepdefs;

import cucumber.api.DataTable;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import gherkin.deps.com.google.gson.JsonArray;
import gherkin.deps.com.google.gson.JsonElement;
import gherkin.deps.com.google.gson.JsonObject;
import gherkin.deps.com.google.gson.JsonParser;
import gherkin.deps.com.google.gson.stream.JsonReader;
import io.restassured.authentication.PreemptiveBasicAuthScheme;
import io.restassured.builder.RequestSpecBuilder;
import io.restassured.http.ContentType;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import io.restassured.response.ResponseBody;
import io.restassured.response.ResponseOptions;
import io.restassured.specification.RequestSpecification;
import org.hamcrest.Matchers;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import static io.restassured.RestAssured.given;
import static io.restassured.path.json.JsonPath.from;
import static org.hamcrest.MatcherAssert.assertThat;

// TODO - static methods not possible?
public class API {

    public static final String baseUri = "https://whitelodge-ai-api.census-gcp.onsdigital.uk/";
    public static final String bulkUri = "https://initial-test-bulk-3.aims.gcp.onsdigital.uk/";
    public static final String authMethod = "basic";
   //  public static final String authMethod = "bearer";
    public static final String username = "rhuser";
   // the next two fields must have dummy values in GitHub
    public static final String password = "dummy";
    public static final String bearer = "dummy";

   // TODO: does java do by ref?
    public boolean addressStringFound(String addressContents, ResponseOptions<Response> response) throws Throwable {
        JsonPath path = response.getBody().jsonPath();

        for (int nAddress = 0; nAddress < numAddresses(response); nAddress++) {
            String addressPath = String.format("response.addresses[%d].formattedAddress", nAddress);
            String address = path.get(addressPath).toString().toUpperCase();

            if (address.contains(addressContents.toUpperCase()) == true)
                return true;
        }
        return false;
    }

    public boolean allAddressesContain(String addressContents, ResponseOptions<Response> response) throws Throwable {
        JsonPath path = response.getBody().jsonPath();

        for (int nAddress = 0; nAddress < numAddresses(response); nAddress++) {
            String addressPath = String.format("response.addresses[%d].formattedAddress", nAddress);
            String address = path.get(addressPath).toString().toUpperCase();

            if (address.contains(addressContents.toUpperCase()) == false)
                return false;
        }
        return true;
    }

//    public int numAddresses(ResponseOptions<Response> response)
//    {
//        int limit = Integer.parseInt(response.getBody().jsonPath().get("response.limit").toString());
//        int total = Integer.parseInt(response.getBody().jsonPath().get("response.total").toString());
//        int numAddresses = limit < total ? limit : total;
//        return numAddresses;
//    }

    public int numAddresses(ResponseOptions<Response> response)
    {
        List<String> addresses = response.getBody().jsonPath().getList("response.addresses");
        return addresses.size();
    }

    public boolean classificationCodeFound(DataTable classification_codes, ResponseOptions<Response> response) {
        List<String> codes =  classification_codes.asList(String.class);
        List<String> addresses = response.getBody().jsonPath().getList("response.addresses");

        for (int nAddress = 0; nAddress < addresses.size(); nAddress++) {
            String classificationPath = String.format("response.addresses[%d].classificationCode", nAddress);
            String classificationCode = response.getBody().jsonPath().get(classificationPath).toString();

            for (int nCode = 0; nCode < codes.size(); nCode++) {
                if (classificationCode.contentEquals(codes.get(nCode)) == true)
                    return true;
            }
        }
        return false;
    }

    public boolean allUprnsFound(DataTable uprns, ResponseOptions<Response> response) {
        List<String> uprn =  uprns.asList(String.class);
        //uprn.stream().filter(u->uprnFound(uprn.get(u), response)).findFirst().equals(false);
        for (int u = 0; u < uprn.size(); u++)
        {
            if (uprnFound(uprn.get(u), response) == false)
                return false;
        }
        // do I need to check the position in list?
        return true;
    }

    public boolean uprnFound(String uprn, ResponseOptions<Response> response)
    {
        JsonPath path = response.getBody().jsonPath();
        List<String> addresses = response.getBody().jsonPath().getList("response.addresses");

        for (int nAddress = 0; nAddress < addresses.size(); nAddress++) {
            String uprnPath = String.format("response.addresses[%d].uprn", nAddress);
            String uprnResult = response.getBody().jsonPath().get(uprnPath).toString();
            if (uprn.contentEquals(uprnResult) == true)
                return true;
        }
        return false;
    }

    public boolean countryCodeFoundInAllTopNAddresses(int numTopAddressesToSearch,String countryCode, ResponseOptions<Response> response)
    {
        JsonPath path = response.getBody().jsonPath();
        List<String> addresses = response.getBody().jsonPath().getList("response.addresses");
        if (addresses.size() >= numTopAddressesToSearch) {
            for (int nAddress = 0; nAddress < numTopAddressesToSearch; nAddress++) {
                String countryPath = String.format("response.addresses[%d].census.countryCode", nAddress);
                String countryResult = response.getBody().jsonPath().get(countryPath).toString();
                if (!countryCode.contentEquals(countryResult))
                    return false;
            }
        }
        return true;
    }

    public boolean uprnsAllFoundInCorrectOrder(ResponseOptions<Response> response, DataTable uprnTable) {
        JsonPath jsonPath = response.getBody().jsonPath();
        List<Map<String, String>> uprns = uprnTable.asMaps(String.class, String.class);
        if (numAddresses(response) == 0 || numAddresses(response) < uprns.size())
            return false;
        for (int uprn = 0; uprn < uprns.size(); uprn++) {
            String response_address_uprn = String.format("response.addresses.uprn[%d]", uprn);
            if (response_address_uprn.contentEquals(uprns.get(uprn).toString()))
                return false;
        }
        return true;
    }
}
