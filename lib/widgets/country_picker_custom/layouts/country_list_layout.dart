import 'package:fixit_provider/widgets/country_picker_custom/country_picker_custom.dart';
import 'package:fixit_provider/widgets/country_picker_custom/layouts/country_theme.dart';
import 'package:flutter/cupertino.dart';
import '../../../../config.dart';

List<Map> countriesEnglish = [
  {"name": "Afghanistan", "dial_code": "+93", "code": "AF"},
  {"name": "Aland Islands", "dial_code": "+358", "code": "AX"},
  {"name": "Albania", "dial_code": "+355", "code": "AL"},
  {"name": "Algeria", "dial_code": "+213", "code": "DZ"},
  {"name": "AmericanSamoa", "dial_code": "+1684", "code": "AS"},
  {"name": "Andorra", "dial_code": "+376", "code": "AD"},
  {"name": "Angola", "dial_code": "+244", "code": "AO"},
  {"name": "Anguilla", "dial_code": "+1264", "code": "AI"},
  {"name": "Antarctica", "dial_code": "+672", "code": "AQ"},
  {"name": "Antigua and Barbuda", "dial_code": "+1268", "code": "AG"},
  {"name": "Argentina", "dial_code": "+54", "code": "AR"},
  {"name": "Armenia", "dial_code": "+374", "code": "AM"},
  {"name": "Aruba", "dial_code": "+297", "code": "AW"},
  {"name": "Australia", "dial_code": "+61", "code": "AU"},
  {"name": "Austria", "dial_code": "+43", "code": "AT"},
  {"name": "Azerbaijan", "dial_code": "+994", "code": "AZ"},
  {"name": "Bahamas", "dial_code": "+1242", "code": "BS"},
  {"name": "Bahrain", "dial_code": "+973", "code": "BH"},
  {"name": "Bangladesh", "dial_code": "+880", "code": "BD"},
  {"name": "Barbados", "dial_code": "+1246", "code": "BB"},
  {"name": "Belarus", "dial_code": "+375", "code": "BY"},
  {"name": "Belgium", "dial_code": "+32", "code": "BE"},
  {"name": "Belize", "dial_code": "+501", "code": "BZ"},
  {"name": "Benin", "dial_code": "+229", "code": "BJ"},
  {"name": "Bermuda", "dial_code": "+1441", "code": "BM"},
  {"name": "Bhutan", "dial_code": "+975", "code": "BT"},
  {
    "name": "Bolivia, Plurinational State of",
    "dial_code": "+591",
    "code": "BO"
  },
  {"name": "Bosnia and Herzegovina", "dial_code": "+387", "code": "BA"},
  {"name": "Botswana", "dial_code": "+267", "code": "BW"},
  {"name": "Brazil", "dial_code": "+55", "code": "BR"},
  {"name": "British Indian Ocean Territory", "dial_code": "+246", "code": "IO"},
  {"name": "Brunei Darussalam", "dial_code": "+673", "code": "BN"},
  {"name": "Bulgaria", "dial_code": "+359", "code": "BG"},
  {"name": "Burkina Faso", "dial_code": "+226", "code": "BF"},
  {"name": "Burundi", "dial_code": "+257", "code": "BI"},
  {"name": "Cambodia", "dial_code": "+855", "code": "KH"},
  {"name": "Cameroon", "dial_code": "+237", "code": "CM"},
  {"name": "Canada", "dial_code": "+1", "code": "CA"},
  {"name": "Cape Verde", "dial_code": "+238", "code": "CV"},
  {"name": "Cayman Islands", "dial_code": "+ 345", "code": "KY"},
  {"name": "Central African Republic", "dial_code": "+236", "code": "CF"},
  {"name": "Chad", "dial_code": "+235", "code": "TD"},
  {"name": "Chile", "dial_code": "+56", "code": "CL"},
  {"name": "China", "dial_code": "+86", "code": "CN"},
  {"name": "Christmas Island", "dial_code": "+61", "code": "CX"},
  {"name": "Cocos (Keeling) Islands", "dial_code": "+61", "code": "CC"},
  {"name": "Colombia", "dial_code": "+57", "code": "CO"},
  {"name": "Comoros", "dial_code": "+269", "code": "KM"},
  {"name": "Congo", "dial_code": "+242", "code": "CG"},
  {
    "name": "Congo, The Democratic Republic of the Congo",
    "dial_code": "+243",
    "code": "CD"
  },
  {"name": "Cook Islands", "dial_code": "+682", "code": "CK"},
  {"name": "Costa Rica", "dial_code": "+506", "code": "CR"},
  {"name": "Cote d'Ivoire", "dial_code": "+225", "code": "CI"},
  {"name": "Croatia", "dial_code": "+385", "code": "HR"},
  {"name": "Cuba", "dial_code": "+53", "code": "CU"},
  {"name": "Cyprus", "dial_code": "+357", "code": "CY"},
  {"name": "Czech Republic", "dial_code": "+420", "code": "CZ"},
  {"name": "Denmark", "dial_code": "+45", "code": "DK"},
  {"name": "Djibouti", "dial_code": "+253", "code": "DJ"},
  {"name": "Dominica", "dial_code": "+1767", "code": "DM"},
  {"name": "Dominican Republic", "dial_code": "+1849", "code": "DO"},
  {"name": "Ecuador", "dial_code": "+593", "code": "EC"},
  {"name": "Egypt", "dial_code": "+20", "code": "EG"},
  {"name": "El Salvador", "dial_code": "+503", "code": "SV"},
  {"name": "Equatorial Guinea", "dial_code": "+240", "code": "GQ"},
  {"name": "Eritrea", "dial_code": "+291", "code": "ER"},
  {"name": "Estonia", "dial_code": "+372", "code": "EE"},
  {"name": "Ethiopia", "dial_code": "+251", "code": "ET"},
  {"name": "Falkland Islands (Malvinas)", "dial_code": "+500", "code": "FK"},
  {"name": "Faroe Islands", "dial_code": "+298", "code": "FO"},
  {"name": "Fiji", "dial_code": "+679", "code": "FJ"},
  {"name": "Finland", "dial_code": "+358", "code": "FI"},
  {"name": "France", "dial_code": "+33", "code": "FR"},
  {"name": "French Guiana", "dial_code": "+594", "code": "GF"},
  {"name": "French Polynesia", "dial_code": "+689", "code": "PF"},
  {"name": "Gabon", "dial_code": "+241", "code": "GA"},
  {"name": "Gambia", "dial_code": "+220", "code": "GM"},
  {"name": "Georgia", "dial_code": "+995", "code": "GE"},
  {"name": "Germany", "dial_code": "+49", "code": "DE"},
  {"name": "Ghana", "dial_code": "+233", "code": "GH"},
  {"name": "Gibraltar", "dial_code": "+350", "code": "GI"},
  {"name": "Greece", "dial_code": "+30", "code": "GR"},
  {"name": "Greenland", "dial_code": "+299", "code": "GL"},
  {"name": "Grenada", "dial_code": "+1473", "code": "GD"},
  {"name": "Guadeloupe", "dial_code": "+590", "code": "GP"},
  {"name": "Guam", "dial_code": "+1671", "code": "GU"},
  {"name": "Guatemala", "dial_code": "+502", "code": "GT"},
  {"name": "Guernsey", "dial_code": "+44", "code": "GG"},
  {"name": "Guinea", "dial_code": "+224", "code": "GN"},
  {"name": "Guinea-Bissau", "dial_code": "+245", "code": "GW"},
  {"name": "Guyana", "dial_code": "+595", "code": "GY"},
  {"name": "Haiti", "dial_code": "+509", "code": "HT"},
  {"name": "Holy See (Vatican City State)", "dial_code": "+379", "code": "VA"},
  {"name": "Honduras", "dial_code": "+504", "code": "HN"},
  {"name": "Hong Kong", "dial_code": "+852", "code": "HK"},
  {"name": "Hungary", "dial_code": "+36", "code": "HU"},
  {"name": "Iceland", "dial_code": "+354", "code": "IS"},
  {"name": "India", "dial_code": "+91", "code": "IN"},
  {"name": "Indonesia", "dial_code": "+62", "code": "ID"},
  {
    "name": "Iran, Islamic Republic of Persian Gulf",
    "dial_code": "+98",
    "code": "IR"
  },
  {"name": "Iraq", "dial_code": "+964", "code": "IQ"},
  {"name": "Ireland", "dial_code": "+353", "code": "IE"},
  {"name": "Isle of Man", "dial_code": "+44", "code": "IM"},
  {"name": "Israel", "dial_code": "+972", "code": "IL"},
  {"name": "Italy", "dial_code": "+39", "code": "IT"},
  {"name": "Jamaica", "dial_code": "+1876", "code": "JM"},
  {"name": "Japan", "dial_code": "+81", "code": "JP"},
  {"name": "Jersey", "dial_code": "+44", "code": "JE"},
  {"name": "Jordan", "dial_code": "+962", "code": "JO"},
  {"name": "Kazakhstan", "dial_code": "+77", "code": "KZ"},
  {"name": "Kenya", "dial_code": "+254", "code": "KE"},
  {"name": "Kiribati", "dial_code": "+686", "code": "KI"},
  {
    "name": "Korea, Democratic People's Republic of Korea",
    "dial_code": "+850",
    "code": "KP"
  },
  {"name": "Korea, Republic of South Korea", "dial_code": "+82", "code": "KR"},
  {"name": "Kuwait", "dial_code": "+965", "code": "KW"},
  {"name": "Kyrgyzstan", "dial_code": "+996", "code": "KG"},
  {"name": "Laos", "dial_code": "+856", "code": "LA"},
  {"name": "Latvia", "dial_code": "+371", "code": "LV"},
  {"name": "Lebanon", "dial_code": "+961", "code": "LB"},
  {"name": "Lesotho", "dial_code": "+266", "code": "LS"},
  {"name": "Liberia", "dial_code": "+231", "code": "LR"},
  {"name": "Libyan Arab Jamahiriya", "dial_code": "+218", "code": "LY"},
  {"name": "Liechtenstein", "dial_code": "+423", "code": "LI"},
  {"name": "Lithuania", "dial_code": "+370", "code": "LT"},
  {"name": "Luxembourg", "dial_code": "+352", "code": "LU"},
  // {"name": "Macao", "dial_code": "+853", "code": "MO"},
  {"name": "Macedonia", "dial_code": "+389", "code": "MK"},
  {"name": "Madagascar", "dial_code": "+261", "code": "MG"},
  {"name": "Malawi", "dial_code": "+265", "code": "MW"},
  {"name": "Malaysia", "dial_code": "+60", "code": "MY"},
  {"name": "Maldives", "dial_code": "+960", "code": "MV"},
  {"name": "Mali", "dial_code": "+223", "code": "ML"},
  {"name": "Malta", "dial_code": "+356", "code": "MT"},
  {"name": "Marshall Islands", "dial_code": "+692", "code": "MH"},
  {"name": "Martinique", "dial_code": "+596", "code": "MQ"},
  {"name": "Mauritania", "dial_code": "+222", "code": "MR"},
  {"name": "Mauritius", "dial_code": "+230", "code": "MU"},
  {"name": "Mayotte", "dial_code": "+262", "code": "YT"},
  {"name": "Mexico", "dial_code": "+52", "code": "MX"},
  {
    "name": "Micronesia, Federated States of Micronesia",
    "dial_code": "+691",
    "code": "FM"
  },
  {"name": "Moldova", "dial_code": "+373", "code": "MD"},
  {"name": "Monaco", "dial_code": "+377", "code": "MC"},
  {"name": "Mongolia", "dial_code": "+976", "code": "MN"},
  {"name": "Montenegro", "dial_code": "+382", "code": "ME"},
  {"name": "Montserrat", "dial_code": "+1664", "code": "MS"},
  {"name": "Morocco", "dial_code": "+212", "code": "MA"},
  {"name": "Mozambique", "dial_code": "+258", "code": "MZ"},
  {"name": "Myanmar", "dial_code": "+95", "code": "MM"},
  {"name": "Namibia", "dial_code": "+264", "code": "NA"},
  {"name": "Nauru", "dial_code": "+674", "code": "NR"},
  {"name": "Nepal", "dial_code": "+977", "code": "NP"},
  {"name": "Netherlands", "dial_code": "+31", "code": "NL"},
  {"name": "Netherlands Antilles", "dial_code": "+599", "code": "AN"},
  {"name": "New Caledonia", "dial_code": "+687", "code": "NC"},
  {"name": "New Zealand", "dial_code": "+64", "code": "NZ"},
  {"name": "Nicaragua", "dial_code": "+505", "code": "NI"},
  {"name": "Niger", "dial_code": "+227", "code": "NE"},
  {"name": "Nigeria", "dial_code": "+234", "code": "NG"},
  {"name": "Niue", "dial_code": "+683", "code": "NU"},
  {"name": "Norfolk Island", "dial_code": "+672", "code": "NF"},
  {"name": "Northern Mariana Islands", "dial_code": "+1670", "code": "MP"},
  {"name": "Norway", "dial_code": "+47", "code": "NO"},
  {"name": "Oman", "dial_code": "+968", "code": "OM"},
  {"name": "Pakistan", "dial_code": "+92", "code": "PK"},
  {"name": "Palau", "dial_code": "+680", "code": "PW"},
  {
    "name": "Palestinian Territory, Occupied",
    "dial_code": "+970",
    "code": "PS"
  },
  {"name": "Panama", "dial_code": "+507", "code": "PA"},
  {"name": "Papua New Guinea", "dial_code": "+675", "code": "PG"},
  {"name": "Paraguay", "dial_code": "+595", "code": "PY"},
  {"name": "Peru", "dial_code": "+51", "code": "PE"},
  {"name": "Philippines", "dial_code": "+63", "code": "PH"},
  {"name": "Pitcairn", "dial_code": "+872", "code": "PN"},
  {"name": "Poland", "dial_code": "+48", "code": "PL"},
  {"name": "Portugal", "dial_code": "+351", "code": "PT"},
  {"name": "Puerto Rico", "dial_code": "+1939", "code": "PR"},
  {"name": "Qatar", "dial_code": "+974", "code": "QA"},
  {"name": "Romania", "dial_code": "+40", "code": "RO"},
  {"name": "Russia", "dial_code": "+7", "code": "RU"},
  {"name": "Rwanda", "dial_code": "+250", "code": "RW"},
  {"name": "Reunion", "dial_code": "+262", "code": "RE"},
  {"name": "Saint Barthelemy", "dial_code": "+590", "code": "BL"},
  {
    "name": "Saint Helena, Ascension and Tristan Da Cunha",
    "dial_code": "+290",
    "code": "SH"
  },
  {"name": "Saint Kitts and Nevis", "dial_code": "+1869", "code": "KN"},
  {"name": "Saint Lucia", "dial_code": "+1758", "code": "LC"},
  {"name": "Saint Martin", "dial_code": "+590", "code": "MF"},
  {"name": "Saint Pierre and Miquelon", "dial_code": "+508", "code": "PM"},
  {
    "name": "Saint Vincent and the Grenadines",
    "dial_code": "+1784",
    "code": "VC"
  },
  {"name": "Samoa", "dial_code": "+685", "code": "WS"},
  {"name": "San Marino", "dial_code": "+378", "code": "SM"},
  {"name": "Sao Tome and Principe", "dial_code": "+239", "code": "ST"},
  {"name": "Saudi Arabia", "dial_code": "+966", "code": "SA"},
  {"name": "Senegal", "dial_code": "+221", "code": "SN"},
  {"name": "Serbia", "dial_code": "+381", "code": "RS"},
  {"name": "Seychelles", "dial_code": "+248", "code": "SC"},
  {"name": "Sierra Leone", "dial_code": "+232", "code": "SL"},
  {"name": "Singapore", "dial_code": "+65", "code": "SG"},
  {"name": "Slovakia", "dial_code": "+421", "code": "SK"},
  {"name": "Slovenia", "dial_code": "+386", "code": "SI"},
  {"name": "Solomon Islands", "dial_code": "+677", "code": "SB"},
  {"name": "Somalia", "dial_code": "+252", "code": "SO"},
  {"name": "South Africa", "dial_code": "+27", "code": "ZA"},
  {"name": "South Sudan", "dial_code": "+211", "code": "SS"},
  {
    "name": "South Georgia and the South Sandwich Islands",
    "dial_code": "+500",
    "code": "GS"
  },
  {"name": "Spain", "dial_code": "+34", "code": "ES"},
  {"name": "Sri Lanka", "dial_code": "+94", "code": "LK"},
  {"name": "Sudan", "dial_code": "+249", "code": "SD"},
  {"name": "Suriname", "dial_code": "+597", "code": "SR"},
  {"name": "Svalbard and Jan Mayen", "dial_code": "+47", "code": "SJ"},
  {"name": "Swaziland", "dial_code": "+268", "code": "SZ"},
  {"name": "Sweden", "dial_code": "+46", "code": "SE"},
  {"name": "Switzerland", "dial_code": "+41", "code": "CH"},
  {"name": "Syrian Arab Republic", "dial_code": "+963", "code": "SY"},
  {"name": "Tajikistan", "dial_code": "+992", "code": "TJ"},
  {
    "name": "Tanzania, United Republic of Tanzania",
    "dial_code": "+255",
    "code": "TZ"
  },
  {"name": "Thailand", "dial_code": "+66", "code": "TH"},
  {"name": "Timor-Leste", "dial_code": "+670", "code": "TL"},
  {"name": "Togo", "dial_code": "+228", "code": "TG"},
  {"name": "Tokelau", "dial_code": "+690", "code": "TK"},
  {"name": "Tonga", "dial_code": "+676", "code": "TO"},
  {"name": "Trinidad and Tobago", "dial_code": "+1868", "code": "TT"},
  {"name": "Tunisia", "dial_code": "+216", "code": "TN"},
  {"name": "Turkey", "dial_code": "+90", "code": "TR"},
  {"name": "Turkmenistan", "dial_code": "+993", "code": "TM"},
  {"name": "Turks and Caicos Islands", "dial_code": "+1649", "code": "TC"},
  {"name": "Tuvalu", "dial_code": "+688", "code": "TV"},
  {"name": "Uganda", "dial_code": "+256", "code": "UG"},
  {"name": "Ukraine", "dial_code": "+380", "code": "UA"},
  {"name": "United Arab Emirates", "dial_code": "+971", "code": "AE"},
  {"name": "United Kingdom", "dial_code": "+44", "code": "GB"},
  {"name": "United States", "dial_code": "+1", "code": "US"},
  {"name": "Uruguay", "dial_code": "+598", "code": "UY"},
  {"name": "Uzbekistan", "dial_code": "+998", "code": "UZ"},
  {"name": "Vanuatu", "dial_code": "+678", "code": "VU"},
  {
    "name": "Venezuela, Bolivarian Republic of Venezuela",
    "dial_code": "+58",
    "code": "VE"
  },
  {"name": "Vietnam", "dial_code": "+84", "code": "VN"},
  {"name": "Virgin Islands, British", "dial_code": "+1284", "code": "VG"},
  {"name": "Virgin Islands, U.S.", "dial_code": "+1340", "code": "VI"},
  {"name": "Wallis and Futuna", "dial_code": "+681", "code": "WF"},
  {"name": "Yemen", "dial_code": "+967", "code": "YE"},
  {"name": "Zambia", "dial_code": "+260", "code": "ZM"},
  {"name": "Zimbabwe", "dial_code": "+263", "code": "ZW"}
];

List<Map<String, String>> codes = [
  {
    "name": "افغانستان",
    "code": "AF",
    "dial_code": "+93",
  },
  {
    "name": "Åland",
    "code": "AX",
    "dial_code": "+358",
  },
  {
    "name": "Shqipëria",
    "code": "AL",
    "dial_code": "+355",
  },
  {
    "name": "الجزائر",
    "code": "DZ",
    "dial_code": "+213",
  },
  {
    "name": "American Samoa",
    "code": "AS",
    "dial_code": "+1684",
  },
  {
    "name": "Andorra",
    "code": "AD",
    "dial_code": "+376",
  },
  {
    "name": "Angola",
    "code": "AO",
    "dial_code": "+244",
  },
  {
    "name": "Anguilla",
    "code": "AI",
    "dial_code": "+1264",
  },
  {
    "name": "Antarctica",
    "code": "AQ",
    "dial_code": "+672",
  },
  {
    "name": "Antigua and Barbuda",
    "code": "AG",
    "dial_code": "+1268",
  },
  {
    "name": "Argentina",
    "code": "AR",
    "dial_code": "+54",
  },
  {
    "name": "Հայաստան",
    "code": "AM",
    "dial_code": "+374",
  },
  {
    "name": "Aruba",
    "code": "AW",
    "dial_code": "+297",
  },
  {
    "name": "Australia",
    "code": "AU",
    "dial_code": "+61",
  },
  {
    "name": "Österreich",
    "code": "AT",
    "dial_code": "+43",
  },
  {
    "name": "Azərbaycan",
    "code": "AZ",
    "dial_code": "+994",
  },
  {
    "name": "Bahamas",
    "code": "BS",
    "dial_code": "+1242",
  },
  {
    "name": "‏البحرين",
    "code": "BH",
    "dial_code": "+973",
  },
  {
    "name": "Bangladesh",
    "code": "BD",
    "dial_code": "+880",
  },
  {
    "name": "Barbados",
    "code": "BB",
    "dial_code": "+1246",
  },
  {
    "name": "Белару́сь",
    "code": "BY",
    "dial_code": "+375",
  },
  {
    "name": "België",
    "code": "BE",
    "dial_code": "+32",
  },
  {
    "name": "Belize",
    "code": "BZ",
    "dial_code": "+501",
  },
  {
    "name": "Bénin",
    "code": "BJ",
    "dial_code": "+229",
  },
  {
    "name": "Bermuda",
    "code": "BM",
    "dial_code": "+1441",
  },
  {
    "name": "ʼbrug-yul",
    "code": "BT",
    "dial_code": "+975",
  },
  {
    "name": "Bolivia",
    "code": "BO",
    "dial_code": "+591",
  },
  {
    "name": "Bosna i Hercegovina",
    "code": "BA",
    "dial_code": "+387",
  },
  {
    "name": "Botswana",
    "code": "BW",
    "dial_code": "+267",
  },
  {
    "name": "Bouvetøya",
    "code": "BV",
    "dial_code": "+47",
  },
  {
    "name": "Brasil",
    "code": "BR",
    "dial_code": "+55",
  },
  {
    "name": "British Indian Ocean Territory",
    "code": "IO",
    "dial_code": "+246",
  },
  {
    "name": "Negara Brunei Darussalam",
    "code": "BN",
    "dial_code": "+673",
  },
  {
    "name": "България",
    "code": "BG",
    "dial_code": "+359",
  },
  {
    "name": "Burkina Faso",
    "code": "BF",
    "dial_code": "+226",
  },
  {
    "name": "Burundi",
    "code": "BI",
    "dial_code": "+257",
  },
  {
    "name": "Cambodia",
    "code": "KH",
    "dial_code": "+855",
  },
  {
    "name": "Cameroon",
    "code": "CM",
    "dial_code": "+237",
  },
  {
    "name": "Canada",
    "code": "CA",
    "dial_code": "+1",
  },
  {
    "name": "Cabo Verde",
    "code": "CV",
    "dial_code": "+238",
  },
  {
    "name": "Cayman Islands",
    "code": "KY",
    "dial_code": "+1345",
  },
  {
    "name": "Ködörösêse tî Bêafrîka",
    "code": "CF",
    "dial_code": "+236",
  },
  {
    "name": "Tchad",
    "code": "TD",
    "dial_code": "+235",
  },
  {
    "name": "Chile",
    "code": "CL",
    "dial_code": "+56",
  },
  {
    "name": "中国",
    "code": "CN",
    "dial_code": "+86",
  },
  {
    "name": "Christmas Island",
    "code": "CX",
    "dial_code": "+61",
  },
  {
    "name": "Cocos (Keeling) Islands",
    "code": "CC",
    "dial_code": "+61",
  },
  {
    "name": "Colombia",
    "code": "CO",
    "dial_code": "+57",
  },
  {
    "name": "Komori",
    "code": "KM",
    "dial_code": "+269",
  },
  {
    "name": "République du Congo",
    "code": "CG",
    "dial_code": "+242",
  },
  {
    "name": "République démocratique du Congo",
    "code": "CD",
    "dial_code": "+243",
  },
  {
    "name": "Cook Islands",
    "code": "CK",
    "dial_code": "+682",
  },
  {
    "name": "Costa Rica",
    "code": "CR",
    "dial_code": "+506",
  },
  {
    "name": "Côte d'Ivoire",
    "code": "CI",
    "dial_code": "+225",
  },
  {
    "name": "Hrvatska",
    "code": "HR",
    "dial_code": "+385",
  },
  {
    "name": "Cuba",
    "code": "CU",
    "dial_code": "+53",
  },
  {
    "name": "Κύπρος",
    "code": "CY",
    "dial_code": "+357",
  },
  {
    "name": "Česká republika",
    "code": "CZ",
    "dial_code": "+420",
  },
  {
    "name": "Danmark",
    "code": "DK",
    "dial_code": "+45",
  },
  {
    "name": "Djibouti",
    "code": "DJ",
    "dial_code": "+253",
  },
  {
    "name": "Dominica",
    "code": "DM",
    "dial_code": "+1767",
  },
  {
    "name": "República Dominicana",
    "code": "DO",
    "dial_code": "+1",
  },
  {
    "name": "Ecuador",
    "code": "EC",
    "dial_code": "+593",
  },
  {
    "name": "مصر‎",
    "code": "EG",
    "dial_code": "+20",
  },
  {
    "name": "El Salvador",
    "code": "SV",
    "dial_code": "+503",
  },
  {
    "name": "Guinea Ecuatorial",
    "code": "GQ",
    "dial_code": "+240",
  },
  {
    "name": "ኤርትራ",
    "code": "ER",
    "dial_code": "+291",
  },
  {
    "name": "Eesti",
    "code": "EE",
    "dial_code": "+372",
  },
  {
    "name": "ኢትዮጵያ",
    "code": "ET",
    "dial_code": "+251",
  },
  {
    "name": "Falkland Islands",
    "code": "FK",
    "dial_code": "+500",
  },
  {
    "name": "Føroyar",
    "code": "FO",
    "dial_code": "+298",
  },
  {
    "name": "Fiji",
    "code": "FJ",
    "dial_code": "+679",
  },
  {
    "name": "Suomi",
    "code": "FI",
    "dial_code": "+358",
  },
  {
    "name": "France",
    "code": "FR",
    "dial_code": "+33",
  },
  {
    "name": "Guyane française",
    "code": "GF",
    "dial_code": "+594",
  },
  {
    "name": "Polynésie française",
    "code": "PF",
    "dial_code": "+689",
  },
  {
    "name": "Territoire des Terres australes et antarctiques fr",
    "code": "TF",
    "dial_code": "+262",
  },
  {
    "name": "Gabon",
    "code": "GA",
    "dial_code": "+241",
  },
  {
    "name": "Gambia",
    "code": "GM",
    "dial_code": "+220",
  },
  {
    "name": "საქართველო",
    "code": "GE",
    "dial_code": "+995",
  },
  {
    "name": "Deutschland",
    "code": "DE",
    "dial_code": "+49",
  },
  {
    "name": "Ghana",
    "code": "GH",
    "dial_code": "+233",
  },
  {
    "name": "Gibraltar",
    "code": "GI",
    "dial_code": "+350",
  },
  {
    "name": "Ελλάδα",
    "code": "GR",
    "dial_code": "+30",
  },
  {
    "name": "Kalaallit Nunaat",
    "code": "GL",
    "dial_code": "+299",
  },
  {
    "name": "Grenada",
    "code": "GD",
    "dial_code": "+1473",
  },
  {
    "name": "Guadeloupe",
    "code": "GP",
    "dial_code": "+590",
  },
  {
    "name": "Guam",
    "code": "GU",
    "dial_code": "+1671",
  },
  {
    "name": "Guatemala",
    "code": "GT",
    "dial_code": "+502",
  },
  {
    "name": "Guernsey",
    "code": "GG",
    "dial_code": "+44",
  },
  {
    "name": "Guinée",
    "code": "GN",
    "dial_code": "+224",
  },
  {
    "name": "Guiné-Bissau",
    "code": "GW",
    "dial_code": "+245",
  },
  {
    "name": "Guyana",
    "code": "GY",
    "dial_code": "+592",
  },
  {
    "name": "Haïti",
    "code": "HT",
    "dial_code": "+509",
  },
  {
    "name": "Heard Island and McDonald Islands",
    "code": "HM",
    "dial_code": "+0",
  },
  {
    "name": "Vaticano",
    "code": "VA",
    "dial_code": "+379",
  },
  {
    "name": "Honduras",
    "code": "HN",
    "dial_code": "+504",
  },
  {
    "name": "香港",
    "code": "HK",
    "dial_code": "+852",
  },
  {
    "name": "Magyarország",
    "code": "HU",
    "dial_code": "+36",
  },
  {
    "name": "Ísland",
    "code": "IS",
    "dial_code": "+354",
  },
  {
    "name": "भारत",
    "code": "IN",
    "dial_code": "+91",
  },
  {
    "name": "Indonesia",
    "code": "ID",
    "dial_code": "+62",
  },
  {
    "name": "ایران",
    "code": "IR",
    "dial_code": "+98",
  },
  {
    "name": "العراق",
    "code": "IQ",
    "dial_code": "+964",
  },
  {
    "name": "Éire",
    "code": "IE",
    "dial_code": "+353",
  },
  {
    "name": "Isle of Man",
    "code": "IM",
    "dial_code": "+44",
  },
  {
    "name": "ישראל",
    "code": "IL",
    "dial_code": "+972",
  },
  {
    "name": "Italia",
    "code": "IT",
    "dial_code": "+39",
  },
  {
    "name": "Jamaica",
    "code": "JM",
    "dial_code": "+1876",
  },
  {
    "name": "日本",
    "code": "JP",
    "dial_code": "+81",
  },
  {
    "name": "Jersey",
    "code": "JE",
    "dial_code": "+44",
  },
  {
    "name": "الأردن",
    "code": "JO",
    "dial_code": "+962",
  },
  {
    "name": "Қазақстан",
    "code": "KZ",
    "dial_code": "+7",
  },
  {
    "name": "Kenya",
    "code": "KE",
    "dial_code": "+254",
  },
  {
    "name": "Kiribati",
    "code": "KI",
    "dial_code": "+686",
  },
  {
    "name": "북한",
    "code": "KP",
    "dial_code": "+850",
  },
  {
    "name": "대한민국",
    "code": "KR",
    "dial_code": "+82",
  },
  {
    "name": "Republika e Kosovës",
    "code": "XK",
    "dial_code": "+383",
  },
  {
    "name": "الكويت",
    "code": "KW",
    "dial_code": "+965",
  },
  {
    "name": "Кыргызстан",
    "code": "KG",
    "dial_code": "+996",
  },
  {
    "name": "ສປປລາວ",
    "code": "LA",
    "dial_code": "+856",
  },
  {
    "name": "Latvija",
    "code": "LV",
    "dial_code": "+371",
  },
  {
    "name": "لبنان",
    "code": "LB",
    "dial_code": "+961",
  },
  {
    "name": "Lesotho",
    "code": "LS",
    "dial_code": "+266",
  },
  {
    "name": "Liberia",
    "code": "LR",
    "dial_code": "+231",
  },
  {
    "name": "‏ليبيا",
    "code": "LY",
    "dial_code": "+218",
  },
  {
    "name": "Liechtenstein",
    "code": "LI",
    "dial_code": "+423",
  },
  {
    "name": "Lietuva",
    "code": "LT",
    "dial_code": "+370",
  },
  {
    "name": "Luxembourg",
    "code": "LU",
    "dial_code": "+352",
  },
  /*{
    "name": "澳門",
    "code": "MO",
    "dial_code": "+853",
  },*/
  {
    "name": "Македонија",
    "code": "MK",
    "dial_code": "+389",
  },
  {
    "name": "Madagasikara",
    "code": "MG",
    "dial_code": "+261",
  },
  {
    "name": "Malawi",
    "code": "MW",
    "dial_code": "+265",
  },
  {
    "name": "Malaysia",
    "code": "MY",
    "dial_code": "+60",
  },
  {
    "name": "Maldives",
    "code": "MV",
    "dial_code": "+960",
  },
  {
    "name": "Mali",
    "code": "ML",
    "dial_code": "+223",
  },
  {
    "name": "Malta",
    "code": "MT",
    "dial_code": "+356",
  },
  {
    "name": "M̧ajeļ",
    "code": "MH",
    "dial_code": "+692",
  },
  {
    "name": "Martinique",
    "code": "MQ",
    "dial_code": "+596",
  },
  {
    "name": "موريتانيا",
    "code": "MR",
    "dial_code": "+222",
  },
  {
    "name": "Maurice",
    "code": "MU",
    "dial_code": "+230",
  },
  {
    "name": "Mayotte",
    "code": "YT",
    "dial_code": "+262",
  },
  {
    "name": "México",
    "code": "MX",
    "dial_code": "+52",
  },
  {
    "name": "Micronesia",
    "code": "FM",
    "dial_code": "+691",
  },
  {
    "name": "Moldova",
    "code": "MD",
    "dial_code": "+373",
  },
  {
    "name": "Monaco",
    "code": "MC",
    "dial_code": "+377",
  },
  {
    "name": "Монгол улс",
    "code": "MN",
    "dial_code": "+976",
  },
  {
    "name": "Црна Гора",
    "code": "ME",
    "dial_code": "+382",
  },
  {
    "name": "Montserrat",
    "code": "MS",
    "dial_code": "+1664",
  },
  {
    "name": "المغرب",
    "code": "MA",
    "dial_code": "+212",
  },
  {
    "name": "Moçambique",
    "code": "MZ",
    "dial_code": "+258",
  },
  {
    "name": "Myanmar",
    "code": "MM",
    "dial_code": "+95",
  },
  {
    "name": "Namibia",
    "code": "NA",
    "dial_code": "+264",
  },
  {
    "name": "Nauru",
    "code": "NR",
    "dial_code": "+674",
  },
  {
    "name": "नपल",
    "code": "NP",
    "dial_code": "+977",
  },
  {
    "name": "Nederland",
    "code": "NL",
    "dial_code": "+31",
  },
  {
    "name": "Netherlands Antilles",
    "code": "AN",
    "dial_code": "+599",
  },
  {
    "name": "Nouvelle-Calédonie",
    "code": "NC",
    "dial_code": "+687",
  },
  {
    "name": "New Zealand",
    "code": "NZ",
    "dial_code": "+64",
  },
  {
    "name": "Nicaragua",
    "code": "NI",
    "dial_code": "+505",
  },
  {
    "name": "Niger",
    "code": "NE",
    "dial_code": "+227",
  },
  {
    "name": "Nigeria",
    "code": "NG",
    "dial_code": "+234",
  },
  {
    "name": "Niuē",
    "code": "NU",
    "dial_code": "+683",
  },
  {
    "name": "Norfolk Island",
    "code": "NF",
    "dial_code": "+672",
  },
  {
    "name": "Northern Mariana Islands",
    "code": "MP",
    "dial_code": "+1670",
  },
  {
    "name": "Norge",
    "code": "NO",
    "dial_code": "+47",
  },
  {
    "name": "عمان",
    "code": "OM",
    "dial_code": "+968",
  },
  {
    "name": "Pakistan",
    "code": "PK",
    "dial_code": "+92",
  },
  {
    "name": "Palau",
    "code": "PW",
    "dial_code": "+680",
  },
  {
    "name": "فلسطين",
    "code": "PS",
    "dial_code": "+970",
  },
  {
    "name": "Panamá",
    "code": "PA",
    "dial_code": "+507",
  },
  {
    "name": "Papua Niugini",
    "code": "PG",
    "dial_code": "+675",
  },
  {
    "name": "Paraguay",
    "code": "PY",
    "dial_code": "+595",
  },
  {
    "name": "Perú",
    "code": "PE",
    "dial_code": "+51",
  },
  {
    "name": "Pilipinas",
    "code": "PH",
    "dial_code": "+63",
  },
  {
    "name": "Pitcairn Islands",
    "code": "PN",
    "dial_code": "+64",
  },
  {
    "name": "Polska",
    "code": "PL",
    "dial_code": "+48",
  },
  {
    "name": "Portugal",
    "code": "PT",
    "dial_code": "+351",
  },
  {
    "name": "Puerto Rico",
    "code": "PR",
    "dial_code": "+1939",
  },
  {
    "name": "Puerto Rico",
    "code": "PR",
    "dial_code": "+1787",
  },
  {
    "name": "قطر",
    "code": "QA",
    "dial_code": "+974",
  },
  {
    "name": "România",
    "code": "RO",
    "dial_code": "+40",
  },
  {
    "name": "Россия",
    "code": "RU",
    "dial_code": "+7",
  },
  {
    "name": "Rwanda",
    "code": "RW",
    "dial_code": "+250",
  },
  {
    "name": "La Réunion",
    "code": "RE",
    "dial_code": "+262",
  },
  {
    "name": "Saint-Barthélemy",
    "code": "BL",
    "dial_code": "+590",
  },
  {
    "name": "Saint Helena",
    "code": "SH",
    "dial_code": "+290",
  },
  {
    "name": "Saint Kitts and Nevis",
    "code": "KN",
    "dial_code": "+1869",
  },
  {
    "name": "Saint Lucia",
    "code": "LC",
    "dial_code": "+1758",
  },
  {
    "name": "Saint-Martin",
    "code": "MF",
    "dial_code": "+590",
  },
  {
    "name": "Saint-Pierre-et-Miquelon",
    "code": "PM",
    "dial_code": "+508",
  },
  {
    "name": "Saint Vincent and the Grenadines",
    "code": "VC",
    "dial_code": "+1784",
  },
  {
    "name": "Samoa",
    "code": "WS",
    "dial_code": "+685",
  },
  {
    "name": "San Marino",
    "code": "SM",
    "dial_code": "+378",
  },
  {
    "name": "São Tomé e Príncipe",
    "code": "ST",
    "dial_code": "+239",
  },
  {
    "name": "العربية السعودية",
    "code": "SA",
    "dial_code": "+966",
  },
  {
    "name": "Sénégal",
    "code": "SN",
    "dial_code": "+221",
  },
  {
    "name": "Србија",
    "code": "RS",
    "dial_code": "+381",
  },
  {
    "name": "Seychelles",
    "code": "SC",
    "dial_code": "+248",
  },
  {
    "name": "Sierra Leone",
    "code": "SL",
    "dial_code": "+232",
  },
  {
    "name": "Singapore",
    "code": "SG",
    "dial_code": "+65",
  },
  {
    "name": "Slovensko",
    "code": "SK",
    "dial_code": "+421",
  },
  {
    "name": "Slovenija",
    "code": "SI",
    "dial_code": "+386",
  },
  {
    "name": "Solomon Islands",
    "code": "SB",
    "dial_code": "+677",
  },
  {
    "name": "Soomaaliya",
    "code": "SO",
    "dial_code": "+252",
  },
  {
    "name": "South Africa",
    "code": "ZA",
    "dial_code": "+27",
  },
  {
    "name": "South Sudan",
    "code": "SS",
    "dial_code": "+211",
  },
  {
    "name": "South Georgia",
    "code": "GS",
    "dial_code": "+500",
  },
  {
    "name": "España",
    "code": "ES",
    "dial_code": "+34",
  },
  {
    "name": "Sri Lanka",
    "code": "LK",
    "dial_code": "+94",
  },
  {
    "name": "السودان",
    "code": "SD",
    "dial_code": "+249",
  },
  {
    "name": "Suriname",
    "code": "SR",
    "dial_code": "+597",
  },
  {
    "name": "Svalbard og Jan Mayen",
    "code": "SJ",
    "dial_code": "+47",
  },
  {
    "name": "Swaziland",
    "code": "SZ",
    "dial_code": "+268",
  },
  {
    "name": "Sverige",
    "code": "SE",
    "dial_code": "+46",
  },
  {
    "name": "Schweiz",
    "code": "CH",
    "dial_code": "+41",
  },
  {
    "name": "سوريا",
    "code": "SY",
    "dial_code": "+963",
  },
  /*{
    "name": "臺灣",
    "code": "TW",
    "dial_code": "+886",
  },*/
  {
    "name": "Тоҷикистон",
    "code": "TJ",
    "dial_code": "+992",
  },
  {
    "name": "Tanzania",
    "code": "TZ",
    "dial_code": "+255",
  },
  {
    "name": "ประเทศไทย",
    "code": "TH",
    "dial_code": "+66",
  },
  {
    "name": "Timor-Leste",
    "code": "TL",
    "dial_code": "+670",
  },
  {
    "name": "Togo",
    "code": "TG",
    "dial_code": "+228",
  },
  {
    "name": "Tokelau",
    "code": "TK",
    "dial_code": "+690",
  },
  {
    "name": "Tonga",
    "code": "TO",
    "dial_code": "+676",
  },
  {
    "name": "Trinidad and Tobago",
    "code": "TT",
    "dial_code": "+1868",
  },
  {
    "name": "تونس",
    "code": "TN",
    "dial_code": "+216",
  },
  {
    "name": "Türkiye",
    "code": "TR",
    "dial_code": "+90",
  },
  {
    "name": "Türkmenistan",
    "code": "TM",
    "dial_code": "+993",
  },
  {
    "name": "Turks and Caicos Islands",
    "code": "TC",
    "dial_code": "+1649",
  },
  {
    "name": "Tuvalu",
    "code": "TV",
    "dial_code": "+688",
  },
  {
    "name": "Uganda",
    "code": "UG",
    "dial_code": "+256",
  },
  {
    "name": "Україна",
    "code": "UA",
    "dial_code": "+380",
  },
  {
    "name": "دولة الإمارات العربية المتحدة",
    "code": "AE",
    "dial_code": "+971",
  },
  {
    "name": "United Kingdom",
    "code": "GB",
    "dial_code": "+44",
  },
  {
    "name": "United States",
    "code": "US",
    "dial_code": "+1",
  },
  {
    "name": "Uruguay",
    "code": "UY",
    "dial_code": "+598",
  },
  {
    "name": "O‘zbekiston",
    "code": "UZ",
    "dial_code": "+998",
  },
  {
    "name": "Vanuatu",
    "code": "VU",
    "dial_code": "+678",
  },
  {
    "name": "Venezuela",
    "code": "VE",
    "dial_code": "+58",
  },
  {
    "name": "Việt Nam",
    "code": "VN",
    "dial_code": "+84",
  },
  {
    "name": "British Virgin Islands",
    "code": "VG",
    "dial_code": "+1284",
  },
  {
    "name": "United States Virgin Islands",
    "code": "VI",
    "dial_code": "+1340",
  },
  {
    "name": "Wallis et Futuna",
    "code": "WF",
    "dial_code": "+681",
  },
  {
    "name": "اليَمَن",
    "code": "YE",
    "dial_code": "+967",
  },
  {
    "name": "Zambia",
    "code": "ZM",
    "dial_code": "+260",
  },
  {
    "name": "Zimbabwe",
    "code": "ZW",
    "dial_code": "+263",
  },
];

/* class CountryListLayout extends StatelessWidget {
  final Function(CountryCodeCustom?)? onChanged;

  const CountryListLayout({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
            height: Sizes.s50,
            child: CountryListPickCustom(
                appBar: AppBar(
                    centerTitle: true,
                    title: Text(language(context, "Select Country"),
                        style: appCss.dmDenseblack16
                            .textColor(appColor(context).appTheme.whiteBg)),
                    elevation: 0,
                    backgroundColor: appColor(context).appTheme.primary),
                countryBuilder: (context, countryCode) => Container(
                    height: 50,
                    color: Colors.white,
                    child: Material(
                        color: Colors.transparent,
                        child: ListTile(
                            leading:
                                Image.asset(countryCode.flagUri!, width: 30.0),
                            title: Text(countryCode.name!,
                                style: appCss.dmDenseMedium14.textColor(
                                    appColor(context).appTheme.darkText)),
                            onTap: () {
                              Navigator.pop(context, countryCode);
                            }))),
                pickerBuilder: (context, CountryCodeCustom? countryCode) {
                  return Row(children: [
                    Image.asset("${countryCode!.flagUri}",
                        width: Sizes.s22, height: Sizes.s16),
                    Text(countryCode.dialCode.toString(),
                            style: appCss.dmDenseMedium14
                                .textColor(appColor(context).appTheme.darkText))
                        .paddingSymmetric(horizontal: Insets.i5),
                    Icon(CupertinoIcons.chevron_down,
                        size: Sizes.s16,
                        color: appColor(context).appTheme.darkText)
                  ]);
                },
                theme: CountryTheme(
                    isShowFlag: true,
                    alphabetSelectedBackgroundColor:
                        appColor(context).appTheme.primary),
                initialSelection: '+91',
                onChanged: onChanged))
        .decorated(color: appColor(context).appTheme.whiteBg);
  }
}
 */

class CountryListLayout extends StatelessWidget {
  final Function(CountryCodeCustom?)? onChanged;
  final String? dialCode;
  const CountryListLayout({super.key, this.onChanged, this.dialCode});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileDetailProvider>(builder: (context1, value, child) {
      // log("djkhgdfjhg:$dialCode");
      return SizedBox(
              height: Sizes.s50,
              child: CountryListPickCustom(
                appBar: AppBar(
                    centerTitle: true,
                    title: Text(language(context, translations!.selectCountry),
                        style: appCss.dmDenseBold20
                            .textColor(appColor(context).appTheme.whiteBg)),
                    elevation: 0,
                    backgroundColor: appColor(context).appTheme.primary),
                countryBuilder: (context, countryCode) => Container(
                  height: 50,
                  color: appColor(context).appTheme.whiteBg,
                  child: Material(
                    color: Colors.transparent,
                    child: ListTile(
                      leading: Image.asset(
                        countryCode.flagUri!,
                        // package: 'country_list_pick',
                        width: 30.0,
                      ),
                      title: Text(
                        countryCode.name!,
                        style: appCss.dmDenseMedium14
                            .textColor(appColor(context).appTheme.darkText),
                      ),
                      onTap: () {
                        Navigator.pop(context, countryCode);
                      },
                    ),
                  ),
                ),
                pickerBuilder: (context, CountryCodeCustom? countryCode) {
                  return Row(children: [
                    Image.asset("${countryCode!.flagUri}",
                        // package: 'country_list_pick',
                        width: Sizes.s22,
                        height: Sizes.s16),
                    Text(countryCode.dialCode.toString(),
                            style: appCss.dmDenseMedium14
                                .textColor(appColor(context).appTheme.darkText))
                        .paddingSymmetric(horizontal: Insets.i5),
                    Icon(CupertinoIcons.chevron_down,
                        size: Sizes.s16,
                        color: appColor(context).appTheme.darkText)
                  ]);
                },
                theme: CountryTheme(
                    isShowFlag: true,
                    labelColor: appColor(context).appTheme.darkText,
                    alphabetTextColor: appColor(context).appTheme.darkText,
                    alphabetSelectedTextColor:
                        appColor(context).appTheme.whiteColor,
                    alphabetSelectedBackgroundColor:
                        appColor(context).appTheme.primary),
                initialSelection: dialCode,
                onChanged: onChanged,
              ))
          .decorated(
              color: appColor(context).appTheme.whiteBg,
              borderRadius:
                  const BorderRadius.all(Radius.circular(AppRadius.r8)));
    });
  }
}
