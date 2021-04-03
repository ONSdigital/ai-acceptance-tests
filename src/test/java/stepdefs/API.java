package stepdefs;

import cucumber.api.DataTable;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import gherkin.deps.com.google.gson.JsonArray;
import io.restassured.authentication.PreemptiveBasicAuthScheme;
import io.restassured.builder.RequestSpecBuilder;
import io.restassured.http.ContentType;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import io.restassured.response.ResponseOptions;
import io.restassured.specification.RequestSpecification;

import java.util.List;
import java.util.Map;

import static io.restassured.RestAssured.given;

// TODO - why can't I get this to be static?
public class API {

   // TODO: can I pass by ref?
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

    public boolean classificationCodeFound(DataTable classification_codes, ResponseOptions<Response> response) {
        List<String> codes =  classification_codes.asList(String.class);

        for (int nAddress = 0; nAddress < numAddresses(response); nAddress++) {
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
        //path.getList("response.addresses").size();
        //JsonArray arr = path.getJsonObject("response.addresses").
        //JsonArray array = path.getJsonObject("response")

        for (int nAddress = 0; nAddress < numAddresses(response); nAddress++) {
            String uprnPath = String.format("response.addresses[%d].uprn", nAddress);
            String uprnResult = response.getBody().jsonPath().get(uprnPath).toString();
            if (uprn.contentEquals(uprnResult) == true)
                return true;
        }
        return false;
    }

    public int numAddresses(ResponseOptions<Response> response)
    {
        int limit = response.getBody().jsonPath().getInt("response.limit");
        int total = response.getBody().jsonPath().getInt("response.total");
        int numAddresses = limit < total ? limit : total;
        return numAddresses;
    }

    public boolean countryCodeFoundInAllTopNAddresses(int numTopAddressesToSearch,String countryCode, ResponseOptions<Response> response)
    {
        JsonPath path = response.getBody().jsonPath();
        for (int nAddress = 0; nAddress < numTopAddressesToSearch; nAddress++) {
            String countryPath = String.format("response.addresses[%d].census.countryCode", nAddress);
            String countryResult = response.getBody().jsonPath().get(countryPath).toString();
            if (countryCode.contentEquals(countryResult) == false)
                return false;
        }
        return true;
    }
}
