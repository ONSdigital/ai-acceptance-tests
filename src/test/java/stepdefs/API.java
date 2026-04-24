package stepdefs;

import cucumber.api.DataTable;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import io.restassured.response.ResponseOptions;
import java.util.List;
import java.util.Map;

public class API {

    public static final String baseUri = System.getenv().get("API_URL");
    public static final String bulkUri = System.getenv().get("API_URL");

    public boolean addressStringFound(String addressContents, ResponseOptions<Response> response) throws Throwable {
        JsonPath path = response.getBody().jsonPath();

        for (int nAddress = 0; nAddress < numAddresses(response); nAddress++) {
            String addressPath = String.format("response.addresses[%d].formattedAddress", nAddress);
            String address = path.get(addressPath).toString().toUpperCase();

            if (address.contains(addressContents.toUpperCase()))
                return true;
        }
        return false;
    }

    public boolean allAddressesContain(String addressContents, ResponseOptions<Response> response) throws Throwable {
        JsonPath path = response.getBody().jsonPath();

        for (int nAddress = 0; nAddress < numAddresses(response); nAddress++) {
            String addressPath = String.format("response.addresses[%d].formattedAddress", nAddress);
            String address = path.get(addressPath).toString().toUpperCase();

            if (!address.contains(addressContents.toUpperCase()))
                return false;
        }
        return true;
    }

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

            for (String code : codes) {
                if (classificationCode.contentEquals(code))
                    return true;
            }
        }
        return false;
    }

    public boolean allUprnsFound(DataTable uprns, ResponseOptions<Response> response) {
        List<String> uprn =  uprns.asList(String.class);
        for (String s : uprn) {
            if (!uprnFound(s, response))
                return false;
        }
        return true;
    }

    public boolean uprnFound(String uprn, ResponseOptions<Response> response)
    {
        List<String> addresses = response.getBody().jsonPath().getList("response.addresses");

        for (int nAddress = 0; nAddress < addresses.size(); nAddress++) {
            String uprnPath = String.format("response.addresses[%d].uprn", nAddress);
            String uprnResult = response.getBody().jsonPath().get(uprnPath).toString();
            if (uprn.contentEquals(uprnResult))
                return true;
        }
        return false;
    }

    public boolean countryCodeFoundInAllTopNAddresses(int numTopAddressesToSearch,String countryCode, ResponseOptions<Response> response)
    {
        List<String> addresses = response.getBody().jsonPath().getList("response.addresses");
        if (addresses.size() >= numTopAddressesToSearch) {
            for (int nAddress = 0; nAddress < numTopAddressesToSearch; nAddress++) {
                String countryPath = String.format("response.addresses[%d].countryCode", nAddress);
                String countryResult = response.getBody().jsonPath().get(countryPath).toString();
                if (!countryCode.contentEquals(countryResult))
                    return false;
            }
        }
        return true;
    }

    public boolean uprnsAllFoundInCorrectOrder(ResponseOptions<Response> response, DataTable uprnTable) {
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
