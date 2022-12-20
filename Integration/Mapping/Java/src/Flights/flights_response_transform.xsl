<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes" encoding="UTF-8" />
	<xsl:template match="/">
		<Response xmlns="https://lnl-s4h.opustech.com.br/Flights"
			xmlns:data="https://lnl-s4h.opustech.com.br/FlightsData" xmlns:info="https://lnl-s4h.opustech.com.br/FlightInfo">
			<data:Results>
				<xsl:for-each select="d/results">
					<info:Flight>
						<Airline>
							<xsl:value-of select="Airline"></xsl:value-of>
						</Airline>
						<FlightNumber>
							<xsl:value-of select="FlightNumber"></xsl:value-of>
						</FlightNumber>
						<CityFrom>
							<xsl:value-of select="CityFrom"></xsl:value-of>
						</CityFrom>
						<CityTo>
							<xsl:value-of select="CityTo"></xsl:value-of>
						</CityTo>
						<CountryFrom>
							<xsl:value-of select="CountryFrom"></xsl:value-of>
						</CountryFrom>
						<CountryTo>
							<xsl:value-of select="CountryTo"></xsl:value-of>
						</CountryTo>
						<xsl:variable name="datetime"
							select='
								substring-after(
								__metadata/uri, "FlightDate=datetime&apos;"
								)
							' 
						/>
						<FlightDate>
							<xsl:variable name="date"
								select='
									translate(
												substring-before($datetime, "T"), "-", "/"
									)
								' 
							/>
							<xsl:value-of
								select='
									concat(
										substring($date, 9, 2),
										substring($date, 5, 4),
										substring($date, 1, 4)
									)
								' 
							/>
						</FlightDate>
						<FlightTime>
							<xsl:value-of
								select='
									translate(translate(
										substring-after($datetime, "T"), "%3A", ":"
										), "&apos;)", ""
									)
								' 
							/>
						</FlightTime>
						<PlaneType>
							<xsl:value-of select="PlaneType"></xsl:value-of>
						</PlaneType>
					</info:Flight>
				</xsl:for-each>
			</data:Results>
		</Response>
	</xsl:template>
</xsl:stylesheet>