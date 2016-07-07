-- file: bmltvox.lua
-- created: 2016-05-01
-- author: danny gershman
-- description:

JSON = dofile("/usr/local/freeswitch/scripts/JSON.lua");

session:answer();
session:sleep(2000);
session:set_tts_params("flite", "kal");
--session:speak("hello, please enter your 5 digit zip code, followed by the pound sign");
--local digits = session:getDigits(5, "#", 5000);

--session:speak("Searching meeting information...");

api = freeswitch.API();
raw_data = api:execute("curl", "http://bmlt.ncregion-na.org/main_server/client_interface/json/?switcher=GetSearchResults&weekdays=1&geo_width=-10&long_val=-79.793701171875&lat_val=36.065752051707&StartsAfter$

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
