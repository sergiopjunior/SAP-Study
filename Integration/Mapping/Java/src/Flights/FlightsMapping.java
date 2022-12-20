package Flights;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import com.sap.aii.mapping.api.AbstractTransformation;
import com.sap.aii.mapping.api.StreamTransformationException;
import com.sap.aii.mapping.api.TransformationInput;
import com.sap.aii.mapping.api.TransformationOutput;
import org.xml.sax.SAXException;

public class FlightsMapping extends AbstractTransformation {
    private final static String sap_date_format = "uuuu/MM/dd";
    private final static String local_date_format = "dd/MM/uuuu";

    @Override
    public void transform(TransformationInput in, TransformationOutput out) throws StreamTransformationException {
        try {
            InputStream inputstream = in.getInputPayload().getInputStream();
            OutputStream outputstream = out.getOutputPayload().getOutputStream();
            DocumentBuilder docBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();

            Document inDoc = docBuilder.parse(inputstream);
            Document outDoc = BuildOutputDocument(inDoc);

            TransformerFactory.newInstance().newTransformer().transform(new DOMSource(outDoc), new StreamResult(outputstream));

        } catch (Exception e) {
            getTrace().addDebugMessage(e.getMessage());
            throw new StreamTransformationException(e.toString());
        }
    }

    public void test_transform(File in_payload, File out_payload) throws Exception {
        DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
        docBuilderFactory.setNamespaceAware(true);
        DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();

        Document inDoc = docBuilder.parse(in_payload);
        Document outDoc = BuildOutputDocument(inDoc);

        TransformerFactory.newInstance().newTransformer().transform(new DOMSource(outDoc), new StreamResult(out_payload));
    }

    private Document BuildOutputDocument(Document outDoc) {
        outDoc.renameNode(outDoc.getElementsByTagName("d").item(0), "https://lnl-s4h.opustech.com.br/Flights", "Response");
        Element Response = (Element) outDoc.getElementsByTagName("Response").item(0);
        Response.setPrefix("resp");
        Response.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:data", "https://lnl-s4h.opustech.com.br/FlightsData");
        Response.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:info", "https://lnl-s4h.opustech.com.br/FlightInfo");

        Element Result = outDoc.createElement("Results");
        Result.setAttributeNS("http://www.w3.org/2000/xmlns/","xmlns:data", "https://lnl-s4h.opustech.com.br/FlightsData");
        Response.insertBefore(Result, Response.getFirstChild());

        NodeList results = outDoc.getElementsByTagName("results");

        int len = results.getLength();
        for (int i = 0; i < len; i++) {
            Element Flight = (Element) results.item(0);
            Flight.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:info", "https://lnl-s4h.opustech.com.br/FlightInfo");
            outDoc.renameNode(Flight, null, "Flight");

            String uri = Flight.getElementsByTagName("uri").item(0).getTextContent();
            Element FlightTime = outDoc.createElement("FlightTime");
            try {
                String[] datetime = getFlightDateTime(uri);

                Flight.getElementsByTagName("FlightDate").item(0).setTextContent(datetime[0]);
                FlightTime.appendChild(outDoc.createTextNode(datetime[1]));
            } catch (Exception e) {
                FlightTime.appendChild(outDoc.createTextNode("NULL"));

                e.printStackTrace();
            } finally {
                Flight.insertBefore(FlightTime, Flight.getElementsByTagName("PlaneType").item(0));
            }

            Flight.removeChild(Flight.getElementsByTagName("__metadata").item(0));
            Flight.removeChild(Flight.getElementsByTagName("to_flight_booking_itm").item(0));
            Result.appendChild(Flight);
        }
        outDoc.normalize();
        return outDoc;
    }

    private String[] getFlightDateTime(String uri) {
        String[] datetime;
        try {
            datetime = uri.split("FlightDate=datetime")[1].replace("%3A", ":").replace("-", "/").replace("'", "").replace(")", "").split("T");

            datetime[0] = LocalDate.parse(datetime[0], DateTimeFormatter.ofPattern(sap_date_format)).format(DateTimeFormatter.ofPattern(local_date_format));
        } catch (Exception e) {
            datetime = new String[2];
            datetime[0] = uri;
            datetime[1] = uri;
        }

        return datetime;
    }

}
