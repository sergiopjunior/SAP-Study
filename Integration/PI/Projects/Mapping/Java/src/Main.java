import Flights.FlightsMapping;
import com.sap.aii.mapping.api.StreamTransformationException;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;

public class Main {
    public static void main(String[] args) throws StreamTransformationException {
        try {
            FlightsMapping map = new FlightsMapping();
            File in_payload = new File("src/Flights/flights_in.xml");
            File out_payload = new File("src/Flights/flights_out.xml");
            System.out.println("Starting Java Mapping Test...");

            map.test_transform(in_payload, out_payload);

            System.out.println("End of Java Mapping Test...");
        }
        catch (IOException e) {
            System.out.println(e.getMessage());
        }
        catch (Exception e) {
            System.out.println("Mapping Process Error: " + e.getMessage());
            Arrays.stream(e.getStackTrace()).forEach(System.out::println);
        }
    }
}