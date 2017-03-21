-- file: bmltvox.lua
-- created: 2016-05-01
-- author: danny gershman
-- description:

JSON = dofile("/usr/local/freeswitch/scripts/JSON.lua");
api = freeswitch.API();

freeswitch.consoleLog("INFO", "*** BMLT VOX***\r\n");

session:answer();
while (session:ready() == true) do
  session:setAutoHangup(false);
  session:set_tts_params("flite", "kal");
  session:speak("hello, please enter your 5 digit zip code, followed by the pound sign");
  local digits = session:getDigits(5, "#", 5000);

  postcode_lookup_raw_data = api:execute("curl", "http://maps.googleapis.com/maps/api/geocode/json?address=" .. digits)
  freeswitch.consoleLog("INFO", postcode_lookup_raw_data)
  postcode_lookup_data = JSON:decode(postcode_lookup_raw_data)
  location = postcode_lookup_data["results"][1]["formatted_address"]
  lat = postcode_lookup_data["results"][1]["geometry"]["location"]["lat"]
  lng = postcode_lookup_data["results"][1]["geometry"]["location"]["lng"]

  session:speak("Searching meeting information for " .. location);

  raw_data = api:execute("curl", "http://bmlt.ncregion-na.org/main_server/client_interface/json/index.php?switcher=GetSearchResults&sort_keys=weekday_tinyint,start_time&bmlt_settings_id=1459228577&long_val=" .. lng .. "&lat_val=" .. lat .. "&geo_width=-10&search_form=1&script_name=%2Findex.php&satellite=%2Findex.php&supports_ajax=yes&no_ajax_check=yes");

  if raw_data ~= "" then
          bmlt_data = JSON:decode(raw_data);
  end

  session:speak("Meeting information found, listing the top 3 results");

  for i=1,3,1
  do
          result = bmlt_data[i];
          session:speak("result number " .. i);
          session:speak(result["meeting_name"]);
          session:speak("starts at " .. result["start_time"]);
          session:speak("meets at " .. result["location_street"] .. " in " .. result["location_municipality"]);
  end
end
